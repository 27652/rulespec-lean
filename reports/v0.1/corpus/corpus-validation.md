# Fixed-corpus validation

The corpus is pinned to `d8a4c9cb560ed55c6db47ea36214249f67319461`, and the engine to `a4322e45a035ba9fd412d01bebe078aeaa46cd54`. The static snapshot date is 2025-01-01.

| Stage | Denominator | Result |
| --- | ---: | --- |
| File inventory | 2,304 YAML files | Excludes 1,152 `.test.yaml` case files from compilation |
| Official compilation | 1,152 candidate modules | 800 passed (69.44%); 352 failed |
| Static scale-6 translation | 3,099 compiled rule instances (potential duplicates across artifacts) | 2,342 translated normally (75.57%); 734 include missing-version fault nodes; 23 unsupported |
| Official Explain replay | 33,954 output expectations across 1,152 case files | 6,379 row-level requests, with 6,373 structurally valid responses |
| Lean execution and three-way comparisons | 6,373 valid Explain responses | 6,341 row-level assertions passed, accounting for 6,168 output expectations; 32 fell outside the exact scale-6 domain |

`corpus-static.json` retains file hashes, compiler diagnostics, and translation outcomes and reasons. The corpus root must be a real directory named `rulespec-us`. The scanner verifies the pinned engine identity and the §3403 hash and records hashes per file. The caller supplies the pinned corpus snapshot.

Of the 352 compilation failures, 249 occurred in ordinary compilation and 103 in composed compilation. The first error named `corpus_citation_paths` in 335 modules, unknown `values` in 14, missing relation tuple entity types in 2, and a filename that did not map to a canonical module name in 1. Adding `no_match` support left compilation totals unchanged and reduced static translation blockers from 55 to 23: 16 `count_related`, 4 `sum_related`, and 3 decimal literals outside the exact scale-6 domain. Of the 32 newly supported instances, 29 translated normally and 3 still contain missing-version nodes. Selected relation aggregates were validated separately on the Decimal path.

| Legal component | Official Rust Explain / Python / Lean | Full entry point status |
| --- | --- | --- |
| CTC §24 MAGI, phaseout, and after-advance amount | 5, 7, and 7 cases: `ctc-magi.json`, `ctc-phaseout.json`, `ctc-after-advance.json` | §24 compiles; checks cover selected base and §24(h) amount paths, short of the full refundable credit |
| CTC §24(h)(5) refundable cap | 4 cases: `ctc-refundable-cap.json` | Covers empty membership, first effective year, mixed eligibility, and missing taxpayer SSN. The full §24(d) entry point fails on a transitive dependency's `corpus_citation_paths` |
| EITC §32(c)(2) earned income | 3 cases before the §112 election and 2 on its branch: `eitc-earned-income.json`, `eitc-section112-election.json` | An IRS parameter dependency of §32 uses `corpus_citation_paths`, removed by the pinned engine |
| Selected SNAP FY 2024 net-income limit | 5 cases: `snap-net-income-limit.json` | The USDA FY 2026 deductions dependency of 7 CFR §273.10 contains unsupported `module.source_verification.values` |
| 26 USC §1211(b)(1) capital loss limit | 4 cases: `capital-loss-match.json`, checked on both Decimal and scale-6 | Two matches, no matching branch, and missing input; see `corpus-replay-1211.json` for separate published cases |

Component cases check outputs for pinned sources and dependencies. They do not measure full-corpus execution coverage or establish legal accuracy.

The corpus's own [known engine load failures](https://github.com/TheAxiomFoundation/rulespec-us/blob/d8a4c9cb560ed55c6db47ea36214249f67319461/tools/known-engine-load-failures.txt) list these failures for §24(d), §32, and 7 CFR §273.10. Its [workflow toolchain](https://github.com/TheAxiomFoundation/rulespec-us/blob/d8a4c9cb560ed55c6db47ea36214249f67319461/.axiom/workflow-toolchain.toml) uses engine commit `89571cc2a938707fd60a5489b951135345697296`. Switching to that engine alone does not resolve these failures; see the [candidate results](upstream-candidates.md).

Replay accepts published scalar and judgment cases bindable as single-entity requests, including tables with a matching entity type and no extra flat inputs. Each row is requested independently; a list of outputs passes only if every row passes. The targeted one-row table replay for 26 USC §3121(a)(1) passed 20 expectations (`corpus-replay-3121-a1.json`); §3121(v) passed 32 expectations and 40 row-level assertions (`corpus-replay-3121-v.json`). Multi-entity tables and unbound oracle context are excluded. YAML numeric expectations are compared numerically; Rust, Python, and Lean outputs are compared by tag and payload. Compilation failures, non-derived outputs, unsupported cases, and mismatches are tracked separately. The coverage denominator is published output expectations.

