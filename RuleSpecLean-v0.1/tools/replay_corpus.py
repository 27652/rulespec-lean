"""Replay published scalar examples from the locked corpus (requires PyYAML)."""
import argparse
from calendar import monthrange
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile

from tools.check_faults import PATTERNS
from tools.compile_ir import Compiler, EvalFault, Unsupported, lean_expr, lean_str, lean_value, number, parse_value, require, run
from tools.request_binding import bind

JUDGMENTS = {"holds": "holds", "not_holds": "notHolds", "undetermined": "undetermined"}


def check_example_context(case):
    extra = set(case) - {"name", "period", "input", "output", "tables"}
    if extra:
        raise Unsupported(f"unsupported example fields: {', '.join(sorted(extra))}")


def example_bindings(case, entity, expectation):
    """Pair each input row with its positional output for a single entity type."""
    check_example_context(case)
    inputs = case.get("input", {})
    require(isinstance(inputs, dict), "example input must be a mapping")
    if "tables" not in case:
        return [(inputs, expectation)]
    tables = case["tables"]
    require(isinstance(tables, dict) and set(tables) == {entity} and not inputs,
            "table replay requires one matching entity table and no flat inputs")
    rows = tables[entity]
    require(isinstance(rows, list) and rows and all(isinstance(row, dict) for row in rows),
            "table replay requires nonempty input rows")
    require(isinstance(expectation, list) and len(expectation) == len(rows),
            "table replay requires an expected output for each input row")
    return list(zip(rows, expectation, strict=True))


def example_period(value):
    if isinstance(value, str) and re.fullmatch(r"[0-9]{4}-[0-9]{2}", value):
        year, month = map(int, value.split("-"))
        require(1 <= month <= 12 and year > 0, "invalid example month")
        return {"period_kind": "month", "start": f"{value}-01", "end": f"{value}-{monthrange(year, month)[1]}"}
    require(isinstance(value, dict), "unsupported example period")
    return {key: str(item) for key, item in value.items()}


def wire(value, kind=None):
    if type(value) is bool:
        return {"kind": "bool", "value": value}
    if type(value) is int and kind != "decimal":
        return {"kind": "integer", "value": value}
    if type(value) is int:
        return {"kind": "decimal", "value": str(value)}
    raise Unsupported("example value outside boolean/numeric subset")


def matches_example(actual, expected):
    # YAML expectations specify a number, not an engine wire tag. Runtime
    # parity below still compares both the tag and payload exactly.
    numeric = {"integer", "decimal"}
    if actual[0] in numeric and expected[0] in numeric:
        return number(actual) == number(expected)
    return actual == expected


def compare_response(result, compute, item, wanted):
    """Distinguish an unrepresentable official value from a local runtime failure."""
    try:
        if item["kind"] == "judgment":
            official = ("judgment", JUDGMENTS[item["outcome"]])
        elif item["kind"] == "scalar":
            official = parse_value(item["value"])
        else:
            result.update(status="unexpectedResponse", reason=f"unknown output kind: {item['kind']}")
            return None
    except Unsupported as exc:
        reason = str(exc)
        status = "comparisonUnavailable" if reason == "decimal outside exact subset" else "unexpectedResponse"
        result.update(status=status, reason=reason)
        return None
    except (KeyError, TypeError) as exc:
        result.update(status="unexpectedResponse", reason=str(exc))
        return None
    try:
        actual = compute()
    except EvalFault as exc:
        status = "comparisonUnavailable" if str(exc) == "outsideExactDomain" else "runtimeMismatch"
        result.update(status=status, expected=wanted, official=official, reason=str(exc))
        return None
    except (ValueError, KeyError) as exc:
        result.update(status="runtimeMismatch", expected=wanted, official=official, reason=str(exc))
        return None
    if actual != official or not matches_example(official, wanted):
        result.update(status="runtimeMismatch" if actual != official else "exampleMismatch",
                      expected=wanted, python=actual, official=official)
        return None
    return official


