# RuleSpecLean v0.1

Historical archive. Paths and status below reflect the pre-restructuring layout. Follow those references in the `archive/pre-research-layout` tag; see the [roadmap](../../road.md) for current status.

## M2 numeric work

Arithmetic passes **852** Rust/Python/Lean coefficient, scale and fault checks,
plus **17,200** extended Rust/Python checks. Signed zero is outside these
comparisons. Rounded-dependency cases include `1.005 → 1.01 → 2.02`.
Numeric-only artifact-to-Decimal lowering now exists in `tools/compile_decimal.py`;
the dependency tests are automatically generated, with **24** official-engine
cases covering all four rounding strategies. Seven additional official-engine
cases exercise `min`, `max`, `ceil`, and `floor`, including inputs with 28
decimal places. Six cases check numeric comparison branches, including a zero
input whose unselected branch would divide by zero. The Decimal runtime also
passes all **107** upstream flat-tax cases using comparison judgments in
conditions and versioned numeric parameters. Eleven additional cases cover
indexed parameter lookup, including version changes, missing entries and
fractional or out-of-range keys. Numeric judgments support short-circuit
`and`, `or`, and `not`, and can be emitted with `--judgment`.

The Decimal compiler accepts a prebound `--env` or a single-entity Explain
`--request`. With `--covering`, it selects the latest spell that covers the
entire period and resolves explicit numeric `input_for_year` reads against
January 1–December 31 of the selected year. Six three-way checks are
recorded in `reports/selected-year.json`. `--relation-counts` additionally binds
unfiltered counts of distinct members of supplied binary relations whose tuples
cover the query. See `reports/direct-count.json`.
With `--filtered-counts`, a query can bind member facts from supplied binary
relations and perform filtered counts and numeric sums. Filters support direct
boolean equality and inequality. The pinned CTC after-advance and §24(h)(5)
refundable-cap outputs exercise filtered counts; `reports/direct-count.json`
includes filtered sum cases.
See `reports/decimal-arithmetic.json` and `reports/decimal-dependency.json`.

The pinned corpus replay passed **6,168 of 33,954** published output expectations
(18.17%), including single-entity-type table cases checked row by row. See
[corpus-validation.md](reports/corpus-validation.md) for the static audit, replay
denominators, and scoped CTC, EITC, and SNAP comparisons.

An independent coefficient/scale model and four output-rounding modes now exist
in `tools/decimal_model.py` and `RuleSpecLean/Decimal.lean`. The locked
rust_decimal 1.41.0 oracle matched Python and Lean on **3,520** boundary/random
cases. See `reports/decimal-semantics.md` and `reports/decimal-rounding.json`.
This is library-level rounding validation, not full-engine rounding integration;
the original rule evaluator still uses the conservative scale-6 subset.

```sh
cargo build --locked --manifest-path tools/decimal_oracle/Cargo.toml
python -m tools.check_decimal --oracle tools/decimal_oracle/target/debug/rulespec-decimal-oracle --lake /path/to/lake
```

## Workspace update

**Integration update:** the pinned Rust binary has now compiled the upstream
flat-tax source into a genuine v3 artifact, loaded it through the official
loader, and matched Python on all **107** cases. See `reports/reference.json`.
All 107 generated Lean guards have also passed compilation on Lean 4.26.0;
the base build passed its 13 assertions and three kernel-checked theorems.
This updates the original
archive's historical verification-status section below; it does not establish
US-law corpus coverage or semantic preservation.

The archive has been extracted without replacing the supplied ZIP or roadmap.
Run **all** Python tests with `python -m unittest discover -v` (87 tests,
including the original 10,000 seeded formula cases). Added regressions cover
malformed expressions, strict artifact version typing, scanner invocation as
both a script and module, and the reference harness's mismatch handling.
Reference-harness unit tests use mocked CLI responses and are **not** evidence
of an actual Rust comparison.

`tools.test_artifact_regression` additionally replays the retained 107 official
results offline, checks artifact/build identity, and compares generated Lean
modules and guards byte-for-byte. This replay does not execute Rust again.

