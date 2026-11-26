"""Differential checks for a small, explicit subset of official CLI faults.

CLI diagnostics are not a structured API. Match complete, anchored diagnostic
shapes from the pinned engine; do not map arbitrary subprocess failures to Fault.
"""
import argparse
import json
from pathlib import Path
import re
import subprocess

from tools.compile_ir import Compiler, EvalFault, emit, lean_str, lean_value, parse_value, run
from tools.request_binding import check_env


PATTERNS = {
    "missingInput": r"missing input `[^`]+` for entity `[^`]+` over \d{4}-\d{2}-\d{2}\.\.\d{4}-\d{2}-\d{2}",
    "divisionByZero": r"division by zero",
    "typeMismatch": r"type mismatch: [^\n]+",
    "missingVersion": r"derived `[^`]+` has no formula version at \d{4}-\d{2}-\d{2}",
    "missingParameter": r"parameter `[^`]+` has no value for key `-?\d+` at \d{4}-\d{2}-\d{2}",
}


def classify(stderr):
    matches = [fault for fault, pattern in PATTERNS.items()
               if re.fullmatch(pattern, stderr.strip())]
    if len(matches) != 1:
        raise ValueError(f"unrecognized official diagnostic: {stderr.strip()}")
    return matches[0]


def check(artifact_path, cases, engine, target):
    artifact = json.loads(artifact_path.read_text())
    if not cases or len({c["name"] for c in cases}) != len(cases):
        raise ValueError("nonempty uniquely named cases required")
    lines = ["import RuleSpecLean.Core", "", "open RuleSpecLean", ""]
    rows = []
    for i, case in enumerate(cases):
        request = case["request"]
        query, = request["queries"]
        if request["mode"] != "explain" or query["period"]["start"] != case["as_of"]:
            raise ValueError("Explain snapshot mismatch")
        compiler = Compiler(artifact, case["as_of"])
        compiler.compile([case["rule"]])
        if query["outputs"] != [compiler.rules[case["rule"]]["id"]]:
            raise ValueError("output identity mismatch")
        check_env(artifact, case)
        result = subprocess.run([str(engine), "run-compiled", "--artifact", str(artifact_path)],
                                input=json.dumps(request), text=True,
                                capture_output=True, timeout=60)
        if result.returncode != 1 or result.stdout.strip():
            raise ValueError(f"expected evaluation failure: {case['name']}")
        fault = classify(result.stderr)
        if fault != case["fault"]:
            raise ValueError(f"unexpected Rust fault: {fault}")
        if "diagnostic" in case and result.stderr.strip() != case["diagnostic"]:
            raise ValueError(f"unexpected Rust diagnostic: {result.stderr.strip()}")
        try:
            run(compiler.normal[case["rule"]], case["env"], compiler.normal)
        except EvalFault as exc:
            if str(exc) != fault:
                raise ValueError(f"Python fault {exc} != Rust {fault}") from exc
        else:
            raise ValueError("Python unexpectedly succeeded")
        source, _ = emit(compiler, [case["rule"]])
        # Each case has a separate namespace, allowing distinct snapshots/rules.
        source = source.replace("import RuleSpecLean.Core\n", "", 1)
        source = source.replace("RuleSpecLean.Generated", f"FaultCase{i}")
        lines.append(source)
        env = ", ".join(f"({lean_str(k)}, {lean_value(parse_value(v))})"
                        for k, v in sorted(case["env"].items()))
        lines.append(f"#guard sameResult (eval [{env}] FaultCase{i}.output_0) (.error .{fault})")
        rows.append({"name": case["name"], "fault": fault,
                     "official_diagnostic": result.stderr.strip()})
    target.write_text("\n".join(lines) + "\n")
    return {"engine_build": artifact["engine_build"], "cases": len(rows),
            "python_rust": "passed", "lean": "pending", "results": rows}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("artifact", type=Path)
    parser.add_argument("cases", type=Path)
    parser.add_argument("--engine", required=True, type=Path)
    parser.add_argument("--lake", type=Path)
    args = parser.parse_args()
    engine = args.engine.resolve()
    pin = json.loads(Path("fixtures/upstream-pin.json").read_text())
    expected_build = {"commit": pin["commit"], "dirty": False}
    capabilities = json.loads(subprocess.check_output([str(engine), "capabilities"], text=True, timeout=30))
    if (capabilities["engine_build"] != expected_build or
            json.loads(args.artifact.read_bytes())["engine_build"] != expected_build):
        parser.error("fault checks require the pinned engine and a matching artifact")
    report = check(args.artifact.resolve(), json.loads(args.cases.read_text()),
                   engine, Path("RuleSpecLean/FaultTests.lean"))
    if args.lake:
        subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.FaultTests"],
                       check=True, timeout=300)
        report["lean"] = "passed: lake build RuleSpecLean.FaultTests"
    Path("reports/v0.1/interop/faults.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"Fault comparisons: {report['cases']}; Lean: {report['lean']}")


if __name__ == "__main__":
    main()