def explain_output(result, execution, query):
    """Accept only Explain responses and the known missing-version rejection."""
    if execution.returncode:
        diagnostic = execution.stderr.strip()
        known = (execution.returncode == 1 and not execution.stdout.strip() and
                 re.fullmatch(PATTERNS["missingVersion"], diagnostic) is not None)
        result.update(status="engineRejected" if known else "unexpectedResponse",
                      reason=diagnostic or f"engine exited with status {execution.returncode}")
        return None
    try:
        response = json.loads(execution.stdout)
        if response["metadata"]["actual_mode"] == "explain":
            row, = response["results"]
            output, = query["outputs"]
            outputs = row["outputs"]
            if (row["entity_id"] == query["entity_id"] and row["period"] == query["period"]
                    and isinstance(outputs, dict) and set(outputs) == {output}
                    and isinstance(outputs[output], dict) and outputs[output].get("id") == output):
                return outputs[output]
    except (ValueError, KeyError, TypeError):
        pass
    result.update(status="unexpectedResponse", reason="invalid Explain response or output identity")
    return None


def lost_matches(baseline, current):
    for key in ("prefix", "engine_build", "corpus_pin"):
        require(baseline[key] == current[key], f"replay baseline differs in {key}")

    def statuses(report):
        return {(module["fixture"], output["case"], output["output"]): output["status"]
                for module in report["results"] for output in module["outputs"]}

    current_status = statuses(current)
    return [{"fixture": fixture, "case": case, "output": output,
             "status": current_status.get((fixture, case, output), "absent")}
            for (fixture, case, output), status in statuses(baseline).items()
            if status == "matched" and current_status.get((fixture, case, output)) != "matched"]


def check_lean_batches(lake, directory, checks, batch_size=128):
    """Bound the size of each Lean file; isolate failing checks for the report."""
    command = [str(lake), "env", "lean"]
    path = directory / "CorpusReplay.lean"

    def check(batch):
        path.write_text("import RuleSpecLean.Core\n\nopen RuleSpecLean\n\n" +
                        "\n".join(source for _, source in batch))
        try:
            process = subprocess.run([*command, str(path)], capture_output=True, text=True, timeout=120)
            if process.returncode == 0:
                for result, _ in batch:
                    result["status"] = "matched"
                return
            diagnostic = (process.stdout + process.stderr).strip().replace(str(path), "CorpusReplay.lean")
        except subprocess.TimeoutExpired:
            diagnostic = "Lean batch timed out"
        if len(batch) == 1:
            batch[0][0].update(status="leanRejected", reason=diagnostic)
        else:
            middle = len(batch) // 2
            check(batch[:middle])
            check(batch[middle:])

    for start in range(0, len(checks), batch_size):
        check(checks[start:start + batch_size])


def replay_row(result, inputs, expectation, *, rule, period, program, aliases, literal,
               engine, compiled, checks):
    output, name, entity = rule["id"], rule["name"], rule["entity"]
    try:
        start, end = period["start"], period["end"]
        if rule["semantics"] == "judgment":
            want = ("judgment", JUDGMENTS[expectation])
        else:
            want = parse_value(literal(expectation, rule["dtype"]))
        compiler = Compiler(program, start)
        compiler.compile([name])
        entity_id = f"entity:{result.get('row', 0) + 1}"
        facts = [{"name": key, "entity": entity, "entity_id": entity_id,
                  "interval": {"start": start, "end": end},
                  "value": literal(value, aliases[key].get("dtype"))}
                 for key, value in inputs.items()]
        query = {"entity_id": entity_id, "period": period, "outputs": [output]}
        request = {"mode": "explain", "dataset": {"inputs": facts, "relations": []}, "queries": [query]}
        env = bind(program, request, name)
        names = {n: f"r{i}" for i, n in enumerate(compiler.normal)}
        definitions = [f"def {names[n]} : Expr := {lean_expr(tree, names)}"
                       for n, tree in compiler.normal.items()]
        lean_env = ", ".join(f"({lean_str(key)}, {lean_value(parse_value(value))})"
                             for key, value in sorted(env.items()))
    except (ValueError, KeyError, TypeError, AttributeError, RecursionError) as exc:
        result.update(status="outsideReplaySubset", reason=str(exc))
        return
    result["request"] = request
    executed = subprocess.run([str(engine), "run-compiled", "--artifact", str(compiled)],
                              input=json.dumps(request), text=True, capture_output=True, timeout=60)
    item = explain_output(result, executed, query)
    if item is None:
        return
    official = compare_response(result, lambda: run(compiler.normal[name], env, compiler.normal), item, want)
    if official is None:
        return
    namespace = f"CorpusCase{len(checks)}"
    source = "\n".join([f"namespace {namespace}", *definitions,
                       f"#guard sameResult (eval [{lean_env}] {names[name]}) (.ok {lean_value(official)})",
                       f"end {namespace}", ""])
    result.update(expected=want, official=official)
    checks.append((result, source))


