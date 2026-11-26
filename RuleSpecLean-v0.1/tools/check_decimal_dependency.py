"""Check generated Decimal evaluation against the official Explain engine."""
import argparse
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import subprocess

from tools.decimal_model import DecimalFault, DecimalValue, snapshot_literal
from tools.decimal_runtime import NumericRuntime
from tools.compile_decimal import DecimalCompiler
from tools.request_binding import check_env


def check_case(artifact, program, case, engine, namespace):
    rule, env, as_of = (case[key] for key in ("rule", "env", "as_of"))
    request = case["request"]
    check_env(program, case, validate_value=snapshot_literal, covering=case.get("covering", False),
              relation_counts=case.get("relation_counts", False), filtered_counts=case.get("filtered_counts", False))
    query = request["queries"][0]
    if as_of != query["period"]["start"]:
        raise ValueError("snapshot must equal query period start")
    output = query["outputs"][0]
    process = subprocess.run([str(engine), "run-compiled",
        "--artifact", str(artifact.resolve())], input=json.dumps(request), text=True,
        capture_output=True, timeout=60)
    judgment = case.get("judgment", False)
    evaluator = "evalPredicate" if judgment else "eval"
    source = DecimalCompiler(program, as_of, env, allow_missing=True).emit(rule, namespace, judgment=judgment)
    blocks = [source.removeprefix("import RuleSpecLean.Decimal\n")]
    runtime = NumericRuntime(program, as_of)
    if "fault" in case:
        diagnostic = process.stderr.strip()
        if process.returncode != 1 or process.stdout.strip() or diagnostic != case["diagnostic"]:
            raise ValueError(f"expected specific Explain failure for {rule}, env {env}: {diagnostic}")
        fault = case["fault"]
        try:
            (runtime.judgment if judgment else runtime.rule)(rule, env)
        except DecimalFault as exc:
            if str(exc) != fault:
                raise ValueError(f"Python fault {exc} != Rust fault {fault}") from exc
        else:
            raise ValueError(f"Python unexpectedly succeeded for {rule}, env {env}")
        blocks.append(f"#guard match {evaluator} {namespace}.output with\n"
                      f"  | .error fault => fault == .{fault}\n"
                      "  | .ok _ => false")
        return {"fault": fault, "official_diagnostic": diagnostic}, blocks
    process.check_returncode()
    response = json.loads(process.stdout)
    if response["metadata"]["actual_mode"] != "explain":
        raise ValueError("official engine did not use Explain")
    results = response["results"]
    if len(results) != 1 or set(results[0]["outputs"]) != {output}:
        raise ValueError(f"unexpected Explain results for {rule}, env {env}")
    result = results[0]["outputs"][output]
    if judgment:
        if result["kind"] != "judgment" or result["outcome"] not in {"holds", "not_holds"}:
            raise ValueError(f"expected determinate judgment for {rule}, env {env}: {result}")
        expected = result["outcome"] == "holds"
        if runtime.judgment(rule, env) != expected:
            raise ValueError(f"judgment mismatch for {rule}, env {env}")
        blocks.append(f"#guard match evalPredicate {namespace}.output with\n"
                      f"  | .ok value => value == {str(expected).lower()}\n"
                      "  | .error _ => false")
        return {"outcome": result["outcome"]}, blocks
    if result["kind"] != "scalar" or result["value"]["kind"] not in {"integer", "decimal"}:
        raise ValueError(f"expected numeric scalar output for {rule}, env {env}")
    expected = DecimalValue.from_literal(result["value"])
    actual = runtime.rule(rule, env)
    if Fraction(actual.coefficient, 10**actual.scale) != Fraction(expected.coefficient, 10**expected.scale):
        raise ValueError(f"{rule}, env {env}: Python {actual} != Rust {expected}")
    guard = (f"#guard match eval {namespace}.output with\n"
             f"  | .ok result => equalValue result ⟨({expected.coefficient}), {expected.scale}⟩\n"
             "  | .error _ => false")
    return {"output": str(expected), "official_value": result["value"]["value"]}, [*blocks, guard]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True, type=Path)
    parser.add_argument("--lake", required=True, type=Path)
    parser.add_argument("--flat-tax", action="store_true", help="Check the upstream flat-tax fixture instead")
    args = parser.parse_args()
    if args.flat_tax:
        artifact = Path("fixtures/upstream-flat-tax.artifact.json")
        raw = artifact.read_bytes()
        program = json.loads(raw)
        cases_path = Path("fixtures/upstream-flat-tax.cases.json")
        cases_raw = cases_path.read_bytes()
        cases = json.loads(cases_raw)
        if not cases:
            raise ValueError("flat-tax cases must not be empty")
        lines = ["import RuleSpecLean.Decimal", "", "open RuleSpecLean.DecimalModel", ""]
        rows = []
        for index, case in enumerate(cases):
            output, blocks = check_case(artifact, program, case, args.engine.resolve(), f"FlatTaxCase{index}")
            lines.extend(blocks)
            rows.append({"name": case["name"], **output})
        Path("RuleSpecLean/DecimalFlatTaxTests.lean").write_text("\n".join(lines) + "\n")
        subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.DecimalFlatTaxTests"],
                       check=True, timeout=300)
        Path("reports/decimal-flat-tax.json").write_text(json.dumps({
            "cases": len(rows), "artifact_sha256": hashlib.sha256(raw).hexdigest(),
            "cases_sha256": hashlib.sha256(cases_raw).hexdigest(), "engine_build": program["engine_build"],
            "comparison": "numeric value", "status": "Rust/Python/Lean passed", "results": rows,
        }, indent=2) + "\n")
        print(f"Decimal flat tax: {len(rows)} three-way checks passed")
        return
    artifact = Path("fixtures/decimal-dependency.artifact.json")
    program = json.loads(artifact.read_text())
    lines = ["import RuleSpecLean.Decimal", "", "open RuleSpecLean.DecimalModel", ""]
    rows = []
    cases = [(mode, "doubled" if mode == "half_up" else f"doubled_{mode}", text)
             for mode in ("half_up", "half_even", "floor", "ceil")
             for text in ("1.005", "-1.005", "1.004", "1.015", "0.005", "-0.005")]
    cases.extend((None, "bounded_whole_amount", text)
                 for text in ("-3.25", "-2", "-1.0000000000000000000000000001",
                              "-0.25", "0", "1.9999999999999999999999999999", "2.75"))
    cases.extend((None, "guarded_amount", text)
                 for text in ("-0.25", "0", "0.9999999999999999999999999999", "1", "1.00", "2.50"))
    cases.extend((None, "eligible_amount_value", text)
                 for text in ("-1", "0", "0.5", "1", "1.5", "2.5"))
    cases = [(mode, rule, text, 2025, {}) for mode, rule, text in cases]
    cases.extend((None, "eligible_amount", text, 2025, {"judgment": True})
                 for text in ("0", "0.5", "1.5", "2.5"))
    cases.extend((None, "doubled", text, 2025, {}) for text in (
        "-0.0000000000000000000000000000", "-0.004", "39614081257132168796771975167",
    ))
    cases.extend((None, "doubled", text, 2025, {
        "fault": "arithmeticOverflow",
        "diagnostic": "arithmetic overflow: multiplication result is outside the representable decimal range",
    }) for text in ("39614081257132168796771975168", "-79228162514264337593543950335"))
    for rule, text, missing, judgment in (
        ("doubled", "1", "doubled", False),
        ("eligible_amount", "1", "eligible_amount", True),
        ("skip_missing_version", "1", "doubled", False),
        ("skip_missing_version", "0", None, False),
    ):
        options = {"judgment": judgment}
        if missing:
            options.update(fault="missingRuleVersion", diagnostic=(
                f"derived `{missing}` has no formula version at 2024-01-01"))
        cases.append((None, rule, text, 2024, options))
    invalid = {"fault": "invalidParameterIndex",
               "diagnostic": "type mismatch: parameter key for `indexed_amounts` must be an integer"}
    cases.extend((None, "indexed_amount", text, year, {}) for text, year in (
        ("-9223372036854775808", 2025), ("-1.0", 2025), ("0.00", 2025),
        ("9223372036854775807", 2025), ("0", 2026)))
    cases.extend((None, "indexed_amount", text, 2025, invalid)
                 for text in ("-1.5", "9223372036854775808", "-9223372036854775809"))
    cases.extend((None, "indexed_amount", str(key), year, {
        "fault": "missingParameterValue",
        "diagnostic": f"parameter `indexed_amounts` has no value for key `{key}` at {year}-01-01",
    }) for key, year in ((0, 2024), (2, 2025), (-1, 2026)))
    for mode, rule, text, year, fault_case in cases:
        value = {"kind": "decimal", "value": text}
        start, end = f"{year}-01-01", f"{year + 1}-01-01"
        output = f"us:policies/decimal-dependency/rules#{rule}"
        request = {"mode": "explain", "dataset": {"inputs": [{
            "name": "us:policies/decimal-dependency/rules#input.amount", "entity": "Person",
            "entity_id": "person:1", "interval": {"start": start, "end": end},
            "value": value}], "relations": []}, "queries": [{"entity_id": "person:1",
            "period": {"period_kind": "tax_year", "start": start, "end": end},
            "outputs": [output]}]}
        env = {"amount": value}
        expected, blocks = check_case(artifact, program, {"rule": rule, "env": env,
            "request": request, "as_of": start, **fault_case}, args.engine.resolve(), f"DecimalCase{len(rows)}")
        lines.extend(blocks)
        rows.append({"mode": mode, "rule": rule, "input": text, "as_of": start,
                     **({"judgment": True} if fault_case.get("judgment") else {}), **expected})
    # The newer partial spell does not contain the full query. The latest
    # covering spell must win regardless of the order of the dataset records.
    spells = [("2023-01-01", "2027-01-01", "9.005"),
              ("2024-01-01", "2026-01-01", "1.005"),
              ("2025-01-01", "2025-07-01", "8.005")]
    for order in (spells, list(reversed(spells))):
        start = "2025-01-01"
        inputs = [{"name": "us:policies/decimal-dependency/rules#input.amount",
                   "entity": "Person", "entity_id": "person:1",
                   "interval": {"start": left, "end": right},
                   "value": {"kind": "decimal", "value": text}} for left, right, text in order]
        request = {"mode": "explain", "dataset": {"inputs": inputs, "relations": []},
                   "queries": [{"entity_id": "person:1", "period": {
                       "period_kind": "tax_year", "start": start, "end": "2026-01-01"},
                       "outputs": ["us:policies/decimal-dependency/rules#doubled"]}]}
        text = "1.005"
        expected, blocks = check_case(artifact, program, {"rule": "doubled",
            "env": {"amount": {"kind": "decimal", "value": text}}, "request": request,
            "as_of": start, "covering": True}, args.engine.resolve(), f"DecimalCase{len(rows)}")
        lines.extend(blocks)
        rows.append({"mode": None, "rule": "doubled", "input": text, "as_of": start,
                     "covering_request": request, **expected})
    start, end = "2025-01-01", "2026-01-01"
    for rule, failure in (
        ("doubled", {"fault": "missingInput", "diagnostic":
            "missing input `us:policies/decimal-dependency/rules#input.amount` "
            "for entity `person:1` over 2025-01-01..2026-01-01"}),
        ("zero_denominator_amount", {"fault": "divisionByZero", "diagnostic": "division by zero"}),
        ("skip_missing_amount", {}),
    ):
        request = {"mode": "explain", "dataset": {"inputs": [], "relations": []},
                   "queries": [{"entity_id": "person:1", "period": {
                       "period_kind": "tax_year", "start": start, "end": end},
                       "outputs": [f"us:policies/decimal-dependency/rules#{rule}"]}]}
        expected, blocks = check_case(artifact, program, {"rule": rule, "env": {},
            "request": request, "as_of": start, **failure}, args.engine.resolve(), f"DecimalCase{len(rows)}")
        lines.extend(blocks)
        rows.append({"mode": None, "rule": rule, "input": None, "as_of": start, **expected})
    Path("RuleSpecLean/DecimalDependencyTests.lean").write_text("\n".join(lines) + "\n")
    subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.DecimalDependencyTests"],
                   check=True, timeout=300)
    Path("reports/decimal-dependency.json").write_text(json.dumps({
        "cases": len(rows), "artifact_sha256": hashlib.sha256(artifact.read_bytes()).hexdigest(),
        "engine_build": program["engine_build"], "lean_generation": "automatic artifact lowering",
        "status": "Rust/Python/Lean passed", "results": rows}, indent=2) + "\n")
    dependencies = sum(row["mode"] is not None for row in rows)
    builtins = sum(row["rule"] == "bounded_whole_amount" for row in rows)
    branches = sum(row["rule"] in {"guarded_amount", "eligible_amount_value"} for row in rows)
    indexed = sum(row["rule"] == "indexed_amount" for row in rows)
    judgments = sum("outcome" in row for row in rows)
    covering = sum("covering_request" in row for row in rows)
    missing = sum(row["input"] is None for row in rows)
    versions = sum(row.get("fault") == "missingRuleVersion" or
                   (row["rule"] == "skip_missing_version" and "output" in row) for row in rows)
    boundary = sum(row["rule"] == "doubled" and row["as_of"] == "2025-01-01" and
                   row["mode"] is None and row["input"] is not None and
                   "covering_request" not in row for row in rows)
    print(f"Decimal rules: {len(rows)} three-way checks passed "
          f"({dependencies} rounded dependencies, {builtins} numeric built-ins, "
          f"{branches} conditionals, {indexed} parameter lookups, {judgments} judgments, "
          f"{covering} covering-spell bindings, {missing} missing-input cases, {versions} version cases, "
          f"{boundary} numeric boundary cases)")


if __name__ == "__main__":
    main()
