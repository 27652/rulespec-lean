"""Compare signed coefficients, scales and faults with locked rust_decimal."""
import argparse
import json
from pathlib import Path
import random
import subprocess

from tools.decimal_model import DecimalFault, DecimalValue, MAX_COEFFICIENT


def matrix():
    boundary = [("1", "3"), ("1", "0"), ("0", "0"), ("-1", "6"),
                (str(MAX_COEFFICIENT), "1"), (str(MAX_COEFFICIENT), "0.1"),
                (str(MAX_COEFFICIENT), "2"), ("0." + "0"*27 + "1", "0.1"),
                ("1.00", "2.0"), ("0.000", "2.0"), ("1", "2"),
                ("0.0000000000000000000000000001", "0.00000000000000000001"),
                ("-0.0000000000000000000000000001", str(MAX_COEFFICIENT))]
    rng = random.Random(20261127)
    pairs = boundary + [(str(DecimalValue(rng.randrange(-10**20, 10**20), rng.randrange(15))),
                         str(DecimalValue(rng.randrange(-10**20, 10**20), rng.randrange(15))))
                        for _ in range(200)]
    return [{"op": op, "left": a, "right": b}
            for a, b in pairs for op in ("add", "sub", "mul", "div")]


def extended_matrix():
    rng = random.Random(445)
    pairs = [(DecimalValue(rng.randrange(-MAX_COEFFICIENT, MAX_COEFFICIENT + 1), rng.randrange(29)),
              DecimalValue(rng.randrange(-MAX_COEFFICIENT, MAX_COEFFICIENT + 1), rng.randrange(29)))
             for _ in range(2500)]
    scales = (0, 1, 9, 19, 28)
    pairs.extend((DecimalValue(a, s), DecimalValue(b, t))
                 for a in (0, 1, 3, 5, 10, 2**32 - 1, 2**32, MAX_COEFFICIENT - 1, MAX_COEFFICIENT)
                 for b in (0, 1, 2, 3, 5, 10, 2**32, MAX_COEFFICIENT)
                 for s in scales for t in scales)
    return [{"op": op, "left": str(a), "right": str(b)}
            for a, b in pairs for op in ("add", "sub", "mul", "div")]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--oracle", required=True, type=Path)
    parser.add_argument("--lake", type=Path)
    parser.add_argument("--extended", action="store_true",
                        help="Run the larger Rust/Python matrix")
    args = parser.parse_args()
    if not args.extended and args.lake is None:
        parser.error("--lake is required for the three-way matrix")
    if args.extended and args.lake is not None:
        parser.error("the extended matrix compares Rust and Python only")
    cases = extended_matrix() if args.extended else matrix()
    rows = json.loads(subprocess.run([str(args.oracle.resolve())], input=json.dumps(cases),
                                    text=True, capture_output=True, check=True, timeout=60).stdout)
    if len(rows) != len(cases):
        raise ValueError("oracle cardinality mismatch")
    lines = ["import RuleSpecLean.Decimal", "", "open RuleSpecLean.DecimalModel", ""]
    for case, row in zip(cases, rows):
        if row["case"] != case:
            raise ValueError("oracle identity mismatch")
        a, b = DecimalValue.parse(case["left"]), DecimalValue.parse(case["right"])
        expression = f"arithmetic .{case['op']} ⟨({a.coefficient}), {a.scale}⟩ ⟨({b.coefficient}), {b.scale}⟩"
        try:
            actual = a.arithmetic(case["op"], b)
        except DecimalFault as exc:
            if row.get("fault") != str(exc):
                raise ValueError(f"fault mismatch {case}: {exc} != {row}") from exc
            lines.append(f"#guard match {expression} with\n"
                         f"  | .error e => e == .{exc}\n"
                         "  | .ok _ => false")
        else:
            if "fault" in row:
                raise ValueError(f"missed fault: {case}: {row}")
            expected = DecimalValue(int(row["coefficient"]), row["scale"])
            if actual != expected:
                raise ValueError(f"representation mismatch {case}: {actual!r} != {expected!r}")
            lines.append(f"#guard match {expression} with\n"
                         f"  | .ok v => v == ⟨({expected.coefficient}), {expected.scale}⟩\n"
                         "  | .error _ => false")
    if args.extended:
        print(f"Extended arithmetic: {len(rows)} Rust/Python coefficient/scale and fault checks passed")
        return
    Path("RuleSpecLean/ArithmeticTests.lean").write_text("\n".join(lines) + "\n")
    subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.ArithmeticTests"],
                   check=True, timeout=300)
    Path("reports/decimal-arithmetic.json").write_text(json.dumps({
        "rust_decimal": "1.41.0", "cases": len(rows), "seed": 20261127,
        "comparison": "signed coefficient, scale and fault; excludes zero sign",
        "status": "Rust/Python/Lean passed", "results": rows}, indent=2) + "\n")
    print(f"Arithmetic coefficients/scales/faults: {len(rows)} three-way checks passed")


if __name__ == "__main__":
    main()
