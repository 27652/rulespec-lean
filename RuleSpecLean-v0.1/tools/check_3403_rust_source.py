"""Run hash-pinned Rust function bodies on singleton binding and version cases."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path
import subprocess
import tempfile


SOURCE_HASHES = {
    "engine.rs": "77dadaab5955f1608791a2af964430e0ad833be041c3fb05200c6ff28c3fd279",
    "model.rs": "407ec64a9c1aa73d30e244cdeb40efe4bb82eb31f9cf61076991af5e577ce753",
}


def method(source, signature):
    start = source.index(f"    {signature}(")
    end = source.index("\n    }", start) + len("\n    }")
    return source[start:end]


def check(args, work):
    sources = {}
    for name, expected in SOURCE_HASHES.items():
        raw = (args.source / "src" / name).read_bytes()
        if hashlib.sha256(raw).hexdigest() != expected:
            raise ValueError(f"source hash mismatch: {name}")
        sources[name] = raw.decode()
    engine, model = sources["engine.rs"], sources["model.rs"]
    # Only container types and already-decoded scalar values are supplied here.
    rust = ["""
use std::collections::HashMap;
type NaiveDate = i64;
type ScalarValue = i64;
#[derive(Debug)]
enum EvalError {
    MissingInput { name: String, entity_id: String, period_start: i64, period_end: i64 },
    AmbiguousInput { name: String, entity_id: String, effective_from: i64, other_name: Option<String> },
}
struct Period { start: i64, end: i64 }
struct Interval { start: i64, end: i64 }
mod model {
    pub(super) struct InputRecord {
        pub(super) name: String, pub(super) entity_id: String,
        pub(super) interval: super::Interval, pub(super) value: super::ScalarValue,
    }
}
struct DataSet { inputs: Vec<model::InputRecord> }
struct Engine<'a> { input_index: HashMap<(String, String), Vec<&'a model::InputRecord>> }
struct DerivedVersion { effective_from: i64, effective_to: Option<i64>, semantics: i64 }
type DerivedSemantics = i64;
struct Derived { versions: Vec<DerivedVersion>, semantics: i64 }
"""]
    index = engine[engine.index("        let mut input_index:"):engine.index("        let mut relation_index:")]
    rust += ["impl Interval {", method(model, "pub fn contains_period"), "}",
             "impl DerivedVersion {", method(model, "pub fn applies_at"), "}",
             "impl Derived {", method(model, "pub fn semantics_at"), method(model, "pub fn version_at"), "}",
             "impl<'a> Engine<'a> {", method(engine, "fn lookup_input"), "}",
             "fn build_index<'a>(data: &'a DataSet) -> Engine<'a> {", index, "Engine { input_index }", "}", "fn main() {"]

    lean = ["import RuleSpecLean.Legal3403RustSource", "open RuleSpecLean.Legal3403RustSource"]
    cases = []
    # Each key comparison and each interval endpoint independently takes all
    # relevant order classes about the fixed query [10, 20].
    for slot, employer, start, end in itertools.product(("slot", "other"), ("employer", "other"),
                                                          (9, 10, 11), (19, 20, 21)):
        s, e = json.dumps(slot), json.dumps(employer)
        rust += [f"let data = DataSet {{ inputs: vec![model::InputRecord {{ name: {s}.into(), entity_id: {e}.into(),",
                 f"interval: Interval {{ start: {start}, end: {end} }}, value: -15 }}] }};",
                 'match build_index(&data).lookup_input("slot", "employer", &Period { start: 10, end: 20 }) {',
                 'Ok(value) => println!("{value}"), Err(EvalError::MissingInput { .. }) => println!("none"),',
                 'Err(other) => panic!("unexpected singleton lookup error: {other:?}"), }']
        cases.append(({"kind": "input", "slot": slot, "employer": employer, "start": start, "end": end},
                      f'inputBody ⟨{s}, {e}, {start}, {end}, -15⟩ "slot" "employer" 10 20'))
    for start, end in itertools.product((9, 10, 11), (None, 9, 10, 11)):
        if end is not None and start > end:
            continue
        rust_end = "None" if end is None else f"Some({end})"
        lean_end = "none" if end is None else f"(some {end})"
        rust += [f"let derived = Derived {{ versions: vec![DerivedVersion {{ effective_from: {start},",
                 f"effective_to: {rust_end}, semantics: 42 }}], semantics: -1 }};",
                 'match derived.semantics_at(&Period { start: 10, end: 20 }) {',
                 'Some(value) => println!("{value}"), None => println!("none"), }']
        cases.append(({"kind": "version", "start": start, "end": end},
                      f"(versionBody 10 (⟨{start}, {lean_end}, (42 : Int)⟩ : RuleSpecLean.VersionSelection.Version Int)).map (fun row => row.2.body)"))
    rust.append("}")
    source = work / "check.rs"
    source.write_text("\n".join(rust) + "\n")
    exe = work / "check"
    subprocess.run([args.rustc, "--edition=2024", "-A", "dead_code", source, "-o", exe], check=True, timeout=60)
    actual = subprocess.check_output([exe], text=True, timeout=30).splitlines()
    results = []
    for (case, expression), value in zip(cases, actual, strict=True):
        expected = "none" if value == "none" else f"some ({int(value)})"
        lean.append(f"#guard ({expression}) == {expected}")
        results.append({**case, "rust_result": None if value == "none" else int(value)})
    guards = work / "Check.lean"
    guards.write_text("\n".join(lean) + "\n")
    lake = args.lake.resolve()
    subprocess.run([lake, "build", "RuleSpecLean.ProofAudit"], check=True, timeout=120)
    subprocess.run([lake, "env", "lean", guards], check=True, timeout=60)
    return results


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("source", "lake", "report"):
        parser.add_argument(f"--{name}", required=True, type=Path)
    parser.add_argument("--rustc", default="rustc")
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix="rulespec-3403-source-") as work:
        results = check(args, Path(work))
    args.report.write_text(json.dumps({"source_sha256": SOURCE_HASHES, "results": results}, indent=2) + "\n")
    print(f"§3403: {len(results)} extracted Rust source results matched Lean guards")


if __name__ == "__main__":
    main()
