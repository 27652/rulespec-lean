# Reproducing the research baseline

Run these commands from the repository root. Fresh results are stored separately from the retained evidence. The verification script regenerates upstream fixtures and Lean assertions in a temporary copy of the project.

## Offline verification

Use Python 3.12 and Lean 4.26.0 (`lean-toolchain`). The Rust engine and corpus are not needed.

```sh
bash scripts/verify.sh offline
```

The entry point runs Python unit and offline regression tests, checks deterministic generation, builds the Lean verification modules, and runs the axiom audit. Offline replays and mocked tests do not count as fresh engine runs.

## Pinned-engine experiments

The engine and corpus repositories and commits are recorded in [`upstream-pin.json`](../fixtures/upstream-pin.json) and [`legal-pin.json`](../fixtures/legal-pin.json). Name the corpus checkout `rulespec-us`. Install Rust 1.98.1 and build the engine and numeric oracle using their respective `Cargo.lock` files. If you download Lean from a mirror, verify it against the official SHA-256.

```sh
export ENGINE_SOURCE=/path/to/axiom-rules-engine
export CORPUS=/path/to/rulespec-us
export ENGINE="$ENGINE_SOURCE/target/debug/axiom-rules-engine"
export ORACLE="$PWD/experiments/decimal_oracle/target/debug/rulespec-decimal-oracle"
export RUSTC="$(rustup which --toolchain 1.98.1 rustc)"
(cd "$ENGINE_SOURCE" && cargo +1.98.1 build --locked --bin axiom-rules-engine)
cargo +1.98.1 build --locked --manifest-path experiments/decimal_oracle/Cargo.toml
python3 -m pip install -r experiments/requirements.txt
bash scripts/verify.sh upstream
```

Set `PYTHON` and `LAKE` to override the executable paths. `EVIDENCE` sets the output directory (default `.verification/upstream/`); use a separate directory for each run. This entry point runs the three-way engine comparisons, pinned Rust source comparisons, axiom audit, fixed-corpus static scan and replay, and a separate compatibility-patch experiment. CI calls the same entry point and uploads the results. The [evidence index](../reports/v0.1/README.md) describes the scope of each result.