The actual repository workflow lives at `../.github/workflows/ci.yml`, with
the extracted project as its working directory. The archive's nested workflow
is retained for standalone use.

The repository workflow also includes an `upstream-integration` job, pinning
Rust 1.98.1 and the upstream commit. It rebuilds the official engine, compiles
the sample, compares all three runtimes and uploads integration evidence.
Remote GitHub Actions execution has not yet been verified. The reference
harness rejects duplicate cases, wrong output identity, non-Explain fallback,
unexpected response cardinality and CLI failures; Rust error/Fault equivalence
is still outside its supported comparison domain.

`tools.check_faults` separately compares a restricted set of evaluation faults.
Eight Rust/Python/Lean cases pass, covering missing input, type mismatch,
division error precedence, a query before the first formula version, and
index evaluation and validation before a missing parameter-table version. See
`reports/faults.json` and `RuleSpecLean/FaultTests.lean`.
The CLI exposes text diagnostics; only anchored known diagnostic forms are
accepted. This is not structured error-API equivalence. The synthetic fault
fixture extends the upstream flat-tax example with a division rule; it is not
a legal module. Additional errors and general binding remain unsupported.

The pinned `rulespec-us` module for 26 USC 3403 now passes 105 actual
Rust/Python/Lean cases; evidence is in `reports/legal-3403.json`. Source identity
and corpus license are retained under `fixtures/legal-pin.json` and
`fixtures/CORPUS-LICENSE`. This is interoperability validation of upstream's
encoding, not an independent legal audit. Rebuild legal and fault artifacts with
`python -m tools.rebuild_fixtures --engine /path/to/axiom-rules-engine`.

`tools.request_binding` verifies the supplied environment against the official
request for one entity and an exactly matching interval, resolving only published
input aliases. Defaults, duplicate spells, relations, pins and interval overlaps
are rejected. The adapter deliberately does not implement general M3 binding.

`fixtures/upstream-flat-tax.rules.yaml` is copied verbatim from a pinned real
upstream engine checkout, with commit, SHA-256 and license alongside it. It is
the upstream's **synthetic flat-tax example**, not a real US statute or a
download of the `rulespec-us` corpus.

### Reference comparison harness

With a clean binary built from `fixtures/upstream-pin.json`'s commit:

```sh
python -m tools.prepare_reference --engine /path/to/axiom-rules-engine
python -m tools.check_reference fixtures/upstream-flat-tax.artifact.json \
  fixtures/upstream-flat-tax.cases.json --engine /path/to/axiom-rules-engine \
  --lake /path/to/lake
```

Preparation verifies the copied source checksum and binary build identity,
compiles it through the official CLI, and prepares 107 deterministic boundary
and seeded random cases. It requires the upstream compiler and remains an
integration step, not part of the dependency-free unit tests.

`python -m tools.check_reference ARTIFACT CASES --engine /path/to/axiom-rules-engine`
loads an official compiled artifact through the official `run-compiled`
Explain command for every case, compares tagged scalar values with the Python
mirror, and generates `RuleSpecLean/Reference.lean` plus
`RuleSpecLean/ReferenceTests.lean`. Then run:

```sh
lake build RuleSpecLean.ReferenceTests
```

Cases are a nonempty JSON array. Each case contains `name`, `as_of`, `rule`
(internal IR name), `public_output` (official output key), `env` (prebound
slot-to-tagged-value object), and `request` (official Explain request with one
query). Cases share a snapshot and output; the query period start must equal
the snapshot. The caller must establish that `env` is the exact binding of
the official request; general entity/period/default binding is not implemented.
Only successful scalar outputs are handled, not Rust errors or judgment
outputs. Without `--lake`, a Python/Rust success report deliberately leaves Lean
marked pending; generated guards must then be compiled separately. This harness is M1 groundwork,
not completion of the roadmap's end-to-end gate or a compiler correctness proof.

