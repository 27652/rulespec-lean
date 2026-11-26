import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from tools.check_reference import check
from tools.test_prototype import ROOT, env


class ReferenceTests(unittest.TestCase):
    def setUp(self):
        # These tests isolate CLI response handling using the synthetic fixture.
        # Real request binding is covered separately by tools.test_binding.
        binding = patch("tools.check_reference.check_env")
        binding.start()
        self.addCleanup(binding.stop)

    def invoke(self, cases):
        with tempfile.TemporaryDirectory() as tmp:
            return check(ROOT / "fixtures/ctc-like.artifact.json", cases,
                         Path("engine"), Path(tmp) / "Reference.lean")

    def test_empty_cases(self):
        with self.assertRaisesRegex(ValueError, "nonempty"):
            self.invoke([])

    def test_duplicate_names(self):
        with self.assertRaisesRegex(ValueError, "unique"):
            self.invoke([self.case(), self.case()])

    @patch("tools.check_reference.subprocess.run")
    def test_cli_failure_is_diagnostic(self, execute):
        execute.return_value = subprocess.CompletedProcess([], 1, "", "invalid request")
        with self.assertRaisesRegex(ValueError, "example: official CLI failed: invalid request"):
            self.invoke([self.case()])

    @patch("tools.check_reference.subprocess.run")
    def test_fallback_mode_is_rejected(self, execute):
        response = json.loads(self.response().stdout)
        response["metadata"]["actual_mode"] = "fast"
        execute.return_value = subprocess.CompletedProcess([], 0, json.dumps(response), "")
        with self.assertRaisesRegex(ValueError, "did not execute Explain"):
            self.invoke([self.case()])

    @patch("tools.check_reference.subprocess.run")
    def test_extra_result_is_rejected(self, execute):
        response = json.loads(self.response().stdout)
        response["results"] *= 2
        execute.return_value = subprocess.CompletedProcess([], 0, json.dumps(response), "")
        with self.assertRaisesRegex(ValueError, "exactly one result"):
            self.invoke([self.case()])

    @patch("tools.check_reference.subprocess.run")
    def test_wrong_output_is_rejected(self, execute):
        response = json.loads(self.response().stdout)
        response["results"][0]["outputs"] = {}
        execute.return_value = subprocess.CompletedProcess([], 0, json.dumps(response), "")
        with self.assertRaisesRegex(ValueError, "output keys"):
            self.invoke([self.case()])

    def case(self):
        return {"name": "example", "as_of": "2025-01-01", "rule": "credit",
                "public_output": "credit", "env": env(),
                "request": {"mode": "explain", "queries": [
                    {"period": {"start": "2025-01-01"}, "outputs": ["credit"]}]}}

    def response(self, value="4800"):
        return subprocess.CompletedProcess([], 0, json.dumps({
            "metadata": {"actual_mode": "explain"}, "results": [{"outputs": {
                "credit": {"kind": "scalar", "value": {"kind": "decimal", "value": value}}}}]}), "")

    @patch("tools.check_reference.subprocess.run")
    def test_guards_and_explicit_pending_status(self, execute):
        execute.return_value = self.response()
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp) / "Reference.lean"
            result = check(ROOT / "fixtures/ctc-like.artifact.json", [self.case()],
                           Path("engine"), target)
            self.assertEqual(result["python_rust"], "passed")
            self.assertTrue(result["lean"].startswith("pending"))
            self.assertIn("#guard sameResult", target.with_name("ReferenceTests.lean").read_text())

    @patch("tools.check_reference.subprocess.run")
    def test_mismatch_fails(self, execute):
        execute.return_value = self.response("4801")
        with tempfile.TemporaryDirectory() as tmp, self.assertRaisesRegex(ValueError, "!= Rust"):
            check(ROOT / "fixtures/ctc-like.artifact.json", [self.case()],
                  Path("engine"), Path(tmp) / "Reference.lean")

    def test_period_mismatch_fails_before_execution(self):
        case = self.case()
        case["request"]["queries"][0]["period"]["start"] = "2024-01-01"
        with tempfile.TemporaryDirectory() as tmp, self.assertRaisesRegex(ValueError, "snapshot"):
            check(ROOT / "fixtures/ctc-like.artifact.json", [case],
                  Path("engine"), Path(tmp) / "Reference.lean")

    def test_requested_output_must_match(self):
        case = self.case()
        case["request"]["queries"][0]["outputs"] = ["another"]
        with tempfile.TemporaryDirectory() as tmp, self.assertRaisesRegex(ValueError, "public_output"):
            check(ROOT / "fixtures/ctc-like.artifact.json", [case],
                  Path("engine"), Path(tmp) / "Reference.lean")
