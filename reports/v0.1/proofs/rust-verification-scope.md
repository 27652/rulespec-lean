# §3403 Rust source verification: tools and scope

This is a preliminary assessment of source paths and tools. The pinned engine is `a4322e45a035ba9fd412d01bebe078aeaa46cd54`; source locations and hashes are in the [executed differential report](legal-3403-rust-source.json). No Charon, Aeneas, Kani, or Verus executable was available locally, so there are no translation or proof results from those tools yet.

| Source entry point | Behavior and dependencies to verify |
| --- | --- |
| `Derived::semantics_at` and `Derived::version_at` in `model.rs` | An empty version list uses default semantics; otherwise selection uses the query's `period.start`. The general case must prove that the iterator picks the greatest applicable start date and the last item on ties. Start with a single version using the actual function bodies. State any specification assumed for `chrono::NaiveDate` ordering explicitly. |
| `Engine::lookup_input` in `engine.rs` | The `(slot name, entity ID)` index, period coverage, conflicts on the same start date, and the returned value or fault. Start with one record and assume correct index construction, then prove that `Engine::new` establishes it. The general case also depends on `HashMap`, iterators, value comparison, and cloning `ScalarValue`. |

[Charon and Aeneas](https://github.com/AeneasVerif/aeneas) translate Rust MIR into definitions usable in Lean and are the first candidates for connecting Rust to the existing preservation theorem. Pin Aeneas, its `charon-pin`, and the toolchain; record the output and dependency models. If translation requires replacing dates or containers in an extraction, distinguish what is proved about the extraction from assumptions about production types. [Kani](https://github.com/model-checking/kani) is a candidate for bounded checks on the original Rust. Report input and unwind bounds separately; bounded checking does not produce a Lean correspondence theorem.

The first acceptance target is to mechanically extract or translate the actual version selection function from the pinned source, prove correspondence with `versionBody` for a single version and decoded dates, and include the theorem in the axiom audit. The existing 36 lookup and 9 selection comparisons offer regression checks. The current Lean theorem covers a manual transcription. See the [roadmap](../../../road.md) for acceptance status.
