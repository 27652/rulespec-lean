"""Replay public SNAP membership and §273.10 outputs on the compatibility artifact."""

import argparse
from decimal import Decimal
from fractions import Fraction
import json
from pathlib import Path
import subprocess
import sys
import tempfile

import yaml

from tools.compile_decimal import DecimalCompiler
from tools.decimal_model import DecimalValue, snapshot_literal
from tools.decimal_runtime import NumericRuntime
from tools.probe_corpus_compat import ENTRYPOINTS, SNAP_RELATION, SNAP_RELATION_ID, digest
from tools.replay_corpus import example_period, explain_output, wire
from tools.request_binding import bind

FIXTURE = SNAP_RELATION.removesuffix(".yaml") + ".test.yaml"
RULE = "snap_household_has_elderly_or_disabled_member"
OUTPUT = f"us:statutes/7/2012/j#{RULE}"
INPUT = "us:statutes/7/2012/j#input.snap_member_is_elderly_or_disabled"
ALLOTMENT_FIXTURE = ENTRYPOINTS[-1].removesuffix(".yaml") + ".test.yaml"
ALLOTMENT_RULE = "snap_monthly_allotment"
ALLOTMENT_OUTPUT = f"us:regulations/7-cfr/273/10#{ALLOTMENT_RULE}"


class SnapExampleLoader(yaml.SafeLoader):
    pass


SnapExampleLoader.add_constructor("tag:yaml.org,2002:float", lambda loader, node: Decimal(node.value))


def build_request(case):
    period = example_period(case["period"])
    interval = {key: period[key] for key in ("start", "end")}
    if (period["period_kind"] != "month" or set(case["input"]) - {SNAP_RELATION_ID} or
            set(case["output"]) != {OUTPUT} or case["output"][OUTPUT] not in {"holds", "not_holds"}):
        raise ValueError(f"unsupported public membership case: {case['name']}")
    household = "household:1"
    inputs, relations = [], []
    for index, row in enumerate(case["input"].get(SNAP_RELATION_ID, []), start=1):
        if set(row) != {INPUT} or type(row[INPUT]) is not bool:
            raise ValueError(f"expected a Person membership row: {row}")
        person = f"person:{index}"
        inputs.append({"name": INPUT, "entity": "Person", "entity_id": person,
                       "interval": interval, "value": {"kind": "bool", "value": row[INPUT]}})
        relations.append({"name": SNAP_RELATION_ID, "tuple": [person, household], "interval": interval})
    return {"mode": "explain", "dataset": {"inputs": inputs, "relations": relations},
            "queries": [{"entity_id": household, "period": period, "outputs": [OUTPUT]}]}


def build_allotment_request(case, output=ALLOTMENT_OUTPUT):
    period = example_period(case["period"])
    if period["period_kind"] != "month" or type(case["output"].get(ALLOTMENT_OUTPUT)) is not int:
        raise ValueError(f"expected a monthly case with a whole-dollar allotment: {case['name']}")
    interval = {key: period[key] for key in ("start", "end")}
    household = "household:1"
    inputs = []
    for name, value in case["input"].items():
        if type(value) not in (int, bool) or "#input." not in name:
            raise ValueError(f"unsupported public allotment input: {name}")
        inputs.append({"name": name, "entity": "Household", "entity_id": household,
                       "interval": interval, "value": wire(value)})
    return {"mode": "explain", "dataset": {"inputs": inputs, "relations": []},
            "queries": [{"entity_id": household, "period": period, "outputs": [output]}]}


