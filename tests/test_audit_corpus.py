import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from experiments.audit_corpus import audit_module


class CorpusAuditTests(unittest.TestCase):
    def test_test_fixture_excluded_without_invoking_engine(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            source = root / "sample.test.yaml"
            source.write_text("examples: []\n")
            with patch("experiments.audit_corpus.subprocess.run") as run:
                row = audit_module(Path("engine"), root, source, "2025-01-01", root)
            run.assert_not_called()
            self.assertEqual(row["compile"], "notApplicable")

    def test_composition_staged_outside_import_root(self):
        with tempfile.TemporaryDirectory() as tmp:
            scratch = Path(tmp)
            root = scratch / "rulespec-us"
            root.mkdir()
            source = root / "composition.yaml"
            source.write_text("module: {kind: composition}\n")

            def run(command, **kwargs):
                if command[1] == "compile":
                    return subprocess.CompletedProcess(command, 1, "", "`composition` is accepted only by the composed-program surface")
                self.assertEqual(command[1], "compile-composed")
                staged = Path(command[3])
                self.assertFalse(staged.is_relative_to(root))
                self.assertEqual(staged.read_bytes(), source.read_bytes())
                return subprocess.CompletedProcess(command, 1, "", f"Could not load {staged}")

            with patch("experiments.audit_corpus.subprocess.run", side_effect=run) as execute:
                row = audit_module(Path("engine"), root, source, "2025-01-01", scratch)
            self.assertEqual(execute.call_count, 2)
            self.assertEqual(row["compiler"], "compile-composed")
            self.assertEqual(row["diagnostic"], "Could not load <corpus>/composition.yaml")
