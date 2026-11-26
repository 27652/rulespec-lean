"""Regression tests for rejected input and scanner entry points."""
import copy
from datetime import date
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from tools.compile_ir import Compiler, EvalFault, Unsupported, parse_date, run, version_at
from tests.test_prototype import FIXTURE, ROOT


class ValidationTests(unittest.TestCase):
    def test_snapshot_dates_are_canonical_and_versions_use_inclusive_bounds(self):
        for text in ("20260228", "2026-W09-6", "2026-02-29", "", False):
            with self.subTest(text=text), self.assertRaisesRegex(Unsupported, "YYYY-MM-DD"):
                parse_date(text)
        first = {"effective_from": "2024-02-29", "effective_to": "2025-01-01"}
        latest = {**first, "body": "later row"}
        self.assertIs(version_at([first, latest], date(2025, 1, 1)), latest)
        self.assertIsNone(version_at([first, latest], date(2025, 1, 2)))
        with self.assertRaisesRegex(Unsupported, "YYYY-MM-DD"):
            version_at([{**first, "effective_to": ""}], date(2025, 1, 1))

    def test_no_match_preserves_subject_fault_and_branch_laziness(self):
        compiler = Compiler(FIXTURE, "2025-01-01")
        tree = compiler.lower({"kind": "no_match", "subject": {"kind": "input", "name": "status"},
                               "patterns": []}, "scalar")
        with self.assertRaisesRegex(EvalFault, "^missingInput$"):
            run(tree, {}, {})
        with self.assertRaisesRegex(EvalFault, "^noMatchingArm$"):
            run(tree, {"status": {"kind": "integer", "value": 9}}, {})
        selected = ("lit", ("integer", 1500))
        self.assertEqual(run(("choose", ("lit", ("judgment", "holds")), selected, tree), {}, {}),
                         ("integer", 1500))

    def test_artifact_object(self):
        for value in (None, [], 3, "artifact"):
            with self.subTest(value=value), self.assertRaises(Unsupported):
                Compiler(value, "2025-01-01")

    def test_version_is_integer(self):
        artifact = copy.deepcopy(FIXTURE)
        artifact["artifact_format_version"] = 3.0
        with self.assertRaises(Unsupported):
            Compiler(artifact, "2025-01-01")

    def test_expression_object(self):
        compiler = Compiler(FIXTURE, "2025-01-01")
        for value in (None, [], {}, {"kind": 1}):
            with self.subTest(value=value), self.assertRaises(Unsupported):
                compiler.lower(value, "scalar")

    def test_judgment_items(self):
        compiler = Compiler(FIXTURE, "2025-01-01")
        with self.assertRaises(Unsupported):
            compiler.lower({"kind": "and", "items": {}}, "judgment")

    def test_bad_named_row(self):
        artifact = copy.deepcopy(FIXTURE)
        artifact["program"]["derived"] = [None]
        with self.assertRaises(Unsupported):
            Compiler(artifact, "2025-01-01")

    def test_scanner_script_and_module(self):
        with tempfile.TemporaryDirectory() as tmp:
            fixtures = Path(tmp) / "fixtures"
            fixtures.mkdir()
            (fixtures / "sample.artifact.json").write_text(json.dumps(FIXTURE))
            for entry in (["experiments/scan_artifacts.py"], ["-m", "experiments.scan_artifacts"]):
                report = Path(tmp) / "coverage.json"
                subprocess.run([sys.executable, *entry, str(fixtures), "--as-of",
                                "2025-01-01", "--report", str(report)],
                               cwd=ROOT, check=True, capture_output=True, text=True)
                result = json.loads(report.read_text())
                self.assertEqual((result["lowered"], result["blocked"], result["errors"]),
                                 (7, 0, 0))

    def test_scanner_missing_directory(self):
        with tempfile.TemporaryDirectory() as tmp:
            result = subprocess.run([sys.executable, "-m", "experiments.scan_artifacts",
                                     str(Path(tmp) / "missing"), "--as-of", "2025-01-01"],
                                    cwd=ROOT, capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)


if __name__ == "__main__":
    unittest.main()
