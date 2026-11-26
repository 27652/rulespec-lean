"""Compile a pinned federal RuleSpec tree and audit static scalar lowering."""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from os.path import abspath
from pathlib import Path
import shutil
import subprocess
import tempfile

from tools.compile_ir import Compiler, parse_date


def audit_module(engine, root, path, snapshot, scratch):
    relative = path.relative_to(root).as_posix()
    row = {"source": relative, "sha256": hashlib.sha256(path.read_bytes()).hexdigest()}
    if path.name.endswith(".test.yaml"):
        return {**row, "compile": "notApplicable", "kind": "testFixture"}
    with tempfile.TemporaryDirectory(dir=scratch) as directory:
        output = Path(directory) / "module.json"
        backend = "compile"
        command = [str(engine), backend, "--program", str(path),
                   "--rulespec-root", str(root), "--output", str(output)]
        try:
            result = subprocess.run(command, capture_output=True, text=True, timeout=60)
            # The locked engine distinguishes composition modules at admission.
            if result.returncode and "`composition` is accepted only by the composed-program surface" in result.stderr:
                backend = command[1] = "compile-composed"
                # Compositions must live outside all canonical import roots.
                staged = Path(directory) / path.name
                shutil.copyfile(path, staged)
                command[3] = str(staged)
                result = subprocess.run(command, capture_output=True, text=True, timeout=60)
        except subprocess.TimeoutExpired:
            return {**row, "compile": "timeout", "compiler": backend}
        if result.returncode:
            return {**row, "compile": "failed", "compiler": backend,
                    "diagnostic": result.stderr.strip().replace(str(Path(directory) / path.name),
                        f"<corpus>/{relative}").replace(str(root), "<corpus>")}
        artifact = json.loads(output.read_bytes())
        rules = []
        for rule in artifact["program"]["derived"]:
            name = rule["name"]
            try:
                compiler = Compiler(artifact, snapshot)
                compiler.compile([name])
            except (ValueError, KeyError, TypeError, RecursionError) as exc:
                rules.append({"name": name, "status": "blocked", "reason": str(exc)})
            else:
                missing = [key for key, details in compiler.selected.items() if details["missing_version"]]
                if missing:
                    rules.append({"name": name, "status": "loweredWithMissingVersion", "rules_without_version": missing})
                else:
                    rules.append({"name": name, "status": "lowered"})
        return {**row, "compile": "passed", "compiler": backend, "rules": rules}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True, type=Path)
    parser.add_argument("--corpus", required=True, type=Path)
    parser.add_argument("--as-of", default="2025-01-01", type=parse_date)
    parser.add_argument("--jobs", default=4, type=int)
    parser.add_argument("--scratch", type=Path)
    parser.add_argument("--report", default=Path("reports/v0.1/corpus/corpus-static.json"), type=Path)
    args = parser.parse_args()
    if args.jobs < 1:
        parser.error("--jobs must be positive")
    root, engine = Path(abspath(args.corpus)), args.engine.resolve()
    if root.name != "rulespec-us" or root.is_symlink() or not (root / "us").is_dir():
        parser.error("--corpus must be a real rulespec-us directory")
    pin = json.loads(Path("fixtures/legal-pin.json").read_text())
    engine_pin = json.loads(Path("fixtures/upstream-pin.json").read_text())
    capabilities = json.loads(subprocess.check_output([str(engine), "capabilities"], timeout=30))
    if capabilities["engine_build"] != {"commit": engine_pin["commit"], "dirty": False}:
        parser.error("clean pinned engine required")
    if hashlib.sha256((root / pin["source_path"]).read_bytes()).hexdigest() != pin["source_sha256"]:
        parser.error("retained statute checksum mismatch")
    paths = sorted(path for category in ("policies", "regulations", "statutes")
                   for path in (root / "us" / category).rglob("*.yaml") if path.is_file())
    if not paths:
        parser.error("no federal source files found")
    with ThreadPoolExecutor(max_workers=args.jobs) as pool:
        rows = list(pool.map(lambda path: audit_module(engine, root, path, args.as_of.isoformat(), args.scratch), paths))
    compiled = Counter(row["compile"] for row in rows)
    lowered = Counter(rule["status"] for row in rows for rule in row.get("rules", []))
    report = {"requested_corpus_pin": pin["commit"], "corpus_identity_check": "retained statute hash; individual source hashes below",
              "engine_build": capabilities["engine_build"], "snapshot": args.as_of.isoformat(),
              "scope": "YAML under us/{policies,regulations,statutes}; rule occurrences per compiled artifact",
              "source_files": len(rows), "compile_candidates": len(rows) - compiled["notApplicable"],
              "compile": dict(compiled), "lowering": dict(lowered),
              "execution_and_differential": "not measured in this audit", "results": rows}
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n")
    print(f"Corpus: {len(rows)} sources; compilation {dict(compiled)}; static lowering {dict(lowered)}")


if __name__ == "__main__":
    main()
