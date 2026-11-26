# M2 Decimal reference semantics and validation matrix

## Reference versions

- Axiom engine: `a4322e45a035ba9fd412d01bebe078aeaa46cd54`.
- Engine `Cargo.lock`: rust_decimal `1.41.0`.
- The standalone numeric oracle pins its dependency and checks in its `Cargo.lock`.
- Upstream `src/model.rs::RoundingMode::round_decimal` calls `round_dp_with_strategy`.

## Implemented scope

Python `tools/decimal_model.py` and Lean `RuleSpecLean/Semantics/Decimal.lean` independently implement:

- Coefficients with absolute value at most `2^96 - 1` and scales from 0 to 28.
- Exact parsing of plain decimal text in Python, rejecting out-of-domain values.
- Rounding to 0–28 places without increasing the original scale.
- Rounding without binary floating point.

| RuleSpec mode | Rust strategy | Tie rule or direction | Negative example (2 places) |
| --- | --- | --- | --- |
| half_up | MidpointAwayFromZero | Ties away from zero | -1.225 → -1.23 |
| half_even | MidpointNearestEven | Ties to even | -1.225 → -1.22 |
| floor | ToNegativeInfinity | Toward negative infinity | -1.221 → -1.23 |
| ceil | ToPositiveInfinity | Toward positive infinity | -1.229 → -1.22 |

The differential matrix includes positive and negative midpoints, zero, retained decimal places, 28-place precision, 96-bit coefficient boundaries, and seeded random coefficients. It compares coefficients and scale rather than formatted text alone.

## Arithmetic and rule validation

The experimental Python and Lean models for addition, subtraction, multiplication, and division cover scale alignment, finite-precision division, midpoint-to-even rounding when reducing precision, division by zero, and overflow. Division extends the quotient in groups of up to nine digits and removes trailing zeros according to the pinned library. Addition, subtraction, and multiplication retain the corresponding zero fast paths.

The 852 three-way checks compare signed coefficients, scale, and faults (`decimal-arithmetic.json`). Another 17,200 Rust/Python checks sample the full range and exercise its boundaries (`decimal-arithmetic-extended.log`). Neither matrix compares the sign of zero or proves equivalence over the full domain.

The independent numeric interpreter and Lean Decimal expressions verify rounding before dependency reads: 1.005 rounds to 1.01 before multiplication by 2 yields 2.02 (`decimal-dependency.json`). `tools.compile_decimal.DecimalCompiler` generates these checks from official artifacts. All 24 Rust/Python/Lean checks across `half_up`, `half_even`, `floor`, and `ceil` passed. Dependencies are emitted first and retain their own rounding nodes. The generator embeds prebound inputs after checking request binding.

- Numeric literals, inputs, references, arithmetic, `min`, `max`, `ceil`, and `floor` are supported. Seven engine comparisons cover negative values, truncation boundaries, and inputs with 28 decimal places. Extrema pick the first value on a tie. Request binding reuses entity and period checks; each runtime validates its numeric input. Unsupported nodes are explicitly rejected.
- Six comparison condition cases cover 28-place thresholds, equal numbers at different scales, and skipping division by zero in the unselected branch.
- Comparison judgment references and versioned numeric parameters support all 107 upstream synthetic flat-tax comparisons (`decimal-flat-tax.json`). Successful rule outputs are compared numerically.
- Eleven indexed parameter comparisons cover integral values with a nonzero scale, both i64 bounds, version changes, missing versions or keys, and fractional or out-of-range keys. Faults match the pinned CLI's full diagnostic (`decimal-dependency.json`).
- Determinate numeric judgments support short-circuit `and`, `or`, and `not`; six compound conditions and four judgment outputs were checked. Direct Boolean inputs and literals support equality and inequality, exercised in the CTC phaseout and after-advance cases. Missing Boolean input faults when read.
- Missing input cases cover direct reads, division error precedence, and skipping an unselected branch. Two covering-record cases verify independence from input order. Compiler regressions cover cycles, missing versions or inputs, currency precision, generation order, and generated-file consistency.
- Request mode lowers missing formula versions to evaluation faults. Four engine comparisons cover scalar, judgment, dependency, and lazy branch cases. Five additional boundary checks cover negative zero at scale 28, rounding negative values to zero, and the 96-bit multiplication limit.
- Four 26 USC §1211 numeric `match` cases were compared on both Decimal and scale-6: two matching outcomes, no matching branch, and missing input while evaluating the subject. The last two check complete CLI diagnostics and fault precedence ([§1211 report](../legal/capital-loss-match.json)). `RuleSpecLean.eval_noMatch` proves that the scale-6 node preserves a subject evaluation fault; `lowering_preserves_result` extends this to numeric subjects in the independent source semantics.

## Comparison contract

- Inputs accept plain decimal strings and exact integers. JSON floats, scientific notation, and values exceeding the 96-bit coefficient or scale-28 limits are rejected.
- Library comparisons check coefficients, scale, and faults. Rule comparisons check numeric values or determinate judgments; selected failures compare full CLI diagnostics and Python/Lean fault tags.
- Python and Lean treat positive and negative zero as the same numeric value. Reports retain the original Rust scalar text as an observation. Retaining the sign of zero, trailing zeros, or byte-identical wire format is outside this contract.

## Remaining work

- Expand arithmetic boundary checks and prove the supported semantics.
- Extend judgments to support `undetermined`. The original scale-6 path remains independently usable.
- Complete the numeric support domain and semantic preservation proof.

M2 remains open. The numeric library comparisons do not establish compiler correctness.
