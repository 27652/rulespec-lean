"""Run the public §2012(j) membership cases through the SNAP compatibility artifact."""

import argparse
import json
from pathlib import Path
import subprocess
import sys
import tempfile

import yaml

from tools.compile_decimal import DecimalCompiler
from tools.decimal_model import snapshot_literal
from tools.decimal_runtime import NumericRuntime
from tools.probe_corpus_compat import SNAP_RELATION, SNAP_RELATION_ID, digest
from tools.replay_corpus import example_period, explain_output
from tools.request_binding import bind

FIXTURE = SNAP_RELATION.removesuffix(".yaml") + ".test.yaml"
RULE = "snap_household_has_elderly_or_disabled_member"
OUTPUT = f"us:statutes/7/2012/j#{RULE}"
INPUT = "us:statutes/7/2012/j#input.snap_member_is_elderly_or_disabled"


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


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for option in ("engine", "lake", "corpus", "report", "lean"):
        parser.add_argument(f"--{option}", type=Path, required=True)
    parser.add_argument("--audit", type=Path, default=Path("reports/corpus-static.json"))
    args = parser.parse_args()
    audit = json.loads(args.audit.read_bytes())
    raw_fixture = (args.corpus / FIXTURE).read_bytes()
    fixture_hash, = (row["sha256"] for row in audit["results"] if row["source"] == FIXTURE)
    if digest(raw_fixture) != fixture_hash:
        raise ValueError("public fixture differs from the pinned audit")
    cases = yaml.safe_load(raw_fixture)
    if not cases:
        raise ValueError("public fixture has no cases")
    results = []
    blocks = ["import RuleSpecLean.Decimal\n\nopen RuleSpecLean.DecimalModel"]
    with tempfile.TemporaryDirectory(prefix="rulespec-snap-membership-") as work:
        artifact = Path(work) / "snap.json"
        probe = Path(work) / "probe.json"
        subprocess.run([sys.executable, "-m", "tools.probe_corpus_compat", "--engine", str(args.engine),
                        "--corpus", str(args.corpus), "--audit", str(args.audit),
                        "--snap-report", str(probe), "--snap-artifact", str(artifact)], check=True, timeout=300)
        provenance = json.loads(probe.read_bytes())
        program = json.loads(artifact.read_bytes())
        for index, case in enumerate(cases):
            request = build_request(case)
            query = request["queries"][0]
            execution = subprocess.run([str(args.engine.resolve()), "run-compiled", "--artifact", str(artifact)],
                                       input=json.dumps(request), capture_output=True, text=True, timeout=60)
            status = {}
            official = explain_output(status, execution, query)
            expected = case["output"][OUTPUT]
            if (execution.stderr.strip() or official is None or official.get("kind") != "judgment" or
                    official.get("outcome") != expected):
                raise ValueError(f"{case['name']}: unexpected Explain result: {status or official}; {execution.stderr}")
            response = json.loads(execution.stdout)
            if response["metadata"]["relation_binding"] != "strict":
                raise ValueError(f"{case['name']}: expected strict relation binding")
            as_of = query["period"]["start"]
            env = bind(program, request, RULE, validate_value=snapshot_literal, filtered_counts=True)
            actual = NumericRuntime(program, as_of).judgment(RULE, env)
            if actual != (expected == "holds"):
                raise ValueError(f"{case['name']}: Python judgment differs from {expected}")
            namespace = f"SNAPMembershipCase{index}"
            source = DecimalCompiler(program, as_of, env, allow_missing=True).emit(RULE, namespace, judgment=True)
            blocks.append(source.removeprefix("import RuleSpecLean.Decimal\n"))
            blocks.append(f"#guard match evalPredicate {namespace}.output with\n"
                          f"  | .ok value => value == {str(actual).lower()}\n  | .error _ => false\n")
            results.append({"name": case["name"], "expected": expected, "request": request,
                            "official_response": response, "bound_env": env,
                            "python_outcome": "holds" if actual else "not_holds"})
        lean = "\n".join(blocks)
        check = Path(work) / "SNAPMembershipTests.lean"
        check.write_text(lean)
        subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.Decimal"], check=True, timeout=300)
        subprocess.run([str(args.lake.resolve()), "env", "lean", str(check)], check=True, timeout=60)
    args.lean.write_text(lean)
    args.report.write_text(json.dumps({"fixture": FIXTURE, "fixture_sha256": fixture_hash,
                                      "compatibility_probe": provenance, "lean_guards_passed": len(results),
                                      "results": results}, indent=2) + "\n")
    print(f"SNAP membership: {len(results)} public cases passed Rust Explain, Python and Lean")


if __name__ == "__main__":
    main()
