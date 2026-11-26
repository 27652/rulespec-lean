"""Compare supplied binary relation snapshots with the pinned Explain engine."""
import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import subprocess

from tools.check_decimal_dependency import check_case
from tools.decimal_model import snapshot_literal
from tools.request_binding import bind, count_key


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", type=Path, required=True)
    parser.add_argument("--lake", type=Path, required=True)
    args = parser.parse_args()
    artifact = Path("fixtures/direct-count.artifact.json")
    raw = artifact.read_bytes()
    program = json.loads(raw)
    base = "us:policies/direct-count/rules#"
    relation = base + "relation.member_of_household"
    start, end = "2025-01-01", "2025-01-31"

    def record(person, household="h", left=start, right=end):
        return {"name": relation, "tuple": [person, household], "interval": {"start": left, "end": right}}

    full = [record("a"), record("a", left="2024-12-01"), record("z"),
            record("b", right="2025-01-30"), record("c", "other")]
    lines = ["import RuleSpecLean.Decimal", "", "open RuleSpecLean.DecimalModel", ""]
    rows = []
    for index, (facts, expected) in enumerate((([], 0), ([record("a")], 1), (full, 2), (full[::-1], 2))):
        request = {"mode": "explain", "dataset": {"inputs": [], "relations": facts},
                   "queries": [{"entity_id": "h", "period": {"period_kind": "month", "start": start, "end": end},
                                "outputs": [base + "member_count"]}]}
        case = {"rule": "member_count", "as_of": start, "request": request, "relation_counts": True,
                "env": {count_key(relation, 1, 0): {"kind": "integer", "value": expected}}}
        outcome, blocks = check_case(artifact, program, case, args.engine.resolve(), f"DirectCountCase{index}")
        lines.extend(blocks)
        rows.append({**case, **outcome})
    counts = len(rows)
    maximum = "79228162514264337593543950335"
    sums = (
        ([], [], "0", {}),
        ([record("a"), record("b")], [("a", True, "3.15"), ("b", False, None)], "3.15", {}),
        (full, [("a", True, "9.10"), ("z", True, "-1.04")], "8.06", {}),
        ([record("a")], [("a", True, None)], None, {
            "fault": "missingInput", "diagnostic": f"missing input `{base}input.amount` for entity `a` over {start}..{end}",
        }),
        ([record("a"), record("z")], [("a", True, maximum), ("z", True, maximum)], None, {
            "fault": "arithmeticOverflow", "diagnostic": "arithmetic overflow: addition result is outside the representable decimal range",
        }),
    )
    for index, (relations, people, expected, fault) in enumerate(sums):
        inputs = []
        for entity_id, eligible, amount in people:
            for slot, kind, value in (("eligible", "bool", eligible), ("amount", "decimal", amount)):
                if value is not None:
                    inputs.append({"name": base + "input." + slot, "entity": "Person", "entity_id": entity_id,
                                   "interval": {"start": start, "end": end}, "value": {"kind": kind, "value": value}})
        request = {"mode": "explain", "dataset": {"inputs": inputs, "relations": relations},
                   "queries": [{"entity_id": "h", "period": {"period_kind": "month", "start": start, "end": end},
                                "outputs": [base + "eligible_total"]}]}
        env = bind(program, request, "eligible_total", filtered_counts=True, validate_value=snapshot_literal)
        case = {"rule": "eligible_total", "as_of": start, "request": request,
                "filtered_counts": True, "env": env, **fault}
        outcome, blocks = check_case(artifact, program, case, args.engine.resolve(), f"RelatedSumCase{index}")
        if expected is not None and Fraction(outcome["output"]) != Fraction(expected):
            raise ValueError(f"related sum case {index}: expected {expected}, got {outcome['output']}")
        lines.extend(blocks)
        rows.append({**case, **outcome})
    Path("RuleSpecLean/DirectCountTests.lean").write_text("\n".join(lines) + "\n")
    subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.DirectCountTests"], check=True, timeout=300)
    Path("reports/direct-count.json").write_text(json.dumps({
        "artifact_sha256": hashlib.sha256(raw).hexdigest(), "engine_build": program["engine_build"],
        "cases": len(rows), "status": "Rust/Python/Lean passed", "results": rows,
    }, indent=2) + "\n")
    print(f"Direct relation aggregation: {counts} count and {len(rows) - counts} filtered sum three-way checks passed")


if __name__ == "__main__":
    main()
