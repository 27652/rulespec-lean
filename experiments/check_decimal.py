"""Generate a reproducible Rust/Python/Lean output-rounding matrix."""
import argparse
import json
from pathlib import Path
import random
import subprocess

from tools.decimal_model import DecimalValue, MAX_COEFFICIENT, MODES


def matrix():
    values = ["0", "0.00", "0.004", "0.005", "0.015", "1.225", "1.235",
              "2.5", "3.5", "0.0000000000000000000000000001",
              str(MAX_COEFFICIENT), "7922816251426433759354395033.5"]
    values += ["-" + v for v in values if not v.startswith("0.00")]
    rng = random.Random(20261126)
    values += [str(DecimalValue(rng.randrange(-MAX_COEFFICIENT, MAX_COEFFICIENT + 1),
                                rng.randrange(29))) for _ in range(200)]
    return [{"input": value, "places": places, "mode": mode}
            for value in values for places in (0, 2, 6, 28) for mode in MODES]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--oracle", required=True, type=Path)
    parser.add_argument("--lake", required=True, type=Path)
    args = parser.parse_args()
    cases = matrix()
    result = subprocess.run([str(args.oracle.resolve())], input=json.dumps(cases),
                            text=True, capture_output=True, check=True, timeout=60)
    rows = json.loads(result.stdout)
    if len(rows) != len(cases):
        raise ValueError("oracle result count mismatch")
    modes = dict(zip(MODES, ("halfUp", "halfEven", "floor", "ceil")))
    lines = ["import RuleSpecLean.Decimal", "", "open RuleSpecLean.DecimalModel", ""]
    for case, row in zip(cases, rows):
        if any(case[k] != row[k] for k in case):
            raise ValueError("oracle case identity mismatch")
        value = DecimalValue.parse(case["input"])
        actual = value.round(case["places"], case["mode"])
        expected = DecimalValue(int(row["coefficient"]), row["scale"])
        if actual != expected:
            raise ValueError(f"rounding mismatch: {case}: {actual} != {expected}")
        lines.append(f"#guard round ⟨({value.coefficient}), {value.scale}⟩ {case['places']} "
                     f".{modes[case['mode']]} == some ⟨({expected.coefficient}), {expected.scale}⟩")
    Path("RuleSpecLean/DecimalTests.lean").write_text("\n".join(lines) + "\n")
    built = subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.DecimalTests"],
                           text=True, capture_output=True, timeout=300)
    print(built.stdout + built.stderr)
    built.check_returncode()
    report = {"rust_decimal": "1.41.0", "seed": 20261126, "cases": len(rows),
              "scope": "coefficient/scale and four output-rounding modes; not arithmetic",
              "status": "Rust/Python/Lean passed", "results": rows}
    Path("reports/v0.1/decimal/decimal-rounding.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"Decimal rounding: {len(rows)} three-way checks passed")


if __name__ == "__main__":
    main()
