import copy
import hashlib
import json
import subprocess
import sys
import tempfile
import unittest
from fractions import Fraction
from pathlib import Path

from tools.compile_decimal import DecimalCompiler
from tools.decimal_runtime import NumericRuntime
from tools.decimal_model import DecimalFault
from tools.request_binding import check_env
from tests.test_prototype import ROOT


class DecimalCompilerTests(unittest.TestCase):
    def setUp(self):
        self.artifact = json.loads((ROOT / "fixtures/decimal-dependency.artifact.json").read_text())
        self.env = {"amount": {"kind": "decimal", "value": "1.005"}}

    def compile(self, artifact=None, output="doubled"):
        return DecimalCompiler(artifact or self.artifact, "2025-01-01", self.env).emit(output, "Test")

    def test_dependency_definition_precedes_consumer(self):
        source = self.compile()
        self.assertIn("Expr.rounded 2 .halfUp", source)
        self.assertIn("Expr.binary .mul rule_0", source)
        self.assertLess(source.index("def rule_0"), source.index("def rule_1"))
        self.assertEqual(source, self.compile())

    def test_four_modes(self):
        for mode, lean in [("half_even", "halfEven"), ("floor", "floor"), ("ceil", "ceil")]:
            with self.subTest(mode=mode):
                self.assertIn(f"Expr.rounded 2 .{lean}", self.compile(output=f"doubled_{mode}"))

    def test_cycle_rejected(self):
        artifact = copy.deepcopy(self.artifact)
        artifact["program"]["derived"][0]["versions"][0]["expr"] = {"kind": "derived", "name": "doubled"}
        with self.assertRaisesRegex(ValueError, "cycle"):
            self.compile(artifact)

    def test_missing_input_and_version_rejected(self):
        for as_of, env, message in [("2025-01-01", {}, "missing prebound"),
                                    ("2024-01-01", self.env, "missing numeric rule version")]:
            with self.subTest(as_of=as_of), self.assertRaisesRegex(ValueError, message):
                DecimalCompiler(self.artifact, as_of, env).emit("doubled", "Test")

    def test_invalid_precision_rejected(self):
        artifact = copy.deepcopy(self.artifact)
        for unit in artifact["program"]["units"]:
            if unit["name"] == "USD":
                unit["minor_units"] = 29
        with self.assertRaisesRegex(ValueError, "invalid currency precision"):
            self.compile(artifact)

    def test_extrema_reject_empty_operands(self):
        artifact = copy.deepcopy(self.artifact)
        rule = next(r for r in artifact["program"]["derived"] if r["name"] == "bounded_whole_amount")
        for kind in ("min", "max"):
            rule["versions"][0]["expr"] = {"kind": kind, "items": []}
            with self.subTest(kind=kind), self.assertRaisesRegex(ValueError, "requires an operand"):
                self.compile(artifact, output=rule["name"])

    def test_compiler_and_runtime_reject_inexact_wire_values(self):
        runtime = NumericRuntime(self.artifact, "2025-01-01")
        for value in ({"kind": "decimal", "value": 1.25}, {"kind": "integer", "value": 2**63},
                      {"kind": "integer", "value": True}):
            env = {"amount": value}
            with self.subTest(value=value):
                with self.assertRaises(ValueError):
                    runtime.rule("doubled", env)
                with self.assertRaises(ValueError):
                    DecimalCompiler(self.artifact, "2025-01-01", env).emit("doubled", "Test")

    def test_boolean_condition_keeps_missing_reads_lazy(self):
        program = self.artifact["program"]
        program["interface"]["inputs"].append({"name": "flag", "dtype": "bool"})
        condition = {"kind": "comparison", "op": "ne", "left": {"kind": "input", "name": "flag"},
                     "right": {"kind": "literal", "value": {"kind": "bool", "value": True}}}
        program["derived"].append({"name": "result", "semantics": "judgment", "expr": {
            "kind": "and", "items": [{**condition, "left": condition["right"]}, condition],
        }})
        runtime = NumericRuntime(self.artifact, "2025-01-01")
        self.assertFalse(runtime.judgment("result", {}))
        generated = DecimalCompiler(self.artifact, "2025-01-01", {}, allow_missing=True).emit(
            "result", "Test", judgment=True)
        self.assertIn("(Predicate.compareBool false none (some true))", generated)
        program["derived"][-1]["expr"] = condition
        with self.assertRaisesRegex(DecimalFault, "^missingInput$"):
            runtime.judgment("result", {})

    def test_retained_automatic_generation(self):
        raw = (ROOT / "fixtures/decimal-dependency.artifact.json").read_bytes()
        report = json.loads((ROOT / "reports/v0.1/decimal/decimal-dependency.json").read_text())
        self.assertEqual(report["artifact_sha256"], hashlib.sha256(raw).hexdigest())
        self.assertEqual(report["cases"], 72)
        self.assertEqual(len(report["results"]), 72)
        source = (ROOT / "RuleSpecLean/DecimalDependencyTests.lean").read_text()
        for i, row in enumerate(report["results"]):
            env = {} if row["input"] is None else {"amount": {"kind": "decimal", "value": row["input"]}}
            if "covering_request" in row:
                check_env(self.artifact, {"rule": row["rule"], "env": env,
                          "request": row["covering_request"]},
                          validate_value=NumericRuntime.literal, covering=True)
            judgment = row.get("judgment", False)
            generated = DecimalCompiler(self.artifact, row["as_of"], env, allow_missing=True).emit(
                row["rule"], f"DecimalCase{i}", judgment=judgment)
            self.assertIn(generated.replace("import RuleSpecLean.Decimal\n", "", 1), source)
            runtime = NumericRuntime(self.artifact, row["as_of"])
            with self.subTest(row=row):
                if "fault" in row:
                    with self.assertRaises(DecimalFault) as caught:
                        (runtime.judgment if judgment else runtime.rule)(row["rule"], env)
                    self.assertEqual(str(caught.exception), row["fault"])
                elif "outcome" in row:
                    self.assertEqual(runtime.judgment(row["rule"], env), row["outcome"] == "holds")
                else:
                    actual = runtime.rule(row["rule"], env)
                    self.assertEqual(Fraction(actual.coefficient, 10**actual.scale), Fraction(row["output"]))

    def test_retained_flat_tax_decimal_generation(self):
        raw = (ROOT / "fixtures/upstream-flat-tax.artifact.json").read_bytes()
        cases_raw = (ROOT / "fixtures/upstream-flat-tax.cases.json").read_bytes()
        report = json.loads((ROOT / "reports/v0.1/decimal/decimal-flat-tax.json").read_text())
        self.assertEqual(report["artifact_sha256"], hashlib.sha256(raw).hexdigest())
        self.assertEqual(report["cases_sha256"], hashlib.sha256(cases_raw).hexdigest())
        artifact = json.loads(raw)
        self.assertEqual(report["engine_build"], artifact["engine_build"])
        cases = json.loads(cases_raw)
        self.assertEqual(report["cases"], len(cases))
        self.assertEqual(len(report["results"]), len(cases))
        source = (ROOT / "RuleSpecLean/DecimalFlatTaxTests.lean").read_text()
        for i, (case, row) in enumerate(zip(cases, report["results"])):
            with self.subTest(name=case["name"]):
                self.assertEqual(row["name"], case["name"])
                namespace = f"FlatTaxCase{i}"
                compiler = DecimalCompiler(artifact, case["as_of"], case["env"])
                generated = compiler.emit(case["rule"], namespace)
                self.assertIn(generated.replace("import RuleSpecLean.Decimal\n", "", 1), source)
                runtime = NumericRuntime(artifact, case["as_of"])
                actual = runtime.rule(case["rule"], case["env"])
                self.assertEqual(Fraction(actual.coefficient, 10**actual.scale), Fraction(row["output"]))

    def test_compile_cli_binds_covering_request(self):
        report = json.loads((ROOT / "reports/v0.1/decimal/decimal-dependency.json").read_text())
        row = next(row for row in report["results"] if "covering_request" in row)
        with tempfile.TemporaryDirectory() as tmp:
            request = Path(tmp) / "request.json"
            lean = Path(tmp) / "Result.lean"
            request.write_text(json.dumps(row["covering_request"]))
            command = [sys.executable, "-m", "tools.compile_decimal",
                       "fixtures/decimal-dependency.artifact.json", "--request", str(request),
                       "--output", row["rule"], "--lean", str(lean), "--as-of"]
            subprocess.run([*command, row["as_of"], "--covering"], cwd=ROOT,
                           capture_output=True, check=True, timeout=10)
            self.assertEqual(lean.read_text(), DecimalCompiler(self.artifact, row["as_of"], self.env)
                             .emit(row["rule"], "DecimalGenerated"))
            manifest = json.loads(lean.with_suffix(".manifest.json").read_text())
            self.assertEqual(manifest["binding"], "latest-covering")
            self.assertEqual(manifest["request_sha256"], hashlib.sha256(request.read_bytes()).hexdigest())
            for options, error in (([row["as_of"]], "input interval must equal query interval"),
                                   (["2024-01-01", "--covering"], "snapshot must equal query period start")):
                result = subprocess.run([*command, *options], cwd=ROOT, capture_output=True,
                                        text=True, timeout=10)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn(error, result.stderr)
