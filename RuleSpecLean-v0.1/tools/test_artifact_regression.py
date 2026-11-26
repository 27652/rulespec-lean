"""Offline replay of retained official results; not a fresh Rust execution."""
from datetime import date
import hashlib
import json
import unittest

from tools.compile_ir import Compiler, emit, lean_str, lean_value, parse_value, run
from tools.test_prototype import ROOT


class ArtifactRegressionTests(unittest.TestCase):
    def setUp(self):
        self.raw = (ROOT / "fixtures/upstream-flat-tax.artifact.json").read_bytes()
        self.artifact = json.loads(self.raw)
        self.cases = json.loads((ROOT / "fixtures/upstream-flat-tax.cases.json").read_text())
        self.report = json.loads((ROOT / "reports/reference.json").read_text())
        self.compiler = Compiler(self.artifact, self.cases[0]["as_of"])
        self.compiler.compile([self.cases[0]["rule"]])

    def test_artifact_and_engine_identity(self):
        pin = json.loads((ROOT / "fixtures/upstream-pin.json").read_text())
        self.assertEqual(hashlib.sha256(self.raw).hexdigest(), self.report["artifact_sha256"])
        self.assertEqual(self.artifact["engine_build"]["commit"], pin["commit"])
        self.assertIs(self.artifact["engine_build"]["dirty"], False)
        self.assertEqual(self.artifact["engine_build"], self.report["engine_build"])

    def test_retained_results(self):
        self.assertEqual(len(self.cases), 107)
        self.assertEqual(self.report["cases"], len(self.cases))
        self.assertEqual(len(self.report["results"]), len(self.cases))
        for case, row in zip(self.cases, self.report["results"]):
            with self.subTest(case=case["name"]):
                self.assertEqual(case["name"], row["name"])
                self.assertEqual(row["status"], "matched")
                self.assertEqual(list(run(self.compiler.normal[case["rule"]],
                                          case["env"], self.compiler.normal)), row["result"])

    def test_generated_module_is_current(self):
        source, _ = emit(self.compiler, [self.cases[0]["rule"]])
        self.assertEqual(source, (ROOT / "RuleSpecLean/Reference.lean").read_text())

    def test_generated_guards_are_current(self):
        lines = ["import RuleSpecLean.Reference", "", "open RuleSpecLean", ""]
        for case, row in zip(self.cases, self.report["results"]):
            env = ", ".join(f"({lean_str(k)}, {lean_value(parse_value(v))})"
                            for k, v in sorted(case["env"].items()))
            lines.append(f"#guard sameResult (eval [{env}] Generated.output_0) (.ok {lean_value(row['result'])})")
        self.assertEqual("\n".join(lines) + "\n",
                         (ROOT / "RuleSpecLean/ReferenceTests.lean").read_text())


class LegalArtifactRegressionTests(unittest.TestCase):
    def test_proof_version_matches_retained_artifact(self):
        artifact = json.loads((ROOT / "fixtures/legal-3403.artifact.json").read_text())
        rule = next(row for row in artifact["program"]["derived"]
                    if row["name"] == "employer_liability_for_chapter_withholding_tax_payment")
        versions = rule["versions"]
        self.assertEqual(len(versions), 1)
        self.assertIsNone(versions[0].get("effective_to"))
        ordinal = date.fromisoformat(versions[0]["effective_from"]).toordinal()
        source = (ROOT / "RuleSpecLean/Legal3403Preservation.lean").read_text()
        self.assertIn(f"def firstDay : Int := {ordinal}\n", source)

    def test_retained_legal_results_and_identity(self):
        raw = (ROOT / "fixtures/legal-3403.artifact.json").read_bytes()
        artifact = json.loads(raw)
        cases = json.loads((ROOT / "fixtures/legal-3403.cases.json").read_text())
        report = json.loads((ROOT / "reports/legal-3403.json").read_text())
        pin = json.loads((ROOT / "fixtures/legal-pin.json").read_text())
        self.assertEqual(hashlib.sha256(raw).hexdigest(), report["artifact_sha256"])
        self.assertEqual(hashlib.sha256((ROOT / "fixtures/legal-3403.rules.yaml").read_bytes()).hexdigest(),
                         pin["source_sha256"])
        self.assertEqual(len(cases), 105)
        self.assertEqual(len(report["results"]), len(cases))
        compiler = Compiler(artifact, cases[0]["as_of"])
        compiler.compile([cases[0]["rule"]])
        source, _ = emit(compiler, [cases[0]["rule"]])
        self.assertEqual(source, (ROOT / "RuleSpecLean/Legal3403.lean").read_text())
        for case, row in zip(cases, report["results"]):
            with self.subTest(case=case["name"]):
                self.assertEqual(case["name"], row["name"])
                self.assertEqual(list(run(compiler.normal[case["rule"]], case["env"],
                                          compiler.normal)), row["result"])