A prototype for lowering a **restricted snapshot of RuleSpec compiled artifact v3**
to a deep embedding in Lean 4. No language model is involved in conversion.

## Verification status (2026-11-26)

- The local suite passes 87 Python tests, including the 10,000 seeded formula
  cases, and 41 Lean build jobs. See [the progress report](reports/progress.md).
- The pinned Rust engine has been run against both the upstream synthetic
  flat-tax example and selected federal rules. Corpus compilation, replay and
  legal component comparisons are reported in [corpus-validation.md](reports/corpus-validation.md).
- Lean checks preservation for a restricted scale-6 fragment. For the retained
  §3403 payment output, the decoder reads the Artifact v3 JSON and checks its
  sole open-ended version against the independent source term. The result
  theorem covers every prebound decimal environment and encoded day. The fixture
  certificate uses Lean's native evaluator; the conditional preservation theorem
  does not. Run `lake build RuleSpecLean.ProofAudit` and `lake env lean
  RuleSpecLean/ProofAudit.lean` to check the axiom policy and reproduce the report.
  Full artifact-to-Rust equivalence and independent legal review remain open.

The fixture is a simplified, CTC-like calculation with precomputed eligible
dependent counts. It is not a complete implementation of 26 USC §24, a filing
calculator, or an artifact produced/accepted by the official engine. Its
`interface`/metadata are deliberately synthetic placeholders.

## Quick start (Python 3.10+)

From the repository root:

```sh
python -m unittest -v tools.test_prototype
python tools/compile_ir.py fixtures/ctc-like.artifact.json \
    --as-of 2025-01-01 --output credit
python -m tools.scan_artifacts fixtures --as-of 2025-01-01
```

The conversion emits `RuleSpecLean/Generated.lean` and
`generated-manifest.json`. The manifest records source identity, input SHA-256,
snapshot date, output names and rule provenance. Internal IR names are used
for `--output`. Each dependency is declared before rules that reference it.

For an execution of the fixture's Python mirror:

```sh
python -c 'from tools.test_prototype import *; c=Compiler(FIXTURE,"2025-01-01"); c.compile(["credit"]); print(run(c.normal["credit"],env(),c.normal))'
```

Expected: `('decimal', 4800000000)` = $4,800 at scale 6.

## Lean build (requires elan / Lean 4)

The project selects Lean 4.26.0, without Mathlib. Install elan using the
official Lean installation instructions, then:

```sh
lake build
```

The `RuleSpecLean.Tests` module runs the sample, boundary/error assertions,
and imports the candidate theorems in `Core.lean`. If any Lean build error
occurs, treat it as an open issue; do not claim verified status. The supplied
GitHub Actions workflow runs Python tests, regenerates the fixture, and invokes
the Lean build. Use the fixture when building the included tests; for other
outputs, generate a separate module or replace the test module.

## Accepted fragment

| Feature | v0.1 behavior |
|---|---|
| Input | Prebound slot -> tagged value for one entity and period |
| Rule references | Acyclic dependency closure; unsupported or cyclic references rejected |
| Numeric literals | Signed i64, plain exact decimal at scale <= 6 |
| Arithmetic | Add, sub, mul, div, min, max, ceil, floor |
| Conditions | Lazy scalar if; undetermined goes to else |
| Comparison | Numeric comparisons, Boolean/text equality and inequality |
| Judgments | Comparison, judgment refs, and/or/not; internal three-valued representation |
| Parameters | Indexed tables, version selected at fixed period start |
| Rule versions | Latest applicable start, last-in-document tie, inclusive end |
| Output rounding | Rejected at lowering |
| Relations and temporal data | Rejected when reached in dependency lowering |
| Provenance | Rule fields and artifact identity copied to manifest |

