"""Replay a public §32 final-credit case on the citation overlay."""

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
from tools.probe_corpus_compat import digest
from tools.replay_corpus import explain_output, wire
from tools.request_binding import bind

FIXTURE = "us/statutes/26/32.test.yaml"
CASE = "one_child_phase_in_and_allowed"
DENIAL_CASE = "investment_income_denies_credit"
OUTPUT = "us:statutes/26/32#eitc"
RELATION = "us:statutes/26/32#relation.qualifying_child_of_tax_unit"


def build_request(case, artifact):
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
            if not isinstance(value, list) or len(value) != 1:
                raise ValueError("expected one supplied child row")
            person = "person:1"
            relations.append({"name": name, "tuple": [tax_unit, person], "interval": interval})
            for member_input, member_value in value[0].items():
                append_fact(member_input, member_value, "Person", person)
        else:
            append_fact(name, value, "TaxUnit", tax_unit)
    if not relations:
        raise ValueError("public one-child case has no child relation")
    return {"mode": "explain", "dataset": {"inputs": inputs, "relations": relations},
            "queries": [{"entity_id": tax_unit, "period": period, "outputs": [OUTPUT]}]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for option in ("engine", "lake", "corpus", "report", "lean"):
        parser.add_argument(f"--{option}", type=Path, required=True)
    parser.add_argument("--audit", type=Path, default=Path("reports/corpus-static.json"))
    parser.add_argument("--case", choices=(CASE, DENIAL_CASE), default=CASE)
    args = parser.parse_args()
    namespace = "EITCFinalCredit" if args.case == CASE else "EITCInvestmentIncomeDenial"
    audit = json.loads(args.audit.read_bytes())
    raw_fixture = (args.corpus / FIXTURE).read_bytes()
    fixture_hash, = (row["sha256"] for row in audit["results"] if row["source"] == FIXTURE)
    if digest(raw_fixture) != fixture_hash:
        raise ValueError("public EITC fixture differs from the pinned audit")
    case, = (row for row in yaml.safe_load(raw_fixture) if row["name"] == args.case)
    expected = case["output"][OUTPUT]
    if type(expected) is not int:
        raise ValueError("expected a published whole-dollar credit")

    with tempfile.TemporaryDirectory(prefix="rulespec-eitc-final-") as work:
        artifact = Path(work) / "eitc.json"
        probe = Path(work) / "probe.json"
        subprocess.run([sys.executable, "-m", "tools.probe_corpus_compat", "--engine", str(args.engine),
                        "--corpus", str(args.corpus), "--audit", str(args.audit),
                        "--eitc-report", str(probe), "--eitc-artifact", str(artifact)], check=True, timeout=300)
        provenance = json.loads(probe.read_bytes())
        raw_artifact = artifact.read_bytes()
        attempt, = (row for row in provenance["attempts"] if row["source_closure"]["root"] == "us:statutes/26/32")
        if digest(raw_artifact) != attempt["artifact_sha256"]:
            raise ValueError("exported EITC artifact differs from the verified §32 artifact")
        program = json.loads(raw_artifact)
        request = build_request(case, program)
        query = request["queries"][0]
        execution = subprocess.run([str(args.engine.resolve()), "run-compiled", "--artifact", str(artifact)],
                                   input=json.dumps(request), capture_output=True, text=True, timeout=60)
        status = {}
        official = explain_output(status, execution, query)
        if execution.stderr.strip() or official is None or official.get("kind") != "scalar" or official.get("unit") != "USD":
            raise ValueError(f"unexpected EITC Explain result: {status or official}; {execution.stderr}")
        response = json.loads(execution.stdout)
        if response["metadata"]["relation_binding"] != "strict":
            raise ValueError("expected strict EITC relation binding")
        official_value = DecimalValue.from_literal(official["value"])
        report = {"fixture": FIXTURE, "fixture_sha256": fixture_hash, "case": args.case,
                  "expected_usd": expected, "compatibility_probe": provenance, "request": request,
                  "official_response": response}
        stage = "Rust comparison"
        try:
            if Fraction(str(official_value)) != expected:
                raise ValueError(f"Rust result {official_value} differs from published {expected}")
            stage = "Python binding"
            as_of = query["period"]["start"]
            env = bind(program, request, "eitc", validate_value=snapshot_literal, filtered_counts=True)
            report["bound_env"] = env
            stage = "Python evaluation"
            actual = NumericRuntime(program, as_of).rule("eitc", env)
            report["python_value"] = str(actual)
            if Fraction(str(actual)) != expected:
                raise ValueError(f"Python result {actual} differs from published {expected}")
            stage = "Lean lowering"
            source = DecimalCompiler(program, as_of, env, allow_missing=True).emit("eitc", namespace)
            source += ("\nopen RuleSpecLean.DecimalModel\n\n"
                       f"#guard match eval {namespace}.output with\n"
                       f"  | .ok value => equalValue value ⟨({expected}), 0⟩\n"
                       "  | .error _ => false\n")
            stage = "Lean evaluation"
            check = Path(work) / "EITCFinalCreditTests.lean"
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
    print(f"EITC §32 {args.case}: published {expected}, Rust {official_value}, Python {actual}, Lean guard passed")


if __name__ == "__main__":
    main()
