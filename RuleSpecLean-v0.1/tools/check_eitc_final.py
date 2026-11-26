"""Replay a public §32 or §24(d) final-credit case on the citation overlay."""

import argparse
from fractions import Fraction
import json
from pathlib import Path
import subprocess
import sys
import tempfile

import yaml

from tools.compile_decimal import DecimalCompiler
from tools.decimal_model import DecimalValue, snapshot_literal
from tools.decimal_runtime import NumericRuntime
from tools.probe_corpus_compat import add_verified_artifact_args, digest, load_verified_artifact
from tools.replay_corpus import explain_output, wire
from tools.request_binding import bind

FIXTURE = "us/statutes/26/32.test.yaml"
CASE = "one_child_phase_in_and_allowed"
DENIAL_CASE = "investment_income_denies_credit"
CTC_CASE = "two_children_earned_income_phase_in_refundable_amount"
CTC_SS_CASE = "three_children_social_security_excess_is_greater_than_earned_income_phase_in"
CTC_OUTSIDE_CLOSURE = {
    "us:statutes/26/164/f#input.taxpayer_is_individual",
    "us:statutes/26/1401#input.filing_status",
}
OUTPUT = "us:statutes/26/32#eitc"
RELATION = "us:statutes/26/32#relation.qualifying_child_of_tax_unit"


