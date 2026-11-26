# Upstream candidate screening

`git ls-remote` reported that the default engine branch matched the existing pin [`a4322e45a035ba9fd412d01bebe078aeaa46cd54`](https://github.com/TheAxiomFoundation/axiom-rules-engine/commit/a4322e45a035ba9fd412d01bebe078aeaa46cd54), and that the corpus candidate was [`a5c5716ad45c477cf1587f371cc16f6a6f1a5c67`](https://github.com/TheAxiomFoundation/rulespec-us/commit/a5c5716ad45c477cf1587f371cc16f6a6f1a5c67). The GitHub Git Trees API returned the following root tree entries for the [baseline](https://api.github.com/repos/TheAxiomFoundation/rulespec-us/git/trees/d8a4c9cb560ed55c6db47ea36214249f67319461) and [candidate](https://api.github.com/repos/TheAxiomFoundation/rulespec-us/git/trees/a5c5716ad45c477cf1587f371cc16f6a6f1a5c67):

| Path | Baseline tree object | Candidate tree object |
| --- | --- | --- |
| `us/` | `2a17f6042ff5fc3d8219db01ad71b3acf5170ad8` | `2a17f6042ff5fc3d8219db01ad71b3acf5170ad8` |
| `.axiom/` | `3e48490c26eb767f3cfe1baa0579da41a0880cde` | `e00d86a3afe6c7dde5167c768ba2ffa15c6ab1e4` |

Both corpus commits set `axiom_rules_engine_ref` to `89571cc2a938707fd60a5489b951135345697296` and `axiom_artifact_rules_engine_ref` to `98af0dcec5a09e1dca12d1458e08ccb02516c1ef`. The candidate came from GitHub's source archive for that commit (SHA-256 `06a38b62d8c2fef927d5e1db08490a906d96295933f9095368d9cf713af6aed8`).

## Unpatched compilation results

| Engine and corpus | CTC §24(d) | EITC §32 | SNAP §273.10 |
| --- | --- | --- | --- |
| Pinned engine `a4322e4` + candidate corpus `a5c5716` | Exit 1: `corpus_citation_paths` | Exit 1: `corpus_citation_paths` | Exit 1: `module.source_verification: unknown field values` |
| Workflow engine `89571cc` (0.2.2) + fixed corpus `d8a4c9c` | Exit 1: `corpus_citation_paths` | Exit 1: `corpus_citation_paths` | Exit 1: `module.source_verification: unknown field values` |
| Artifact workflow engine `98af0dc` (0.1.2) + fixed corpus `d8a4c9c` | Exit 0: v2, 71 derived outputs | Exit 0: v2, 61 derived outputs | Exit 0: v2, 17 derived outputs |

Both workflow engines were built from GitHub commit archives using `cargo build --locked --bin axiom-rules-engine`. Version 0.2.2 and the pinned engine used `compile --program "$CORPUS/$entry" --rulespec-root "$CORPUS" --output "$output"`. Version 0.1.2 used `AXIOM_RULESPEC_REPO_ROOTS="$CORPUS" "$ENGINE" compile --program "$CORPUS/$entry" --output "$output"`; its CLI does not accept `--rulespec-root` or provide `capabilities` or `explain`.

SHA-256 of the v2 artifacts from 0.1.2: CTC `b103ef7e7d5f1b2760c819dba2434ac39085a4d9941267f6d8be6748e1b43589`; EITC `2e809a0e4974e543a3041c0c8637bc0e77e62d6db03e134bd7cd2a7e2c1b769f`; SNAP `bba7aed3827ac985116c5282f177dc54b1266131215b56b1c20eab49ecd82173`. Both translators rejected all three v2 artifacts in testing (`only artifact format 3` / `artifact v3 required`). The older engine was not used to replay the 39 published expectations or check full-corpus regressions, so the pins remain unchanged.
