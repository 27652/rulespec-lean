import json
import unittest

from experiments.check_faults import classify
from tools.compile_ir import Compiler, EvalFault, run
from tests.test_prototype import ROOT


class FaultDiagnosticTests(unittest.TestCase):
    def test_retained_parameter_version_fault_precedence(self):
        artifact = json.loads((ROOT / "fixtures/faults.artifact.json").read_text())
        cases = json.loads((ROOT / "fixtures/faults.cases.json").read_text())
        indexed = [case for case in cases if case["rule"] == "indexed_amount"]
        self.assertEqual([case["fault"] for case in indexed],
                         ["missingParameter", "missingInput", "typeMismatch"])
        for case in indexed:
            with self.subTest(case=case["name"]):
                compiler = Compiler(artifact, case["as_of"])
                rules = compiler.compile([case["rule"]])
                with self.assertRaisesRegex(EvalFault, f"^{case['fault']}$"):
                    run(rules[case["rule"]], case["env"], rules)

    def test_supported_diagnostics(self):
        examples = {
            "division by zero": "divisionByZero",
            "type mismatch: expected numeric value": "typeMismatch",
            "missing input `x` for entity `p` over 2025-01-01..2026-01-01": "missingInput",
            "derived `x` has no formula version at 2024-01-01": "missingVersion",
            "parameter `x` has no value for key `-1` at 2024-01-01": "missingParameter",
        }
        for text, fault in examples.items():
            with self.subTest(text=text):
                self.assertEqual(classify(text), fault)

    def test_unrecognized_failures_are_not_eval_faults(self):
        for text in ("connection reset", "invalid request", "", "prefix division by zero",
                     "division by zero\nextra diagnostic"):
            with self.subTest(text=text), self.assertRaises(ValueError):
                classify(text)