def build_request(case, artifact, output=OUTPUT):
    period = case["period"]
    interval = {key: period[key] for key in ("start", "end")}
    tax_unit = "tax-unit:1"
    inputs, relations = [], []
    schema, = (row for row in artifact["program"]["relations"] if row["name"] == RELATION)
    if schema.get("arity") != 2 or schema.get("slot_entities") != ["TaxUnit", "Person"]:
        raise ValueError("unexpected compiled child relation slots")

    def append_fact(name, value, kind, entity_id):
        if "#input." not in name:
            raise ValueError(f"unsupported EITC case input: {name}")
        inputs.append({"name": name, "entity": kind, "entity_id": entity_id,
                       "interval": interval, "value": wire(value)})

    for name, value in case["input"].items():
        if name == RELATION:
            expected_rows = 1 if output == OUTPUT else 0
            if not isinstance(value, list) or len(value) != expected_rows:
                raise ValueError(f"expected {expected_rows} supplied EITC child rows")
            for index, row in enumerate(value, start=1):
                person = f"person:{index}"
                relations.append({"name": name, "tuple": [tax_unit, person], "interval": interval})
                for member_input, member_value in row.items():
                    append_fact(member_input, member_value, "Person", person)
        else:
            append_fact(name, value, "TaxUnit", tax_unit)
    if output == OUTPUT and not relations:
        raise ValueError("public one-child case has no child relation")
    return {"mode": "explain", "dataset": {"inputs": inputs, "relations": relations},
            "queries": [{"entity_id": tax_unit, "period": period, "outputs": [output]}]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for option in ("engine", "lake", "corpus", "report", "lean"):
        parser.add_argument(f"--{option}", type=Path, required=True)
    parser.add_argument("--audit", type=Path, default=Path("reports/corpus-static.json"))
    add_verified_artifact_args(parser)
    namespaces = {
        CASE: "EITCFinalCredit",
        DENIAL_CASE: "EITCInvestmentIncomeDenial",
        CTC_CASE: "CTCRefundableCredit",
        CTC_SS_CASE: "CTCSocialSecurityExcess",
    }
    parser.add_argument("--case", choices=namespaces, default=CASE)
    args = parser.parse_args()
    ctc = args.case in (CTC_CASE, CTC_SS_CASE)
    namespace = namespaces[args.case]
    fixture = "us/statutes/26/24/d.test.yaml" if ctc else FIXTURE
    output = "us:statutes/26/24/d#refundable_ctc" if ctc else OUTPUT
    root, rule = output.split("#")
    audit = json.loads(args.audit.read_bytes())
    raw_fixture = (args.corpus / fixture).read_bytes()
    fixture_hash, = (row["sha256"] for row in audit["results"] if row["source"] == fixture)
    if digest(raw_fixture) != fixture_hash:
        raise ValueError("public fixture differs from the pinned audit")
    case, = (row for row in yaml.safe_load(raw_fixture) if row["name"] == args.case)
    expected = case["output"][output]
    if type(expected) is not int:
        raise ValueError("expected a published whole-dollar credit")

    with tempfile.TemporaryDirectory(prefix="rulespec-final-credit-") as work:
        artifact = Path(work) / "credit.json"
        probe = Path(work) / "probe.json"
        if args.verified_artifact:
            artifact, probe = args.verified_artifact
        else:
            subprocess.run([sys.executable, "-m", "tools.probe_corpus_compat", "--engine", str(args.engine),
                            "--corpus", str(args.corpus), "--audit", str(args.audit),
                            "--eitc-report", str(probe), "--ctc-artifact" if ctc else "--eitc-artifact",
                            str(artifact)], check=True, timeout=300)
        program, provenance, attempt = load_verified_artifact(args.engine, artifact, probe, root, audit)
        request = build_request(case, program, output)
        query = request["queries"][0]
        report = {"fixture": fixture, "fixture_sha256": fixture_hash, "case": args.case,
                  "expected_usd": expected, "compatibility_probe": provenance, "request": request}
        execution = subprocess.run([str(args.engine.resolve()), "run-compiled", "--artifact", str(artifact)],
                                   input=json.dumps(request), capture_output=True, text=True, timeout=60)
        if ctc:
            catalog = {name for row in program["metadata"]["input_catalog"] for name in row["request_names"]}
            inputs = request["dataset"]["inputs"]
            extra = {fact["name"] for fact in inputs} - catalog
            closure = {module["target"] for module in attempt["source_closure"]["modules"]}
            if (extra != CTC_OUTSIDE_CLOSURE or any(name.split("#")[0] in closure for name in extra)
                    or execution.returncode != 1 or execution.stdout.strip()
                    or not any(f"dataset input `{name}` must use an absolute legal RuleSpec reference"
                               in execution.stderr for name in extra)):
                report["failure"] = {"stage": "unprojected Rust request", "diagnostic": execution.stderr.strip()}
                args.report.write_text(json.dumps(report, indent=2) + "\n")
                raise ValueError("unexpected unprojected CTC input catalog or Rust diagnostic")
            report["unprojected_attempt"] = {"request": request, "exit_code": execution.returncode,
                                             "diagnostic": execution.stderr.strip()}
            report["omitted_outside_closure_inputs"] = [fact for fact in inputs if fact["name"] in extra]
            request = {**request, "dataset": {**request["dataset"],
                                              "inputs": [fact for fact in inputs if fact["name"] not in extra]}}
            report["request"] = request
            execution = subprocess.run([str(args.engine.resolve()), "run-compiled", "--artifact", str(artifact)],
                                       input=json.dumps(request), capture_output=True, text=True, timeout=60)
        status = {}
        official = explain_output(status, execution, query)
        if execution.stderr.strip() or official is None or official.get("kind") != "scalar" or official.get("unit") != "USD":
            report["failure"] = {"stage": "Rust Explain", "diagnostic": execution.stderr.strip(),
                                 "response_stdout": execution.stdout, "status": status}
            args.report.write_text(json.dumps(report, indent=2) + "\n")
            raise ValueError(f"unexpected Explain result: {status or official}; {execution.stderr}")
        response = json.loads(execution.stdout)
        if response["metadata"]["relation_binding"] != "strict":
            raise ValueError("expected strict EITC relation binding")
        official_value = DecimalValue.from_literal(official["value"])
        report["official_response"] = response
        stage = "Rust comparison"
        try:
            if Fraction(str(official_value)) != expected:
                raise ValueError(f"Rust result {official_value} differs from published {expected}")
            if args.case == CTC_SS_CASE:
                stage = "Rust branch trace"
                trace = response["results"][0]["trace"]
                for name in ("ctc_phase_in_relevant_earnings", "ctc_social_security_excess",
                             "ctc_refundable_limitation_increase_amount"):
                    trace_id = f"{root}#{name}"
                    traced = DecimalValue.from_literal(trace[trace_id]["value"])
                    if Fraction(str(traced)) != case["output"][trace_id]:
                        raise ValueError(f"{trace_id}: Rust {traced} differs from published {case['output'][trace_id]}")
            stage = "Python binding"
            as_of = query["period"]["start"]
            env = bind(program, request, rule, validate_value=snapshot_literal, filtered_counts=True)
            report["bound_env"] = env
            stage = "Python evaluation"
            actual = NumericRuntime(program, as_of).rule(rule, env)
            report["python_value"] = str(actual)
            if Fraction(str(actual)) != expected:
                raise ValueError(f"Python result {actual} differs from published {expected}")
            stage = "Lean lowering"
            source = DecimalCompiler(program, as_of, env, allow_missing=True).emit(rule, namespace)
            source += ("\nopen RuleSpecLean.DecimalModel\n\n"
                       f"#guard match eval {namespace}.output with\n"
                       f"  | .ok value => equalValue value ⟨({expected}), 0⟩\n"
                       "  | .error _ => false\n")
            stage = "Lean evaluation"
            check = Path(work) / f"{namespace}Tests.lean"
            check.write_text(source)
            subprocess.run([str(args.lake.resolve()), "build", "RuleSpecLean.Decimal"], check=True, timeout=300)
            verification = subprocess.run([str(args.lake.resolve()), "env", "lean", str(check)],
                                          capture_output=True, text=True, timeout=60)
            if verification.returncode:
                raise ValueError((verification.stdout + verification.stderr).strip().replace(str(check), check.name))
        except (ValueError, KeyError, subprocess.SubprocessError) as exc:
            report["failure"] = {"stage": stage, "diagnostic": str(exc)}
            args.report.write_text(json.dumps(report, indent=2) + "\n")
            raise
    args.lean.write_text(source)
    report["lean_guards_passed"] = 1
    args.report.write_text(json.dumps(report, indent=2) + "\n")
    print(f"{root} {args.case}: published {expected}, Rust {official_value}, Python {actual}, Lean guard passed")


if __name__ == "__main__":
    main()
