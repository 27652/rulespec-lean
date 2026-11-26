import copy
import hashlib
import json
import unittest

from tools.compile_ir import Unsupported
from tools.compile_decimal import DecimalCompiler
from tools.decimal_model import DecimalFault, DecimalValue, snapshot_literal
from tools.decimal_runtime import NumericRuntime
from tools.request_binding import bind, check_env, member_key
from tests.test_prototype import ROOT


class BindingTests(unittest.TestCase):
    def setUp(self):
        self.artifact = json.loads((ROOT / "fixtures/legal-3403.artifact.json").read_text())
        self.case = json.loads((ROOT / "fixtures/legal-3403.cases.json").read_text())[0]

    def test_actual_binding(self):
        self.assertEqual(check_env(self.artifact, self.case), self.case["env"])

    def test_env_mismatch(self):
        self.case["env"] = {}
        with self.assertRaisesRegex(Unsupported, "differs"):
            check_env(self.artifact, self.case)

    def test_unsupported_binding_shapes(self):
        for field, value in [("entity_id", "other"), ("entity", "Person"),
                             ("name", "invented#input"),
                             ("interval", {"start": "2025-01-01", "end": "2027-01-01"})]:
            case = copy.deepcopy(self.case)
            case["request"]["dataset"]["inputs"][0][field] = value
            with self.subTest(field=field), self.assertRaises(Unsupported):
                check_env(self.artifact, case)

    def test_identical_spells_are_redundant_but_conflicting_spells_fail(self):
        facts = self.case["request"]["dataset"]["inputs"]
        duplicate = copy.deepcopy(facts[0])
        facts.append(duplicate)
        self.assertEqual(check_env(self.artifact, self.case), self.case["env"])
        duplicate["value"] = {"kind": "decimal", "value": "999999"}
        with self.assertRaisesRegex(Unsupported, "conflicting input spell start"):
            check_env(self.artifact, self.case)

    def test_defaults_rejected(self):
        self.artifact["program"]["interface"]["inputs"][0]["default"] = {"kind": "integer", "value": 0}
        with self.assertRaisesRegex(Unsupported, "defaults"):
            check_env(self.artifact, self.case)

    def test_malformed_request_is_rejected_at_binding_boundary(self):
        for field, value, reason in (("queries", [None], "query fields"),
                                     ("dataset", {"inputs": None}, "records must be lists"),
                                     ("dataset", {"inputs": [None]}, "input fields")):
            with self.subTest(field=field, value=value):
                request = {**self.case["request"], field: value}
                with self.assertRaisesRegex(Unsupported, reason):
                    bind(self.artifact, request, self.case["rule"])


class SelectedYearBindingTests(unittest.TestCase):
    def test_inactive_formula_does_not_bind_historical_slot(self):
        artifact = json.loads((ROOT / "fixtures/selected-year.artifact.json").read_text())
        case = json.loads((ROOT / "reports/v0.1/binding/selected-year.json").read_text())["results"][0]
        rule = artifact["program"]["derived"][0]
        rule["versions"].append({"effective_from": case["as_of"], "semantics": "scalar",
                                 "expr": {"kind": "literal", "value": {"kind": "integer", "value": 1}}})
        case["env"] = {}
        self.assertEqual(check_env(artifact, case, covering=True,
                                   validate_value=DecimalValue.from_literal), {})

    def test_retained_official_results(self):
        raw = (ROOT / "fixtures/selected-year.artifact.json").read_bytes()
        artifact = json.loads(raw)
        report = json.loads((ROOT / "reports/v0.1/binding/selected-year.json").read_text())
        self.assertEqual(report["artifact_sha256"], hashlib.sha256(raw).hexdigest())
        self.assertEqual(report["engine_build"], artifact["engine_build"])
        self.assertEqual(report["cases"], len(report["results"]))
        source = (ROOT / "RuleSpecLean/SelectedYearTests.lean").read_text()
        for index, case in enumerate(report["results"]):
            with self.subTest(name=case["name"]):
                env = check_env(artifact, case, covering=True, validate_value=DecimalValue.from_literal)
                runtime = NumericRuntime(artifact, case["as_of"])
                compiler = DecimalCompiler(artifact, case["as_of"], env, allow_missing=True)
                generated = compiler.emit(case["rule"], f"SelectedYearCase{index}")
                self.assertIn(generated.removeprefix("import RuleSpecLean.Decimal\n"), source)
                if "fault" in case:
                    with self.assertRaisesRegex(DecimalFault, f"^{case['fault']}$"):
                        runtime.rule(case["rule"], env)
                else:
                    self.assertEqual(runtime.rule(case["rule"], env), DecimalValue.parse(case["output"]))


