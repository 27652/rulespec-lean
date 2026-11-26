# RuleSpecLean

RuleSpecLean is a research prototype that translates a supported subset of Axiom RuleSpec Artifact v3 into Lean 4 expressions. It validates the translation with independent semantics, preservation proofs, and experiments against a pinned upstream engine. The input is an upstream-compiled artifact; `ctc-like` is a synthetic fixture. The project does not provide a complete legal rules runtime or an independent assessment of legal accuracy.

| Layer | Location |
| --- | --- |
| Translation and request binding | [`tools/`](tools/): Python translators, request binding, and reference interpreters |
| Formal semantics | [`RuleSpecLean/Semantics/`](RuleSpecLean/Semantics/): scale-6, Decimal, and version selection |
| Correctness proofs | [`RuleSpecLean/Proofs/`](RuleSpecLean/Proofs/): preservation theorems, §3403 correspondence, and axiom audit |
| Experiments | [`experiments/`](experiments/), [`tests/`](tests/), [`fixtures/`](fixtures/), and [`reports/v0.1/`](reports/v0.1/); retained generated modules and Lean assertions are in `RuleSpecLean/` |

**Two numeric paths.** Scale-6 uses exact fixed-point values with six decimal places and is the main path for scalar translation and preservation proofs. Decimal retains coefficients and scale, supports a wider range of decimal values, rounding, and selected request bindings, and is validated primarily through differential experiments. See the [usage guide](docs/usage.md) for the supported domains.

## Quick start

Install Python 3.12 and Lean 4.26.0 (pinned in [`lean-toolchain`](lean-toolchain)), then run from the repository root:

```sh
python3 -m tools.compile_ir fixtures/ctc-like.artifact.json \
  --as-of 2025-01-01 --output credit
bash scripts/verify.sh offline
```

See the [reproduction guide](docs/reproduction.md) for the pinned-engine experiments. The [roadmap](road.md) is the source of truth for current status, acceptance criteria, and blockers. For past changes, see the [development history](docs/history/).
