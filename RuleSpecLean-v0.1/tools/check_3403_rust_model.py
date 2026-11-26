"""Compare the pinned Rust CLI and Lean model at the §3403 version boundary."""

import argparse
from fractions import Fraction
import json
from pathlib import Path
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("engine", "lake", "report"):
        parser.add_argument(f"--{name}", required=True, type=Path)
    args = parser.parse_args()
    engine = args.engine.resolve()
    build = json.loads(subprocess.check_output([engine, "capabilities"], timeout=30))["engine_build"]
    pin = json.loads(Path("fixtures/upstream-pin.json").read_text())["commit"]
    if build != {"commit": pin, "dirty": False}:
        raise ValueError("clean pinned engine required")

    fixture = Path("fixtures/legal-3403.cases.json")
    template = json.loads(fixture.read_bytes())[0]["request"]
    output, = template["queries"][0]["outputs"]
    artifact = Path("fixtures/legal-3403.artifact.json")
    lines = ["import RuleSpecLean.Legal3403RustModel", "open RuleSpecLean RuleSpecLean.Legal3403Binding",
             "open RuleSpecLean.Legal3403Artifact RuleSpecLean.Legal3403RustModel"]
    results = []
    for year in (1989, 1990):
        for dollars in (-15, 0, 15):
            request = json.loads(json.dumps(template))
            interval = {"start": f"{year}-01-01", "end": f"{year + 1}-01-01"}
            request["queries"][0]["period"].update(interval)
            record, = request["dataset"]["inputs"]
            record["interval"] = interval
            record["value"]["value"] = str(dollars)
            run = subprocess.run([engine, "run-compiled", "--artifact", artifact], input=json.dumps(request),
                                 capture_output=True, text=True, timeout=30)
            row = {"request": request, "exit_code": run.returncode}
            if year == 1989:
                diagnostic = "derived `employer_liability_for_chapter_withholding_tax_payment` has no formula version at 1989-01-01"
                if (run.returncode, run.stderr.strip(), run.stdout.strip()) != (1, diagnostic, ""):
                    raise ValueError(f"unexpected pre-effective result: {run}")
                row["diagnostic"] = diagnostic
                pattern, comparison = ".error .missingVersion", "true"
            else:
                run.check_returncode()
                response = json.loads(run.stdout)
                if run.stderr or response["metadata"]["actual_mode"] != "explain":
                    raise ValueError(f"unexpected Explain metadata or diagnostic: {run}")
                result, = response["results"]
                value = result["outputs"][output]["value"]
                expected = max(0, dollars)
                if value["kind"] != "decimal" or Fraction(value["value"]) != expected:
                    raise ValueError(f"unexpected withholding value: {value}")
                row["response"] = response
                pattern, comparison = ".ok (.decimal coefficient)", f"coefficient == {expected} * scale"
            model_request = f'(⟨"employer:1", {year}, ({dollars})⟩ : AnnualRequest)'
            wire = json.dumps(json.dumps(request, separators=(",", ":")))
            expressions = (f"evalRustModel {model_request}",
                           f"((Lean.Json.parse {wire}) >>= evalWireRequest retainedArtifact)")
            for expression, match_pattern in zip(expressions, (pattern, f".ok ({pattern})"), strict=True):
                lines += [f"#guard (match {expression} with", f"  | {match_pattern} => {comparison}",
                          "  | _ => false)"]
            results.append(row)

    lake = args.lake.resolve()
    subprocess.run([lake, "build", "RuleSpecLean.Legal3403RustModel"], check=True, timeout=120)
    with tempfile.TemporaryDirectory(prefix="rulespec-3403-boundary-") as work:
        source = Path(work) / "Check.lean"
        source.write_text("\n".join(lines) + "\n")
        subprocess.run([lake, "env", "lean", source], check=True, timeout=60)
    args.report.write_text(json.dumps({"engine_build": build, "lean_guards_passed": len(results) * 2,
                                       "results": results}, indent=2) + "\n")
    print(f"§3403 version boundary: {len(results)} Rust requests; {len(results) * 2} Lean guards passed")


if __name__ == "__main__":
    main()