class DirectCountBindingTests(unittest.TestCase):
    def setUp(self):
        self.raw = (ROOT / "fixtures/direct-count.artifact.json").read_bytes()
        self.artifact = json.loads(self.raw)
        self.report = json.loads((ROOT / "reports/v0.1/binding/direct-count.json").read_text())

    def test_retained_counts(self):
        self.assertEqual(self.report["artifact_sha256"], hashlib.sha256(self.raw).hexdigest())
        source = (ROOT / "RuleSpecLean/DirectCountTests.lean").read_text()
        for index, case in enumerate(self.report["results"]):
            with self.subTest(index=index):
                filtered = case.get("filtered_counts", False)
                env = check_env(self.artifact, case, relation_counts=True, filtered_counts=filtered,
                                validate_value=snapshot_literal)
                runtime = NumericRuntime(self.artifact, case["as_of"])
                if "fault" in case:
                    with self.assertRaisesRegex(DecimalFault, f"^{case['fault']}$"):
                        runtime.rule(case["rule"], env)
                else:
                    self.assertEqual(runtime.rule(case["rule"], env), DecimalValue.parse(case["output"]))
                namespace = f"RelatedSumCase{index - 4}" if filtered else f"DirectCountCase{index}"
                generated = DecimalCompiler(self.artifact, case["as_of"], env, allow_missing=True).emit(
                    case["rule"], namespace)
                self.assertIn(generated.removeprefix("import RuleSpecLean.Decimal\n"), source)

    def test_rejects_relation_entity_conflict(self):
        case = copy.deepcopy(self.report["results"][1])
        case["request"]["dataset"]["relations"][0]["tuple"] = ["h", "h"]
        with self.assertRaisesRegex(Unsupported, "conflicting relation entity kinds"):
            check_env(self.artifact, case, relation_counts=True)

    def test_filtered_count_uses_member_facts_and_preserves_missing_fault(self):
        case = copy.deepcopy(self.report["results"][2])
        program = self.artifact["program"]
        count = next(rule for rule in program["derived"] if rule["name"] == "member_count")["versions"][0]["expr"]["left"]
        count["where"] = {"kind": "comparison", "left": {"kind": "input", "name": "eligible"},
                          "op": "eq", "right": {"kind": "literal", "value": {"kind": "bool", "value": True}}}
        request = case["request"]
        request["dataset"]["inputs"] = [
            {"name": "us:policies/direct-count/rules#input.eligible", "entity": "Person", "entity_id": entity_id,
             "interval": {"start": "2025-01-01", "end": "2025-01-31"},
             "value": {"kind": "bool", "value": eligible}}
            for entity_id, eligible in (("z", False), ("a", True))
        ]
        env = bind(self.artifact, request, case["rule"], filtered_counts=True)
        members = env[member_key(count["relation"], 1, 0)]
        self.assertEqual([member["eligible"]["value"] for member in members], [True, False])
        runtime = NumericRuntime(self.artifact, case["as_of"])
        self.assertEqual(runtime.rule(case["rule"], env), DecimalValue(1, 0))
        del members[0]["eligible"]
        with self.assertRaisesRegex(DecimalFault, "^missingInput$"):
            runtime.rule(case["rule"], env)
        generated = DecimalCompiler(self.artifact, case["as_of"], env).emit(case["rule"], "Test")
        self.assertIn("Expr.countWhere [(Predicate.compareBool true none (some true))", generated)
