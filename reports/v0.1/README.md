# v0.1 research baseline evidence

The `archive/pre-research-layout` tag preserves the original layout and reports. This directory groups retained evidence by experiment. See the [reproduction guide](../../docs/reproduction.md) for commands and the [roadmap](../../road.md) for current acceptance status.

| Directory | Contents |
| --- | --- |
| [`interop/`](interop/) | Three-way comparisons for the synthetic flat-tax rule, the real §3403 scalar output, and evaluation faults |
| [`decimal/`](decimal/) | [Comparison contract](decimal/decimal-semantics.md), rounding, arithmetic, and rule-level Decimal comparisons |
| [`binding/`](binding/) | Selected-year reads, defaults, and direct relation aggregation |
| [`legal/`](legal/) | Published cases and diagnostics for selected legal components and compatibility artifacts |
| [`corpus/`](corpus/) | [Fixed-corpus scan and replay](corpus/corpus-validation.md), compatibility patch validation, and [upstream candidate screening](corpus/upstream-candidates.md) |
| [`proofs/`](proofs/) | Axiom audit, §3403 effective date boundaries, extracted Rust function comparisons, and [source verification tool assessment](proofs/rust-verification-scope.md) |
| [`logs/`](logs/) | Historical run logs retaining the original paths and output |

Compilation, static translation, published output replay, and compatibility patch experiments use separate denominators. Three-way comparisons check execution results, and the axiom audit checks Lean theorem dependencies. Independent legal review is a separate task.
