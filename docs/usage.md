# Translation and supported domains

Run the following commands from the repository root. For real input, first use the upstream RuleSpec engine to compile and load an Artifact v3. The translator does not replace upstream schema validation. `--output` takes the internal rule name from the artifact. Each generated file is a snapshot for a fixed date.

## Scale-6 scalar path

```sh
python3 -m tools.compile_ir /path/to/artifact.json \
  --as-of 2025-01-01 --output RULE_NAME \
  --lean RuleSpecLean/Example.lean --manifest .verification/example-manifest.json
lake build RuleSpecLean.Example
```

The environment consists of prebound input slots for one entity and one period. This path supports acyclic dependency closures, integers and exact scale-6 decimals, scalar arithmetic, lazy conditionals, restricted judgments, and parameter tables. Decimal coefficients must have absolute value at most `10^21`, and required intermediate values must also be exactly representable. Output rounding and relation aggregation are outside this path's scope.

## Decimal snapshot path

```sh
python3 -m tools.compile_decimal /path/to/artifact.json \
  --as-of 2025-01-01 --output RULE_NAME --env /path/to/env.json \
  --lean RuleSpecLean/DecimalExample.lean
lake build RuleSpecLean.DecimalExample
```

Use `--request` instead to bind a supported single-query Explain request. The model retains a 96-bit decimal coefficient and a scale from 0 to 28. It supports arithmetic, four output rounding modes, and selected comparison judgments. Period coverage, explicit year reads, and direct binary relation aggregation each have their own supported subset and flags. See `python3 -m tools.compile_decimal --help` and the [Decimal experiment notes](../reports/v0.1/decimal/decimal-semantics.md). General binding, arbitrary relations or cross-period semantics, signed zero, and byte-for-byte wire equivalence are outside the current validation scope.
