"""Verify selected-year numeric reads using the pinned Explain engine."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

from tools.check_decimal_dependency import check_case
from tools.compile_ir import Unsupported
from tools.decimal_model import snapshot_literal
from tools.request_binding import annual_key, bind


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True, type=Path)
    parser.add_argument("--lake", required=True, type=Path)
    args = parser.parse_args()
    artifact = Path("fixtures/selected-year.artifact.json")
    raw = artifact.read_bytes()
    program = json.loads(raw)
    base = "us:policies/selected-year/rules#"
    input_id = base + "input.income"
    precise = "1234.567890123456789012345678"

    def spell(start, end, value):
        return {"name": input_id, "entity": "Person", "entity_id": "person:1",
                "interval": {"start": start, "end": end},
                "value": {"kind": "decimal", "value": value}}

    older = spell("2024-01-01", "2025-12-31", "10")
    exact = spell("2025-01-01", "2025-12-31", precise)
    partial = spell("2025-02-01", "2025-12-31", "20")
    current = spell("2026-01-01", "2026-12-31", "99")
    matrix = [("exact-year", [exact], exact),
               ("latest-covering", [current, exact, partial, older], exact),
               ("reversed-spells", [older, partial, exact, current], exact),
               ("wider-spell", [partial, older], older),
               ("missing-year", [current, partial], None),
               ("redundant-same-start", [older, exact, exact], exact)]
    lines = ["import RuleSpecLean.Decimal", "", "open RuleSpecLean.DecimalModel", ""]
    results = []
    for index, (name, facts, selected) in enumerate(matrix):
        request = {"mode": "explain", "dataset": {"inputs": facts, "relations": []},
                   "queries": [{"entity_id": "person:1", "outputs": [base + "prior_income"],
                                "period": {"period_kind": "tax_year", "start": "2026-01-01",
                                           "end": "2026-12-31"}}]}
        env = {"income": current["value"]} if current in facts else {}
        if selected is not None:
            env[annual_key(input_id, 2025)] = selected["value"]
        case = {"name": name, "request": request, "env": env, "covering": True,
                "as_of": "2026-01-01", "rule": "prior_income"}
        if selected is None:
            case.update(fault="missingInput", diagnostic=(
                f"missing input `{input_id}` for entity `person:1` over 2025-01-01..2025-12-31"))
        outcome, blocks = check_case(artifact, program, case, args.engine.resolve(), f"SelectedYearCase{index}")
        lines.extend(blocks)
        results.append({**case, **outcome})
    conflicting = spell("2025-01-01", "2025-12-31", "77")
    invalid = {**request, "dataset": {"inputs": [exact, conflicting], "relations": []}}
    diagnostic = (f"ambiguous input `{input_id}` for entity `person:1`: records effective from 2025-01-01 "
                  "have conflicting values; merge or split the spells so one value applies at each start date")
    process = subprocess.run([str(args.engine.resolve()), "run-compiled", "--artifact", str(artifact.resolve())],
                             input=json.dumps(invalid), capture_output=True, text=True, timeout=60)
    if process.returncode != 1 or process.stdout.strip() or process.stderr.strip() != diagnostic:
        raise ValueError(f"expected ambiguous input diagnostic, got {process.stderr.strip()}")
    try:
        bind(program, invalid, "prior_income", covering=True, validate_value=snapshot_literal)
    except Unsupported as exc:
        binding_diagnostic = str(exc)
        if binding_diagnostic != "conflicting input spell start":
            raise
    else:
        raise ValueError("binder accepted conflicting input spells")
    Path("RuleSpecLean/SelectedYearTests.lean").write_text("\n".join(lines) + "\n")
    subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.SelectedYearTests"],
                   check=True, timeout=300)
    Path("reports/selected-year.json").write_text(json.dumps({
        "artifact_sha256": hashlib.sha256(raw).hexdigest(), "engine_build": program["engine_build"],
        "cases": len(results), "status": "Rust/Python/Lean passed", "results": results,
        "admission_rejections": [{"request": invalid, "official_diagnostic": diagnostic,
                                  "binding_diagnostic": binding_diagnostic}],
    }, indent=2) + "\n")
    print(f"Selected-year input: {len(results)} three-way checks passed")
    print("Selected-year admission: conflicting same-start spells rejected by Rust and Python")


if __name__ == "__main__":
    main()
