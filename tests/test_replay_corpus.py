import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from tools.compile_ir import EvalFault, Unsupported
from experiments.replay_corpus import (
    check_lean_batches, compare_response, example_bindings, example_period, explain_output, lost_matches,
    matches_example, summarize_table,
)


class CorpusReplayTests(unittest.TestCase):
    def test_explain_response_does_not_hide_engine_failures(self):
        diagnostic = "derived `credit` has no formula version at 2026-01-01\n"
        query = {"entity_id": "entity:1", "period": example_period("2026-01"), "outputs": ["credit"]}
        for code, stdout, stderr, status in (
            (1, "", diagnostic, "engineRejected"),
            (2, "", diagnostic, "unexpectedResponse"),
            (1, "{}", diagnostic, "unexpectedResponse"),
            (1, "", "engine panicked", "unexpectedResponse"),
            (0, "not JSON", "", "unexpectedResponse"),
        ):
            with self.subTest(code=code, stdout=stdout, stderr=stderr):
                result = {}
                self.assertIsNone(explain_output(result, subprocess.CompletedProcess([], code, stdout, stderr),
                                                 query))
                self.assertEqual(result["status"], status)

        item = {"id": "credit", "kind": "judgment", "outcome": "holds"}
        row = {**query, "outputs": {"credit": item}}
        for overrides, expected in (({}, item), ({"entity_id": "other"}, None),
                                    ({"period": example_period("2026-02")}, None),
                                    ({"outputs": {"credit": {**item, "id": "other"}}}, None)):
            with self.subTest(overrides=overrides):
                stdout = json.dumps({"metadata": {"actual_mode": "explain"}, "results": [{**row, **overrides}]})
                result = {}
                self.assertEqual(explain_output(result, subprocess.CompletedProcess([], 0, stdout, ""), query),
                                 expected)
                self.assertEqual(result.get("status"), "unexpectedResponse" if expected is None else None)

    def test_baseline_detects_lost_cases_even_when_total_is_unchanged(self):
        def report(outputs):
            return {"prefix": "us/", "engine_build": {"commit": "engine"}, "corpus_pin": "corpus",
                    "results": [{"fixture": "rules.test.yaml", "outputs": outputs}]}

        baseline = report([{"case": 0, "output": "credit", "status": "matched"}])
        current = report([{"case": 0, "output": "credit", "status": "outsideReplaySubset"},
                          {"case": 1, "output": "credit", "status": "matched"}])
        self.assertEqual(lost_matches(baseline, baseline), [])
        self.assertEqual(lost_matches(baseline, current), [
            {"fixture": "rules.test.yaml", "case": 0, "output": "credit", "status": "outsideReplaySubset"},
        ])
        self.assertEqual(lost_matches(baseline, report([]))[0]["status"], "absent")
        with self.assertRaisesRegex(Unsupported, "corpus_pin"):
            lost_matches(baseline, {**current, "corpus_pin": "other"})

    def test_distinguishes_precision_limit_from_unexpected_fault(self):
        item = {"kind": "scalar", "value": {"kind": "integer", "value": 1}}
        for reason, status in (("outsideExactDomain", "comparisonUnavailable"), ("missingInput", "runtimeMismatch")):
            with self.subTest(reason=reason):
                def compute():
                    raise EvalFault(reason)

                result = {}
                self.assertIsNone(compare_response(result, compute, item, ("integer", 1)))
                self.assertEqual(result["status"], status)

        for value, status in (({"kind": "decimal", "value": "0.0000001"}, "comparisonUnavailable"),
                              ({"kind": "decimal", "value": "invalid"}, "unexpectedResponse"),
                              ({"kind": "integer", "value": True}, "unexpectedResponse")):
            with self.subTest(value=value):
                result = {}
                self.assertIsNone(compare_response(result, lambda: self.fail("invalid reference reached runtime"),
                                                  {"kind": "scalar", "value": value}, ("integer", 1)))
                self.assertEqual(result["status"], status)

    def test_lean_batch_failure_isolated_to_bad_guard(self):
        good, bad = {}, {}

        def run(command, **kwargs):
            invalid = "bad guard" in Path(command[-1]).read_text()
            return subprocess.CompletedProcess(command, int(invalid), "", "failed guard" if invalid else "")

        with tempfile.TemporaryDirectory() as work, patch("experiments.replay_corpus.subprocess.run", side_effect=run):
            check_lean_batches(Path("lake"), Path(work), [(good, "good guard"), (bad, "bad guard")])
        self.assertEqual(good, {"status": "matched"})
        self.assertEqual(bad, {"status": "leanRejected", "reason": "failed guard"})

    def test_month_shorthand(self):
        self.assertEqual(example_period("2024-02"), {
            "period_kind": "month", "start": "2024-02-01", "end": "2024-02-29",
        })
        with self.assertRaisesRegex(Unsupported, "invalid example month"):
            example_period("2024-13")

    def test_unbound_context_is_not_ignored(self):
        with self.assertRaisesRegex(Unsupported, "oracle_inputs"):
            example_bindings({"oracle_inputs": {}}, "Payment", 1)

    def test_table_rows_are_paired_without_dropping_other_context(self):
        example = {"tables": {"Payment": [{"amount": 20}]}}
        self.assertEqual(example_bindings(example, "Payment", [7]), [({"amount": 20}, 7)])
        multi = {"tables": {"Payment": [{"amount": 20}, {"amount": 30}]}}
        self.assertEqual(example_bindings(multi, "Payment", [7, 9]), [({"amount": 20}, 7), ({"amount": 30}, 9)])
        for invalid, expected, diagnostic in (
            (example, 7, "expected output for each input row"),
            (multi, [7], "expected output for each input row"),
            ({**example, "input": {"amount": 15}}, [7], "no flat inputs"),
            ({"tables": {"Person": [{}]}}, [7], "matching entity table"),
            ({"tables": {"Payment": []}}, [], "nonempty input rows"),
        ):
            with self.subTest(invalid=invalid), self.assertRaisesRegex(Unsupported, diagnostic):
                example_bindings(invalid, "Payment", expected)

    def test_table_pass_requires_every_row(self):
        result = {"rows": [{"status": "matched"}, {"status": "matched"}]}
        summarize_table(result)
        self.assertEqual(result["status"], "matched")
        result["rows"][0]["status"] = "outsideReplaySubset"
        summarize_table(result)
        self.assertEqual(result["status"], "outsideReplaySubset")
        result["rows"][1]["status"] = "exampleMismatch"
        summarize_table(result)
        self.assertEqual(result["status"], "exampleMismatch")

    def test_yaml_numbers_do_not_specify_wire_tags(self):
        self.assertTrue(matches_example(("integer", 3), ("decimal", 3_000_000)))
        self.assertFalse(matches_example(("integer", 3), ("decimal", 3_000_001)))
        self.assertFalse(matches_example(("integer", 1), ("bool", True)))
        self.assertFalse(matches_example(("judgment", "undetermined"), ("judgment", "notHolds")))