def scalar_snapshot(program, rule, output, request, as_of, namespace):
    """Lower derived outputs normally and unindexed published parameters as key-zero reads."""
    if any(row["id"] == output for row in program["program"]["derived"]):
        env = bind(program, request, rule, validate_value=snapshot_literal, filtered_counts=True)
        actual = NumericRuntime(program, as_of).rule(rule, env)
        source = DecimalCompiler(program, as_of, env, allow_missing=True).emit(rule, namespace)
        return actual, source, {"bound_env": env}

    parameters = {row["name"]: row for row in program["program"]["parameters"]}
    parameter = parameters.get(rule)
    if parameter is None or parameter["id"] != output or parameter["indexed_by"] is not None:
        raise ValueError(f"unsupported output dependency: {output}")
    read = {"kind": "parameter_lookup", "parameter": rule,
            "index": {"kind": "literal", "value": {"kind": "integer", "value": 0}}}
    actual = NumericRuntime(program, as_of).expr(read, {}, ())
    term = DecimalCompiler(program, as_of, {}).expr(read)
    source = (f"import RuleSpecLean.Decimal\n\nnamespace {namespace}\n"
              f"open RuleSpecLean.DecimalModel\n\ndef output : Expr := {term}\nend {namespace}\n")
    return actual, source, {"parameter_key": 0}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for option in ("engine", "lake", "corpus", "report", "lean"):
        parser.add_argument(f"--{option}", type=Path, required=True)
    parser.add_argument("--audit", type=Path, default=Path("reports/corpus-static.json"))
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--allotment", action="store_true", help="Replay §273.10 monthly allotment outputs")
    mode.add_argument("--other-outputs", action="store_true", help="Replay the remaining published §273.10 outputs")
    parser.add_argument("--retain-source-verification", action="store_true",
                        help="Use the SNAP compatibility overlay that retains source citations")
    args = parser.parse_args()
    scalar = args.allotment or args.other_outputs
    fixture = ALLOTMENT_FIXTURE if scalar else FIXTURE
    audit = json.loads(args.audit.read_bytes())
    raw_fixture = (args.corpus / fixture).read_bytes()
    fixture_hash, = (row["sha256"] for row in audit["results"] if row["source"] == fixture)
    if digest(raw_fixture) != fixture_hash:
        raise ValueError("public fixture differs from the pinned audit")
    cases = yaml.load(raw_fixture, Loader=SnapExampleLoader)
    if not cases:
        raise ValueError("public fixture has no cases")
    results = []
    blocks = ["import RuleSpecLean.Decimal\n\nopen RuleSpecLean.DecimalModel"]
    with tempfile.TemporaryDirectory(prefix="rulespec-snap-replay-") as work:
        artifact = Path(work) / "snap.json"
        probe = Path(work) / "probe.json"
        command = [sys.executable, "-m", "tools.probe_corpus_compat", "--engine", str(args.engine),
                   "--corpus", str(args.corpus), "--audit", str(args.audit),
                   "--snap-report", str(probe), "--snap-artifact", str(artifact)]
        if args.retain_source_verification:
            command.append("--retain-source-verification")
        subprocess.run(command, check=True, timeout=300)
        provenance = json.loads(probe.read_bytes())
        program = json.loads(artifact.read_bytes())
        targets = [(case, output) for case in cases for output in (
            [key for key in case["output"] if key != ALLOTMENT_OUTPUT] if args.other_outputs
            else [ALLOTMENT_OUTPUT if args.allotment else OUTPUT])]
        if not targets:
            raise ValueError("no public outputs selected")
        for index, (case, output) in enumerate(targets):
            rule = output.split("#", 1)[1]
            context = f"{case['name']} / {output}"
            request = build_allotment_request(case, output) if scalar else build_request(case)
            query = request["queries"][0]
            execution = subprocess.run([str(args.engine.resolve()), "run-compiled", "--artifact", str(artifact)],
                                       input=json.dumps(request), capture_output=True, text=True, timeout=60)
            status = {}
            official = explain_output(status, execution, query)
            expected = case["output"][output]
            expected_kind = "scalar" if scalar else "judgment"
            if execution.stderr.strip() or official is None or official.get("kind") != expected_kind:
                raise ValueError(f"{context}: unexpected Explain result: {status or official}; {execution.stderr}")
            response = json.loads(execution.stdout)
            if response["metadata"]["relation_binding"] != "strict":
                raise ValueError(f"{context}: expected strict relation binding")
            as_of = query["period"]["start"]
            if scalar:
                if type(expected) not in (int, Decimal):
                    raise ValueError(f"{context}: expected a YAML number")
                literal = {"kind": "decimal", "value": str(expected)}
                target = DecimalValue.from_literal(literal)
                official_value = DecimalValue.from_literal(official["value"])
                prefix = "SNAPPublishedOutput" if args.other_outputs else "SNAPAllotmentCase"
                namespace = f"{prefix}{index}"
                try:
                    actual, source, binding = scalar_snapshot(program, rule, output, request, as_of, namespace)
                except (ValueError, KeyError) as exc:
                    raise ValueError(f"{context}: Python or Lean lowering failed: {exc}") from exc
                if Fraction(str(official_value)) != expected or Fraction(str(actual)) != expected:
                    raise ValueError(f"{context}: expected {expected}, Rust {official_value}, Python {actual}")
                evaluator = "eval"
                comparison = f"equalValue value ⟨({target.coefficient}), {target.scale}⟩"
                python_result = {"python_value": str(actual)}
            else:
                env = bind(program, request, rule, validate_value=snapshot_literal, filtered_counts=True)
                binding = {"bound_env": env}
                actual = NumericRuntime(program, as_of).judgment(rule, env)
                if official.get("outcome") != expected or actual != (expected == "holds"):
                    raise ValueError(f"{case['name']}: judgment differs from {expected}")
                namespace = f"SNAPMembershipCase{index}"
                evaluator = "evalPredicate"
                comparison = f"value == {str(actual).lower()}"
                python_result = {"python_outcome": "holds" if actual else "not_holds"}
                source = DecimalCompiler(program, as_of, env, allow_missing=True).emit(rule, namespace, judgment=True)
            blocks.append(source.removeprefix("import RuleSpecLean.Decimal\n"))
            blocks.append(f"#guard match {evaluator} {namespace}.output with\n"
                          f"  | .ok value => {comparison}\n  | .error _ => false\n")
            expected_json = str(expected) if isinstance(expected, Decimal) else expected
            results.append({"name": case["name"], "expected": expected_json, "request": request,
                            "official_response": response, **binding,
                            **python_result})
        lean = "\n".join(blocks)
        check = Path(work) / "SNAPReplayTests.lean"
        check.write_text(lean)
        subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.Decimal"], check=True, timeout=300)
        subprocess.run([str(args.lake.resolve()), "env", "lean", str(check)], check=True, timeout=60)
    args.lean.write_text(lean)
    args.report.write_text(json.dumps({"fixture": fixture, "fixture_sha256": fixture_hash,
                                      "compatibility_probe": provenance, "lean_guards_passed": len(results),
                                      "results": results}, indent=2) + "\n")
    label = "other §273.10 outputs" if args.other_outputs else "allotment" if args.allotment else "membership"
    print(f"SNAP {label}: {len(results)} public expectations passed Rust Explain, Python and Lean")


if __name__ == "__main__":
    main()