REPLAY_FAILURES = ("leanRejected", "runtimeMismatch", "exampleMismatch", "unexpectedResponse")


def summarize_table(result):
    """Count an output list as passed only after all its row guards pass."""
    rows = result["rows"]
    for status in (*REPLAY_FAILURES, "engineRejected", "comparisonUnavailable", "outsideReplaySubset"):
        if any(row["status"] == status for row in rows):
            result["status"] = status
            return
    assert all(row["status"] == "matched" for row in rows)
    result["status"] = "matched"


def main():
    import yaml

    # Keep numeric spellings instead of parsing their mantissas as binary floats.
    class ExampleLoader(yaml.SafeLoader):
        pass

    class DecimalText(str):
        pass

    ExampleLoader.add_constructor("tag:yaml.org,2002:float", lambda loader, node: DecimalText(node.value))

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True, type=Path)
    parser.add_argument("--lake", required=True, type=Path)
    parser.add_argument("--corpus", required=True, type=Path)
    parser.add_argument("--prefix", default="us/")
    parser.add_argument("--audit", type=Path, default=Path("reports/corpus-static.json"))
    parser.add_argument("--baseline", type=Path, help="Reject lost matches against a retained replay report")
    parser.add_argument("--report", type=Path, default=Path("reports/corpus-replay.json"))
    args = parser.parse_args()
    audit = json.loads(args.audit.read_text())
    baseline = json.loads(args.baseline.read_text()) if args.baseline else None
    if args.baseline and args.baseline.resolve() == args.report.resolve():
        parser.error("the baseline and output report must be separate files")
    engine = args.engine.resolve()
    root = args.corpus.absolute()
    capabilities = json.loads(subprocess.check_output([str(engine), "capabilities"], timeout=30))
    if capabilities["engine_build"] != audit["engine_build"]:
        parser.error("engine build does not match static audit")
    hashes = {row["source"]: row["sha256"] for row in audit["results"]}
    module_rows = []
    checks = []

    def checked_read(path):
        raw = (root / path).read_bytes()
        if hashlib.sha256(raw).hexdigest() != hashes[path]:
            raise ValueError(f"corpus hash mismatch: {path}")
        return raw

    def literal(value, kind=None):
        if isinstance(value, DecimalText) and kind != "integer":
            return {"kind": "decimal", "value": str(value)}
        return wire(value, kind)

    with tempfile.TemporaryDirectory(prefix="rulespec-replay-") as work:
        compiled = Path(work) / "artifact.json"
        for module in audit["results"]:
            relative = module["source"]
            fixture = relative.removesuffix(".yaml") + ".test.yaml"
            if not relative.startswith(args.prefix) or fixture not in hashes:
                continue
            checked_read(relative)
            row = {"source": relative, "fixture": fixture, "outputs": []}
            module_rows.append(row)
            try:
                examples = yaml.load(checked_read(fixture), Loader=ExampleLoader)
            except yaml.YAMLError as exc:
                row.update(status="unsupportedFixture", reason=str(exc))
                continue
            if not isinstance(examples, list):
                row["status"] = "unsupportedFixture"
                continue
            program = None
            if module["compile"] == "passed" and module["compiler"] == "compile":
                subprocess.run([str(engine), "compile", "--program", str(root / relative),
                                "--rulespec-root", str(root), "--output", str(compiled)],
                               check=True, capture_output=True, timeout=120)
                program = json.loads(compiled.read_bytes())
                for dependency in program["source_closure"]["modules"]:
                    path = dependency["target"].replace("us:", "us/", 1) + ".yaml"
                    if hashes.get(path) != dependency["sha256"]:
                        raise ValueError(f"dependency hash mismatch: {path}")
                rules = {rule["id"]: rule for rule in program["program"]["derived"]}
                metadata = {item["name"]: item for item in program["program"]["interface"]["inputs"]}
                aliases = {name: metadata.get(item["slot"], {}) for item in program["metadata"]["input_catalog"]
                           for name in item["request_names"]}
            for index, case in enumerate(examples):
                if not isinstance(case, dict) or not isinstance(case.get("output"), dict):
                    row.setdefault("unsupported_cases", []).append(index)
                    continue
                for output, expectation in case["output"].items():
                    result = {"case": index, "output": output}
                    row["outputs"].append(result)
                    if program is None:
                        result["status"] = "moduleUnavailable"
                        continue
                    if output not in rules:
                        result["status"] = "notDerivedOutput"
                        continue
                    rule = rules[output]
                    try:
                        bindings = example_bindings(case, rule["entity"], expectation)
                        period = example_period(case["period"])
                    except (ValueError, KeyError, TypeError) as exc:
                        result.update(status="outsideReplaySubset", reason=str(exc))
                        continue
                    if len(bindings) == 1:
                        targets = [result]
                    else:
                        targets = [{"row": i} for i in range(len(bindings))]
                        result["rows"] = targets
                    for target, (inputs, expected) in zip(targets, bindings, strict=True):
                        replay_row(target, inputs, expected, rule=rule, period=period, program=program,
                                   aliases=aliases, literal=literal, engine=engine, compiled=compiled, checks=checks)
        check_lean_batches(args.lake.resolve(), Path(work), checks)
        outputs = [output for module in module_rows for output in module["outputs"]]
        for output in outputs:
            if "rows" in output:
                summarize_table(output)
        counts = Counter(output["status"] for output in outputs)
        row_counts = Counter(row["status"] for output in outputs for row in output.get("rows", [output]))
        attempted = sum(row_counts[status] for status in
                        ("matched", *REPLAY_FAILURES, "comparisonUnavailable", "engineRejected"))
        report = {"prefix": args.prefix, "engine_build": audit["engine_build"],
                  "corpus_pin": audit["requested_corpus_pin"], "modules": len(module_rows),
                  "output_expectations": sum(counts.values()), "counts": dict(counts),
                  "official_attempted": attempted, "official_explain_responses":
                      attempted - row_counts["engineRejected"] - row_counts["unexpectedResponse"],
                  "lean_attempted": len(checks), "lean_guards": row_counts["matched"], "results": module_rows}
        regressions = lost_matches(baseline, report) if baseline is not None else []
        if baseline is not None:
            report["lost_baseline_matches"] = regressions
        args.report.parent.mkdir(parents=True, exist_ok=True)
        with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=args.report.parent,
                                         delete=False) as staged:
            staged_path = Path(staged.name)
            try:
                json.dump(report, staged, indent=2, ensure_ascii=False)
                staged.write("\n")
                staged.close()
                staged_path.replace(args.report)
            finally:
                staged_path.unlink(missing_ok=True)
        print(f"Corpus replay: {len(module_rows)} modules; {sum(counts.values())} expectations; {dict(counts)}")
        if regressions:
            raise SystemExit(f"Corpus replay lost {len(regressions)} baseline matches; see replay report")
        if not counts["matched"] or any(counts[status] for status in REPLAY_FAILURES):
            raise SystemExit("Corpus replay checks failed; see replay report")


if __name__ == "__main__":
    main()