Among expectations not requested, 26,951 belonged to unavailable modules, 324 were outside the replay subset, and 473 did not correspond to derived outputs. The engine rejected six requests for missing formula versions. The 6,168 three-way passes account for 18.17% of the 33,954 published expectations. One-row table support added 626 passes, multi-row tables of a single entity type added 68, and missing parameter-table version support added 4. `corpus-replay.json` and `corpus-replay.log` retain individual results and the run summary, respectively.

`bash scripts/verify.sh upstream` uses `reports/v0.1/corpus/corpus-replay.json` as the baseline and writes the new report to `$EVIDENCE/corpus-replay.json` (default directory `.verification/upstream/`). It checks previous passes by case file, case index, and output name, and compares fixed-snapshot reports byte-for-byte. The regression check requires matching corpus, engine identity, and path scope; new passes cannot offset regressions. This baseline retained all 6,164 previous passes and reached 6,168.

Replay validates the entity, period, and output identity in Explain responses. A missing formula version counts as a known rejection only when the pinned engine returns the expected exit code and complete diagnostic; other nonzero exits and malformed responses fail the replay. Targeted runs for §3131(h), §1396a(xx), and §1396b(v) reproduced all six missing-version rejections.

A full run after strengthening Explain checks reproduced the 6,096-pass single-row-table baseline byte-for-byte. The latest counts come from a subsequent full replay including §3121(v) multi-row results.

Scale-6 now lowers parameter lookups with no active version at the snapshot date and preserves index fault precedence. The 26 USC §25D replay passed 19 expectations, four more in that module than the previous full report (`corpus-replay-25D.json`). Use `--prefix us/statutes/26/25D.yaml` to reproduce it. The §85 replay still passes three expectations; the other ten require `sum_related`.

### Upstream compatibility probes

#### Reviewable corpus patch and fixed baseline

Check [`corpus-compat.patch`](corpus-compat.patch) with `git apply --check` from the pinned corpus root. It touches four YAML files: the shared CTC/EITC parameter module cites IRS page 15 for compilation, two SNAP parameter modules retain citations while detaching the old `values` field, and `member_of_household` declares `[Person, Household]` as in the existing composition. The probe reports below preserve the detached information. Formulas, executable parameter tables, and published cases are unchanged.

| Full entry point | First unpatched compilation error | Patched derived outputs | Verified closure modules | Published expectations passed with patch |
| --- | --- | ---: | ---: | ---: |
| CTC §24(d) | Unsupported plural `corpus_citation_paths` | 71 | 11 | 4 |
| EITC §32 | Unsupported plural `corpus_citation_paths` | 61 | 10 | 2 |
| SNAP §273.10 | Unsupported `source_verification.values` | 17 | 4 | 33 |

[`corpus-patch-validation.json`](corpus-patch-validation.json) records the original diagnostics, patch and file hashes, actual artifact closures, and hashes of eight replay reports. The verifier patches a temporary copy and replays its artifacts directly. The three artifacts, eight replay reports, and eight Lean sources matched committed evidence byte-for-byte. The four CTC replays omit only the two out-of-closure inputs described below. The full fixed-corpus baseline is **6,168 / 33,954 (18.17%)**; the 39 patch results are counted separately.

CI uses the current run's fixed-corpus static audit, compares the patch report byte-for-byte, and uploads it. The temporary copy has no `.git` metadata so that checkouts and source exports follow the same procedure.

```sh
python -m experiments.check_corpus_patch --engine "$ENGINE" --corpus "$CORPUS" \
  --lake "$(command -v lake)" --report /tmp/opencode/corpus-patch-validation.json
cmp /tmp/opencode/corpus-patch-validation.json reports/v0.1/corpus/corpus-patch-validation.json
```

#### Diagnostics and replay by entry point

