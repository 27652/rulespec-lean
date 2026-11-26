# RuleSpecLean roadmap

Last updated: 2026-11-26

## 1. Project objectives

Translate compiled Axiom RuleSpec artifacts into Lean 4 expressions, preserve rule evaluation within explicit supported domains, and build a reproducible basis for compiler correctness proofs and legal corpus validation.

The initial goal is scalar validation on real compiled artifacts. Later work covers decimal arithmetic and rounding, entity relations, cross-period computation, representative tax and benefit cases, and semantic preservation. Full coverage of U.S. law is outside v0.1 scope.

## 2. Current baseline

| Item | Status | Evidence |
| --- | --- | --- |
| Artifact v3 subset translation | Implemented | Python translator, generated code, and manifest |
| Scalar arithmetic, three-valued logic, and lazy branches | Implemented | Python tests and Lean assertions |
| Dependency analysis, fixed-date version selection, and parameter tables | Implemented | Example translations and unit tests |
| Exact scale-6 numeric subset | Implemented | Explicit rejection outside precision or range limits |
| Python test suite | 87 passed | Seeded formula comparisons, artifact regression, binding, and Decimal compiler tests |
| Lean 4.26.0 build and axiom audit | Passed | 46 build jobs from a clean export of the root layout; [axiom audit log](reports/v0.1/proofs/proof-axioms.log) |
| Official Rust compilation and loading | Passed | Genuine v3 artifact for the upstream synthetic flat-tax example |
| Rust/Python/Lean comparison | 107 flat-tax cases passed | Boundary and seeded random inputs |
| Fixed-corpus static scan | 800 modules compiled; 2,342 rule instances translated normally | 734 more contain missing-version fault nodes; see `reports/v0.1/corpus/corpus-static.json` for denominators and diagnostics |
| Root-layout upstream verification | Complete local run passed | A committed export with PyYAML 6.0.3 reproduced static, replay, and patch reports byte-for-byte; no loss among 6,168 passing expectations |
| Remote CI | Pre-restructuring baseline and root layout passed | [Run 45783084227](https://github.com/27652/rulespec-lean/actions/runs/45783084227) on `a44f5c5`: `python-and-lean` and `upstream-integration` passed, and the integration artifact was uploaded. The pre-restructuring baseline passed in [run 45774870910](https://github.com/27652/rulespec-lean/actions/runs/45774870910) on `9abeb38` |

The upstream engine is pinned to `a4322e45a035ba9fd412d01bebe078aeaa46cd54`. Flat-tax is an upstream synthetic rule, and CTC-like is a hand-authored fixture; neither implements a complete legal case. Lean proves that lowering the independent scale-6 arithmetic fragment preserves values and evaluation faults. That proof does not cover the Python translator or the Rust engine.

## 3. Architecture

```text
RuleSpec source
    │ Official Rust compiler and loader
    ▼
Compiled Artifact v3 + official Explain request
    │ Fixed-date version selection, dependency analysis, AST lowering
    ├── Python interpreter ───────────┐
    └── Lean Expr → Lean interpreter ─┼── Compare values, tags, and fault precedence
        Rust Explain ─────────────────┘
```

The Decimal compiler accepts a prebound environment or a single-query Explain request. It supports latest covering records, explicit year reads, defaults at numeric read sites, and direct binary relation membership facts. General entity and period binding remains open. The Decimal path supports four output rounding modes; full Rust Decimal representation, general relation aggregation, and general cross-period evaluation remain outside acceptance.

## 4. Milestones and acceptance criteria

| Milestone | Goal | Status | Acceptance criteria |
| --- | --- | --- | --- |
| M0 | Scalar translation prototype | Complete | Translator, interpreter, deterministic generation, and basic Python and Lean tests |
| M1 | End-to-end verification on real artifacts | Passed locally and remotely | Pinned source and toolchain, official compile and load, same-input Rust/Python/Lean comparisons, a real U.S. legal scalar module, fault precedence tests, and reproducible CI |
| M2 | Rust Decimal and statutory rounding | Arithmetic and rounding subset validated; general three-valued judgments and additional boundary diagnostics open | Define coefficient, precision, range, overflow, and rounding; pass randomized and adversarial comparisons |
| M3 | Time, entities, and aggregation | Single-query, selected-year, and direct relation aggregation subsets validated; general cross-period evaluation and aggregation open | Compare entity and period binding, defaults, cross-period reads, relation filtering, and aggregation |
| M4 | CTC, EITC, and SNAP cases | 39 published expectations passed with the patch; unpatched full entry points and independent legal review open | Pin legal versions, maintain cases and expectations, retain citations, complete three-way validation and independent legal review |
| M5 | Semantic preservation | Restricted §3403 Lean proofs and Rust source comparisons passed; formal correspondence with the actual Rust implementation open | Independent source and target semantics, explicit domains, translation proofs or certificate checks, no admitted placeholders, and a record of remaining end-to-end gaps by layer |
| M6 | U.S. tax and benefit corpus validation | Fixed baseline measured; remote regression gate passed | Pin the corpus, report distinct compilation, translation, execution, and comparison rates with explicit denominators, and retain blockers |

M2–M4 can advance as dependencies allow. M5 source semantics can be modeled in parallel. M6 coverage depends on earlier validation; static translation success is not semantic agreement.

## 5. Near-term work

| Priority | Work | Next steps and evidence | Maintainer or reviewer action |
| --- | --- | --- | --- |
| Archive publication pending | Research layout | The root layout passed offline and pinned-engine verification locally and on GitHub Actions | The repository maintainer publishes the two archive tags |
| First | M4: unblock the three full entry points | [Candidate results](reports/v0.1/corpus/upstream-candidates.md) show that 0.1.2 compiles all three without a patch but emits v2, which cannot enter the current v3 pipeline. Continue screening v3 fixes and prepare minimal reproductions | Publishing an upstream PR requires repository permissions; upstream maintainers decide on merging |
| Next | M4/M6: evaluate and update pins | A candidate must compile CTC §24(d), EITC §32, and SNAP §273.10 unpatched, replay 39 published expectations, and check every existing pass in the fixed baseline. Across snapshots, align sources, cases, and outputs individually when the same-snapshot gate cannot apply; record changed and incomparable items separately | If no candidate qualifies, the project maintainer decides whether to wait or revise acceptance to allow a maintained patch. Incomparable items do not count as passes |
| In parallel | M5: verify Rust source correspondence | Assess tools on §3403's actual input lookup and version selection functions, document the supported boundary, and add any proved result to the axiom audit. Then extend toward request parsing and Decimal evaluation | The project maintainer confirms any narrowing of proof scope or substitution of differential evidence for formal acceptance |
| In parallel | M4: independent legal review | Use the [review materials](docs/legal-review.md) to check legal versions, parameter sources, boundary cases, and Explain traces; record discrepancies by case | An independent reviewer issues the legal conclusion |
| Ongoing | Git and CI | Commit by topic, run local regressions, verify remote commits and jobs, and update evidence | The maintainer pushes; protected branches and private resources require authorized access |

Candidate investigation and local verification can proceed without a maintainer decision. Extend M2 and M3 within their respective supported domains. When milestone status, acceptance scope, or blockers change, update sections 4 and 5 using reproducible evidence. Keep commands, logs, and per-case results in `reports/`.

### M1: reproducible baseline and diagnostic coverage

- [x] Pin the upstream engine and retain example provenance, license, and hash.
- [x] Compile and load the synthetic scalar module with the official engine and compare 107 cases across all three runtimes.
- [x] Build the base Lean modules and check generated assertions.
- [x] Include the real artifact, cases, reports, and generated Lean code in offline regression checks.
- [x] Rebuild the pinned Rust engine and reproduce genuine compilation and comparisons in CI, retaining logs.

The comparison harness rejects empty case lists, duplicate names, CLI failures, non-Explain fallbacks, extra results, and output key mismatches. Eight Rust/Python/Lean fault comparisons cover missing input, type mismatch, division fault precedence, missing formula versions, and index evaluation and validation before missing parameter-table versions. Diagnostics must match full patterns from the pinned engine. Additional fault classes, version boundaries, and binding checks remain open.

### M1: real legal scalar module

- [x] Pin the `rulespec-us` corpus to `d8a4c9cb560ed55c6db47ea36214249f67319461`.
- [x] Select a real legal output with a small dependency closure and no entity relations or cross-period computation.
- [x] Record the provision, version date, input binding, and unsupported nodes.
- [x] Compare at least 100 boundary and random inputs and report legal cases separately.

`us/statutes/26/3403.yaml` passed 105 official Rust/Python/Lean comparisons. Retained evidence includes source, license, hashes, cases, and reports. Interoperability does not establish legal accuracy.

### M2–M6: delivered scope and open work

- [x] Build the Decimal and output rounding matrix (3,520 three-way library-level checks).
- [ ] Consolidate specifications for defaults, version boundaries, missing inputs, and fault precedence.
- [ ] Define the M2/M3 supported domains and corresponding differential suites.

**M2: Decimal.** Independent Python and Lean models represent coefficients and scale, enforce a 96-bit coefficient and scales from 0 to 28, and implement four output rounding modes. Lean proves that successful rounding uses the smaller of the input scale and requested scale and preserves valid inputs when no reduction is needed. The oracle pins `rust_decimal` 1.41.0. Beyond 3,520 rounding checks, the Decimal path passed 852 three-way and 17,200 extended Rust/Python arithmetic comparisons of coefficients, scale, and faults. The original interpreter retains the conservative scale-6 subset.

The 72 Decimal rule comparisons include 24 rounding-dependency checks, 7 `min`/`max`/`ceil`/`floor` checks, 6 numeric comparison conditions plus 6 compound conditions, 11 indexed parameter lookups, and checks for judgments, covering records, missing inputs, missing versions, and numeric boundaries. Indexed lookups cover version changes, i64 limits, and invalid keys. Determinate judgments support short-circuit `and`, `or`, `not`, and standalone outputs. All 107 Decimal flat-tax comparisons passed, exercising comparison judgment references and versioned unindexed parameters. Signed zero, byte-for-byte wire equivalence, general three-valued judgments, and full-domain proofs remain outside scope. See the [Decimal validation matrix](reports/v0.1/decimal/decimal-semantics.md).

**M3: binding and relations.** Binding selects the latest record covering the full period and accepts identical records sharing a start date. Six `input_for_year` comparisons cover missing selected-year input and duplicate records; Rust and Python independently rejected conflicting records. Three original ProgramSpec cases cover numeric `input_or_else`. Direct binary relations support deduplication, period filtering, and member-local predicates; four unfiltered counts and five filtered sums passed, including missing member input and addition overflow. CTC amount cases exercise filtered counts. Multi-query execution, derived relations, nested aggregation, and general cross-period evaluation remain open.

**M4: legal cases.** CTC MAGI, phaseout, after-advance amount, and the §24(h)(5) refundable cap passed 5, 7, 7, and 4 checks respectively. The after-advance cases cover selected base and §24(h) paths. EITC earned income passed 3 checks before the §112 election and 2 on its election branch; the SNAP FY 2024 net-income limit passed 5. The pinned engine rejects transitive dependencies of the three full entry points in the fixed corpus.

In a temporary copy, the shared CTC/EITC parameter module uses IRS page 15, which contains the seven parameter values, as its compilation citation. The report retains page 14 context and the original verification block. The two entry points compiled, and 11 and 10 closure modules were verified. The SNAP patch retains citations, archives unsupported legacy `values`, and declares `Person` and `Household` slots for `member_of_household`. Compilation was followed by verification of four closure modules and citation checks across 32 compiled rules. The patched replay passed 39 published expectations (4 CTC, 2 EITC, 33 SNAP §273.10) plus 2 separate SNAP membership judgments. See the [patch validation report](reports/v0.1/corpus/corpus-patch-validation.json) for original diagnostics, artifacts, and replay evidence. These results are separate from fixed-corpus acceptance and independent legal review.

**M5: preservation.** `ScalarPreservation.lean` proves result preservation for scale-6 literals, prebound numeric inputs, numeric conversion, arithmetic, maxima, no-match branches, decimal-valued parameter tables, and lazy less-than conditionals. The table proof covers empty tables, invalid indices, missing keys, and numeric limits. A verified recognizer checks the generated §3403 term against the independent source term; the theorem preserves values and faults for every prebound decimal environment. `VersionSelection.lean` proves that the independent date model selects an applicable version with the latest start and characterizes when none applies. `versioned_lowering_preserves_result` covers arbitrary version lists, formula evaluation faults, and missing versions.

`Legal3403Artifact.lean` reads the retained Artifact v3 JSON and checks the payment obligation expression and its sole version's start date. `Legal3403Binding.lean` binds annual Explain requests with one employer, one fact, and whole-dollar amounts to scale-6 coefficients and query start dates, then proves that decoded requests satisfy the existing preservation theorem's premises. All 105 retained requests are checked against their expected environments. Run `lake build RuleSpecLean.Proofs.ProofAudit` to check dependencies. Fixed-file certificates use `native_decide` and depend on `Lean.ofReduceBool` and `Lean.trustCompiler`; the conditional preservation theorems do not. General binding, general Artifact decoding, and equivalence with Rust evaluation remain open.

`Legal3403RustModel.lean` models a single record and version using the pinned [`lookup_input`](https://github.com/TheAxiomFoundation/axiom-rules-engine/blob/a4322e45a035ba9fd412d01bebe078aeaa46cd54/src/engine.rs#L2914-L2950) and [`semantics_at` / `version_at`](https://github.com/TheAxiomFoundation/axiom-rules-engine/blob/a4322e45a035ba9fd412d01bebe078aeaa46cd54/src/model.rs#L564-L581). The [boundary report](reports/v0.1/proofs/legal-3403-rust-model.json) records six Rust requests and twelve Lean assertions. `Legal3403RustSource.lean` proves that the single-record, single-version transcription of lookup, period coverage, and version filtering agrees with the model, and connects it to request preservation. `experiments.check_3403_rust_source` verifies two pinned source hashes, compiles extracted Rust bodies, and compares 36 lookup and 9 selection results in a harness with encoded dates and amounts. CI compares the [source report](reports/v0.1/proofs/legal-3403-rust-source.json) and audits the new theorems. Differential testing supports the link between the transcription and actual Rust; machine verification of production Rust, request parsing, and Decimal evaluation remains open.

**M6: fixed corpus.** The scan found 2,304 YAML files, of which 1,152 are case files. Of 1,152 compilation candidates, 800 compiled and 352 failed. Of 3,099 compiled rule instances, 2,342 translated normally at the snapshot date, 734 contained missing-version fault nodes, and 23 did not translate. Three-way comparisons passed 6,168 of 33,954 published output expectations (18.17%). Parameter table version handling added four passes without losing any of the previous 6,164. See the [corpus validation report](reports/v0.1/corpus/corpus-validation.md) for denominators and blockers.

## 6. Verification and delivery standards

[Catala](https://github.com/CatalaLang/catala) and its [example library](https://github.com/CatalaLang/catala-examples) illustrate how to organize statutory rules and executable cases. [PolicyEngine US](https://github.com/PolicyEngine/policyengine-us) can inform independent tax and benefit cases once legal year, entities, and inputs are aligned. [Aeneas](https://github.com/AeneasVerif/aeneas) is a candidate for connecting restricted Rust functions to Lean specifications. Acceptance rests on the pinned engine, corpus, and project proofs.

- Report Python unit tests, independent formula checks, real Rust comparisons, Lean assertions, and theorems separately. Do not count mocked tests as real engine comparisons.
- Retain the source commit, input SHA-256, snapshot date, output names, and rule provenance for each artifact.
- Use mirrors only for transport, verify toolchain downloads against official checksums, and do not commit toolchain binaries.
- Reject unsupported nodes or numeric semantics explicitly.
- Report CI success only after a real run and avoid claims of legal accuracy without legal validation.

The active project is at the repository root. See the [README](README.md) for layout, [v0.1 reports](reports/v0.1/) for baseline evidence, and [development history](docs/history/README.md) for the old layout and original ZIP. Repository CI in `.github/workflows/ci.yml` uses the same verification entry point as local runs.

## 7. Local verification

```sh
bash scripts/verify.sh offline
```

See the [reproduction guide](docs/reproduction.md) for pinned-engine comparisons and full-corpus replay. This roadmap tracks milestones and acceptance status; versioned reports record individual experiments.
