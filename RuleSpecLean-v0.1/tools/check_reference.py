"""Compare explicitly prebound scalar cases with the official Explain CLI.

This is deliberately not a general dataset/entity/period binding adapter.
Each case supplies both an official request and the matching prebound env.
Generated Lean guards must also be compiled before claiming three-way parity.
"""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

from tools.compile_ir import Compiler, emit, lean_str, lean_value, parse_value, run
from tools.request_binding import check_env


def check(artifact_path, cases, engine, lean_path):
    if not isinstance(cases, list) or not cases:
        raise ValueError("cases must be a nonempty list")
    names = [case["name"] for case in cases]
    if len(set(names)) != len(names):
        raise ValueError("case names must be unique")
    raw = artifact_path.read_bytes()
    artifact = json.loads(raw)
    module = lean_path.stem
    if not module.isidentifier():
        raise ValueError("invalid Lean module name")
    guards = [f"import RuleSpecLean.{module}", "", "open RuleSpecLean", ""]
    rows = []
    # Cases deliberately share a snapshot/output; reject accidental mixing.
    first = cases[0]
    compiler = Compiler(artifact, first["as_of"])
    compiler.compile([first["rule"]])
    public_id = compiler.rules[first["rule"]].get("id")
    if public_id is not None and public_id != first["public_output"]:
        raise ValueError("public_output does not identify the compiled rule")
    source, _ = emit(compiler, [first["rule"]])
    lean_path.parent.mkdir(parents=True, exist_ok=True)
    lean_path.write_text(source, encoding="utf-8")
    for case in cases:
        if (case["as_of"], case["rule"]) != (first["as_of"], first["rule"]):
            raise ValueError("all cases must share as_of and rule")
        if case["public_output"] != first["public_output"]:
            raise ValueError("all cases must share public_output")
        request = case["request"]
        if request.get("mode") != "explain" or len(request["queries"]) != 1:
            raise ValueError("exactly one Explain query required")
        query = request["queries"][0]
        if query.get("outputs") != [case["public_output"]]:
            raise ValueError("query must request exactly public_output")
        if query["period"]["start"] != case["as_of"]:
            raise ValueError("snapshot must equal query period start")
        if "metadata" in artifact and "input_catalog" in artifact["metadata"]:
            check_env(artifact, case)
        result = subprocess.run([str(engine), "run-compiled", "--artifact", str(artifact_path)],
                                input=json.dumps(request), capture_output=True,
                                text=True, timeout=60)
        if result.returncode:
            raise ValueError(f"{case['name']}: official CLI failed: {result.stderr.strip()}")
        response = json.loads(result.stdout)
        if response["metadata"]["actual_mode"] != "explain":
            raise ValueError("reference did not execute Explain")
        if len(response["results"]) != 1:
            raise ValueError("reference must return exactly one result")
        outputs = response["results"][0]["outputs"]
        if set(outputs) != {case["public_output"]}:
            raise ValueError("reference output keys do not match query")
        output = outputs[case["public_output"]]
        if output["kind"] != "scalar":
            raise ValueError("this harness currently checks scalar results only")
        expected = parse_value(output["value"])
        actual = run(compiler.normal[case["rule"]], case["env"], compiler.normal)
        if actual != expected:
            raise ValueError(f"{case['name']}: Python {actual} != Rust {expected}")
        env = ", ".join(f"({lean_str(k)}, {lean_value(parse_value(v))})"
                        for k, v in sorted(case["env"].items()))
        guards.append(f"#guard sameResult (eval [{env}] Generated.output_0) (.ok {lean_value(expected)})")
        rows.append({"name": case["name"], "result": list(expected), "status": "matched"})
    guard_path = lean_path.with_name(f"{module}Tests.lean")
    guard_path.write_text("\n".join(guards) + "\n", encoding="utf-8")
    return {"artifact_sha256": hashlib.sha256(raw).hexdigest(),
            "engine_build": artifact.get("engine_build"),
            "cases": len(rows), "python_rust": "passed",
            "lean": "pending: compile RuleSpecLean.ReferenceTests", "results": rows}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("artifact", type=Path)
    parser.add_argument("cases", type=Path)
    parser.add_argument("--engine", required=True, type=Path)
    parser.add_argument("--report", type=Path, default=Path("reports/reference.json"))
    parser.add_argument("--lake", type=Path,
                        help="Also compile generated Lean guards with this Lake binary")
    parser.add_argument("--lean", type=Path, default=Path("RuleSpecLean/Reference.lean"))
    args = parser.parse_args()
    cases = json.loads(args.cases.read_text())
    if not isinstance(cases, list) or not cases:
        parser.error("cases must be a nonempty list")
    report = check(args.artifact.resolve(), cases, args.engine.resolve(),
                   args.lean)
    if args.lake:
        test_module = f"RuleSpecLean.{args.lean.stem}Tests"
        built = subprocess.run([str(args.lake.resolve()), "build", test_module],
                               capture_output=True, text=True, timeout=300)
        if built.returncode:
            raise ValueError(f"Lean build failed:\n{built.stdout}\n{built.stderr}")
        report["lean"] = f"passed: lake build {test_module}"
        report["lean_build_log"] = built.stdout + built.stderr
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(f"Rust/Python: {report['cases']} matched; Lean: {report['lean']}")


if __name__ == "__main__":
    main()