The FY 2026 parameter module shared by CTC §24(d) and EITC §32 originally cited pages 14 and 15. In [IRS Rev. Proc. 2025-32](https://www.irs.gov/pub/irs-drop/rp-25-32.pdf) §3.06, page 14 explains the tables' applicability and page 15 lists six sets of amounts and the investment income limit. The temporary migration uses page 15 as the sole compilation citation for seven parameters, checking each amount, start date, and proof citation against `page-15.yaml` in the pinned corpus. The report retains the page 14 context and original verification block with its legacy values. Both unmodified entry points reproduced the plural citation error. After migration they emitted 71 and 61 derived outputs; the probe verified 11 and 10 closure modules and their closure digests, and checked all seven values and page 15 citations in both artifacts. This experiment verifies the citation migration and compilation; full rule execution and independent legal review are separate.

To reproduce, run `python -m experiments.probe_corpus_compat --engine "$ENGINE" --corpus "$CORPUS" --eitc-report /tmp/opencode/eitc-citation-probe.json`. See [`eitc-citation-probe.json`](../legal/eitc-citation-probe.json). The source PDF's SHA-256 is `e9ada115fb43a4af5ea326ca91edd40ab0bf29b9be01d2c13d7b8fa96214635b`; use `pdftotext -f 14 -l 15 -layout` to inspect the pages.

A diagnostic experiment removed only the legacy `module.source_verification` blocks of three dependencies in a temporary corpus copy, retaining formulas, parameter tables, and dependency edges. The pinned engine compiled §24(d) and §32 into Artifact v3 files with 71 and 61 derived outputs, respectively. Section 273.10 still failed because `member_of_household` did not declare relation slot entity types. The probe checks pre- and post-edit hashes and the closure of each successful artifact. This metadata change isolates the blockers and is excluded from fixed-corpus and legal acceptance.

The published EITC §32 case `one_child_phase_in_and_allowed` queries the final `eitc` credit from the compatibility artifact with citations retained. The published expectation, Rust Explain, Python, and Lean all yield $3,400. The child is bound using the compiled `[TaxUnit, Person]` slot order, and evaluation encounters no unsupported nodes. The complete request, Explain response and trace, bound environment, and artifact source closure are in [`eitc-final-credit.json`](../legal/eitc-final-credit.json). This case is outside the fixed-corpus replay baseline.

```sh
python -m experiments.check_eitc_final --engine "$ENGINE" --corpus "$CORPUS" \
  --lake "$(command -v lake)" --report /tmp/opencode/eitc-final-credit.json \
  --lean /tmp/opencode/EITCFinalCreditTests.lean
```

The same §32 artifact was used for `investment_income_denies_credit`. The published expectation and all three runtimes yield $0. The trace confirms $13,000 in investment income exceeds the $12,200 limit; `eitc_investment_income_eligible` and `eitc_allowed` are both `not_holds`. Binding, evaluation, and translation encounter no unsupported nodes. See [`eitc-investment-income-denial.json`](../legal/eitc-investment-income-denial.json) for the request, response, and bound environment.

```sh
python -m experiments.check_eitc_final --case investment_income_denies_credit \
  --engine "$ENGINE" --corpus "$CORPUS" --lake "$(command -v lake)" \
  --report /tmp/opencode/eitc-investment-income-denial.json \
  --lean /tmp/opencode/EITCInvestmentIncomeDenialTests.lean
```

The published CTC §24(d) case `two_children_earned_income_phase_in_refundable_amount` replays `refundable_ctc` on a temporary artifact with citations retained. Rust rejects the original request during input validation: §164(f)'s `taxpayer_is_individual` and §1401's `filing_status` are outside the artifact's source closure and input catalog. Replay removes only these two inputs, leaving all other names and values intact. Rust Explain, Python, Lean, and the published expectation all yield $2,550, with no unsupported evaluation nodes. The [replay report](../legal/ctc-refundable-credit.json) retains the original request and rejection, omitted inputs, executed request and response, environment, and 11 closure modules.

```sh
python -m experiments.check_eitc_final --case two_children_earned_income_phase_in_refundable_amount \
  --engine "$ENGINE" --corpus "$CORPUS" --lake "$(command -v lake)" \
  --report /tmp/opencode/ctc-refundable-credit.json \
  --lean /tmp/opencode/CTCRefundableCreditTests.lean
```

The three-child case `three_children_social_security_excess_is_greater_than_earned_income_phase_in` yields $3,000 on the same artifact in Rust Explain, Python, Lean, and the published expectation. The Explain trace confirms a $0 earned income phase-in and $3,000 in excess social security taxes. The refundable limit increase is the greater of the two, $3,000. The first validation error in the original request is again §164(f)'s `taxpayer_is_individual`. Removing just the two out-of-closure inputs resolves it, with no binding or evaluation discrepancies. See [`ctc-social-security-excess.json`](../legal/ctc-social-security-excess.json).

```sh
python -m experiments.check_eitc_final \
  --case three_children_social_security_excess_is_greater_than_earned_income_phase_in \
  --engine "$ENGINE" --corpus "$CORPUS" --lake "$(command -v lake)" \
  --report /tmp/opencode/ctc-social-security-excess.json \
  --lean /tmp/opencode/CTCSocialSecurityExcessTests.lean
```

The other two published §24(d) final refundable credit expectations also passed three-way replay. The §112 trace shows a $5,000 earned income base and $300 phase-in, yielding a refundable credit of [$300](../legal/ctc-section112-refundable-credit.json). In the §911 case, foreign-income eligibility is `not_holds` and the final credit is [$0](../legal/ctc-section911-refundable-credit.json). This completes all four `refundable_ctc` expectations in the file; other published outputs are outside that count.

The second SNAP probe follows the declaration in the pinned `state-plan-composition.yaml` and adds `data_relation.arguments: [Person, Household]` to the temporary `us/statutes/7/2012/j.yaml`. Removing legacy metadata alone yields exit 1 with `[untyped_relation]`; adding the declaration yields exit 0 and an Artifact v3 with 17 derived outputs. Its `slot_entities` matches the declared order, and all four closure modules match their audit baseline or patched SHA-256 hashes. This probe checks compilation only.

To reproduce, install `PyYAML==6.0.3` and run `python -m experiments.probe_corpus_compat --engine "$ENGINE" --corpus "$CORPUS"` from the repository root. See [`corpus-compat-probe.log`](corpus-compat-probe.log). Add `--snap-report /tmp/opencode/snap-compat-probe.json` for the two-stage SNAP probe. Diagnostics, declaration provenance, hashes, and dependency closures are in [`snap-compat-probe.json`](../legal/snap-compat-probe.json) and [`snap-compat-probe.log`](../legal/snap-compat-probe.log).

The citation-preserving SNAP probe uses `--retain-source-verification`. It detaches only the unsupported `module.source_verification.values` fields from the two FY 2026 dependencies and retains the original YAML byte-for-byte and its SHA-256 in the report. Each module's `corpus_citation_path`, source declarations, rule proof metadata, and executable parameter tables are preserved. After the relation slot fix, the pinned engine emits 17 derived outputs. The probe verifies all four closure module hashes and checks that 32 compiled rules from the two dependencies retain the corresponding source paths. The engine does not read the detached legacy fields. Review of the legal text and meaning is separate.

The citation-preserving §273.10 artifact was used to replay two January 2026 published cases for the imported 7 USC §2012(j) household membership judgment. Rust Explain, Python, and Lean all return `holds` for one qualifying member and `not_holds` with no membership records. Python binds Person slot 0 members for Household slot 1, and Lean evaluates a filtered count and comparison in the generated Decimal snapshot. See [`snap-membership.json`](../legal/snap-membership.json) for requests, responses, and bindings. These membership judgments are outside the fixed-corpus replay baseline.

```sh
python -m experiments.check_snap_membership --retain-source-verification --engine "$ENGINE" --corpus "$CORPUS" \
  --lake "$(command -v lake)" --report /tmp/opencode/snap-membership.json \
  --lean /tmp/opencode/SNAPMembershipTests.lean
```

On the same temporary artifact, all five published §273.10 `snap_monthly_allotment` expectations matched Rust Explain, Python, and Lean numerically: $182, $270, $90, $24, and $0 in source order. See [`snap-allotment.json`](../legal/snap-allotment.json) for requests, full Explain responses, and bindings.

```sh
python -m experiments.check_snap_membership --retain-source-verification --allotment --engine "$ENGINE" --corpus "$CORPUS" \
  --lake "$(command -v lake)" --report /tmp/opencode/snap-allotment.json \
  --lean /tmp/opencode/SNAPAllotmentTests.lean
```

All 28 remaining expectations passed the same comparison: 21 derived outputs (including net income, deductions, and minimum benefits) and seven unindexed parameters (including deduction rates and issuance thresholds). The adapter maps the latter to key `0` lookups for the selected month and reuses Python and Lean parameter evaluation. Expected decimals are never converted to floating point. No additional unsupported dependencies or evaluation nodes were found. See [`snap-other-outputs.json`](../legal/snap-other-outputs.json) for individual results. All 33 expectations in the file passed; unpatched corpus admission and independent legal review remain separate acceptance criteria.

```sh
python -m experiments.check_snap_membership --retain-source-verification --other-outputs --engine "$ENGINE" --corpus "$CORPUS" \
  --lake "$(command -v lake)" --report /tmp/opencode/snap-other-outputs.json \
  --lean /tmp/opencode/SNAPPublishedOutputsTests.lean
```

To reproduce from the repository root:

```sh
python -m experiments.audit_corpus --engine /path/to/axiom-rules-engine \
  --corpus /path/to/rulespec-us --as-of 2025-01-01 --jobs 8 \
  --report /tmp/opencode/rulespec-static-recheck.json
python -m experiments.check_legal_components --engine /path/to/axiom-rules-engine \
  --corpus /path/to/rulespec-us --lake /path/to/lake \
  --audit /tmp/opencode/rulespec-static-recheck.json
python -m pip install PyYAML==6.0.3
lake build RuleSpecLean.Core
python -m experiments.replay_corpus --engine /path/to/axiom-rules-engine \
  --corpus /path/to/rulespec-us --lake /path/to/lake \
  --audit /tmp/opencode/rulespec-static-recheck.json \
  --baseline reports/v0.1/corpus/corpus-replay.json --report /tmp/opencode/rulespec-replay-recheck.json
```
