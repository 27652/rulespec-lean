"""Check numeric read-site defaults against the pinned raw ProgramSpec engine."""
import argparse
from fractions import Fraction
import json
from pathlib import Path
import subprocess

from tools.compile_decimal import DecimalCompiler
from tools.decimal_model import DecimalValue
from tools.decimal_runtime import NumericRuntime
from tools.request_binding import bind


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", type=Path, required=True)
    parser.add_argument("--lake", type=Path, required=True)
    args = parser.parse_args()
    engine = args.engine.resolve()
    pin = json.loads(Path("fixtures/upstream-pin.json").read_text())
    build = json.loads(subprocess.check_output([str(engine), "capabilities"], timeout=30))["engine_build"]
    if build != {"commit": pin["commit"], "dirty": False}:
        parser.error("clean pinned engine required")

    def decimal(text):
        return {"kind": "decimal", "value": text}

    amount = "amount"
    rule = {"name": "out", "entity": "Person", "dtype": "decimal", "semantics": "scalar",
            "expr": {"kind": "add", "items": [
                {"kind": "input_or_else", "name": amount, "default": decimal("2.50")},
                {"kind": "input_or_else", "name": amount, "default": decimal("1.25")},
            ]}}
    program = {"derived": [rule]}
    # Adapter metadata for raw ProgramSpec (the YAML surface cannot emit these reads).
    artifact = {"artifact_format_version": 3,
                "program": {"derived": [{**rule, "id": "out"}], "interface": {
                    "inputs": [{"name": amount, "entities": ["Person"], "default": None}]}},
                "metadata": {"input_catalog": [{"slot": amount, "request_names": [amount]}]}}
    start, end = "2025-01-01", "2025-12-31"
    lines = ["import RuleSpecLean.Decimal", "", "open RuleSpecLean.DecimalModel", ""]
    rows = []
    for index, (text, expected) in enumerate(((None, "3.75"), ("0", "0"), ("-1.25", "-2.50"))):
        facts = [] if text is None else [{"name": amount, "entity": "Person", "entity_id": "p",
                            "interval": {"start": start, "end": end}, "value": decimal(text)}]
        request = {"mode": "explain", "dataset": {"inputs": facts, "relations": []},
                   "queries": [{"entity_id": "p", "period": {"period_kind": "tax_year",
                                "start": start, "end": end}, "outputs": ["out"]}]}
        response = json.loads(subprocess.run([str(engine), "run"], text=True, check=True, capture_output=True,
                              input=json.dumps({**request, "program": program}), timeout=60).stdout)
        value = response["results"][0]["outputs"]["out"]["value"]
        env = bind(artifact, request, "out", validate_value=DecimalValue.from_literal, read_site_defaults=True)
        actual = NumericRuntime(artifact, start).rule("out", env)
        oracle = DecimalValue.from_literal(value)
        if (response["metadata"]["actual_mode"] != "explain" or
                Fraction(str(oracle)) != Fraction(str(actual)) or Fraction(str(oracle)) != Fraction(expected)):
            raise ValueError(f"default mismatch: {text!r}: {expected}, Rust {oracle}, Python {actual}")
        namespace = f"InputDefaultCase{index}"
        lines.append(DecimalCompiler(artifact, start, env).emit("out", namespace)
                     .removeprefix("import RuleSpecLean.Decimal\n"))
        lines.append(f"#guard match eval {namespace}.output with\n"
                     f"  | .ok v => equalValue v ⟨({oracle.coefficient}), {oracle.scale}⟩\n"
                     "  | .error _ => false\n")
        rows.append({"request": request, "expected": expected, "official_value": value})
    Path("RuleSpecLean/InputDefaultTests.lean").write_text("\n".join(lines).rstrip("\n") + "\n")
    subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.InputDefaultTests"], check=True, timeout=300)
    Path("reports/input-defaults.json").write_text(json.dumps({"engine_build": build, "program": program,
        "scope": "raw ProgramSpec, read-site defaults", "status": "Rust/Python/Lean passed",
        "cases": len(rows), "results": rows}, indent=2) + "\n")
    print(f"Input defaults: {len(rows)} three-way checks passed")


if __name__ == "__main__":
    main()