Numeric contract: decimals have coefficient `c` representing `c / 10^6`,
with `|c| <= 10^21`. Arithmetic is accepted only if every required intermediate
decimal remains in the restricted domain; e.g. `1/3` is an explicit refusal.
This is an exact, conservative subset, **not** a full model of rust_decimal.
Input slots must contain valid supported literal values; invalid inputs are
outside the Python evaluation contract. Date values, input defaults,
cross-period data, relation predicates, aggregate relations, elections as
optimization, request pins, legal output rounding and exact upstream error
messages/traces are not implemented. Direct rule references assume scalar or
judgment kind matches. The adapter does not validate the full artifact
schema, artifact integrity, request binding or namespace rules; upstream
admission is a precondition. Static rejection may include untaken branches.
Missing parameter versions are refused at lowering, not reproduced lazily.

## Try a real artifact

1. Clone and pin both upstream repositories to actual commit hashes:
   - https://github.com/TheAxiomFoundation/axiom-rules-engine
   - https://github.com/TheAxiomFoundation/rulespec-us
2. Build the official Rust engine, consult its CLI (`--help`) and compile a
   small scalar-only tax module to a v3 JSON artifact. Use the official
   validation/loading mechanism before conversion.
3. Inspect `program.derived[].name`, choose a scalar output and run:

```sh
python tools/compile_ir.py /path/to/official-artifact.json \
  --as-of 2025-01-01 --output INTERNAL_RULE_NAME \
  --lean RuleSpecLean/Official.lean --manifest reports/official-manifest.json
```

4. Build `lake build RuleSpecLean.Official`; supply the same valid, prebound
   entity/period facts to the Lean evaluator and Rust Explain. Check values,
   tags and error priority separately. The request adapter for this is the
   next milestone, not included.
5. Use `python -m tools.scan_artifacts /path/to/artifacts --as-of 2025-01-01`
   to inventory static lowering success and blockers. Static success does
   not imply compilation, semantic equivalence, or law coverage.

## Roadmap and proof obligations

1. **Gate A: real interoperability.** Pin commits, obtain a real scalar
   artifact, run upstream Explain and Lean on the same 100+ cases. Complete
   CI and fix all compilation failures. No artifact schema or error mismatch
   should be silently accepted.
2. **Gate B: exact reference numeric semantics.** Implement decimal
   coefficient/scale, all four output-rounding strategies, bounds and overflow.
   Compare with the actual rust_decimal implementation across randomized and
   adversarial tests. Define the admissible domain precisely.
3. **Gate C: data binding and time.** Implement entity ID and interval-based
   input resolution, version lookup in the evaluator, missing values, and
   selected-year inputs. Preserve rule-level rounding before dependencies read.
4. **Gate D: relations.** Support sorted distinct finite relation members,
   count/sum, filters, only and extrema; then relation-role contexts, exists
   and derived relations. Use actual CTC and SNAP modules.
5. **Gate E: semantic-preservation proof.** Define independent formal source
   semantics `evalRS` and translation `lower`. Prove
   `evalRS p d q = evalLean (lower p) d q` for an explicit supported domain.
   For Python code generation either formalize translation in Lean or verify
   translation certificates in Lean. A theorem about the target interpreter
   alone is not a theorem about the Python converter or the Rust engine.
6. **Gate F: corpus analysis.** Run the scanner on real artifacts, report
   compile/lowering/runtime/test coverage with explicit denominators, and
   prove useful tax properties; independently audit legal source versions.

## Upstream references

Consulted public documentation/source (main branch viewed 2026-11-26; exact
upstream HEAD was not pinned in this environment):

- https://github.com/TheAxiomFoundation/axiom-rules-engine/blob/main/src/spec.rs
- https://github.com/TheAxiomFoundation/axiom-rules-engine/blob/main/src/model.rs
- https://github.com/TheAxiomFoundation/axiom-rules-engine/blob/main/src/engine.rs
- https://github.com/TheAxiomFoundation/axiom-rules-engine/blob/main/docs/artifact-format.md
- https://github.com/TheAxiomFoundation/axiom-rules-engine/blob/main/docs/execution-semantics.md

All prototype code is original; the fixture was hand-authored from the
documented wire shape. Not affiliated with Axiom Foundation or Lexifina.
