"""Compare selected scalar outputs from the locked federal corpus."""
import argparse
from fractions import Fraction
import hashlib
import json
from os.path import abspath
from pathlib import Path
import subprocess
import tempfile

from tools.check_decimal_dependency import check_case
from tools.compile_ir import Compiler, EvalFault, emit, lean_str, lean_value, parse_value, run
from tools.decimal_model import snapshot_literal
from tools.request_binding import bind


def annual(year):
    return "tax_year", f"{year}-01-01", f"{year}-12-31"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True, type=Path)
    parser.add_argument("--lake", required=True, type=Path)
    parser.add_argument("--corpus", required=True, type=Path)
    parser.add_argument("--audit", default=Path("reports/corpus-static.json"), type=Path,
                        help="Static audit used to verify the source and import-closure hashes")
    args = parser.parse_args()
    root = Path(abspath(args.corpus))
    pin = json.loads(Path("fixtures/upstream-pin.json").read_text())
    corpus_pin = json.loads(Path("fixtures/legal-pin.json").read_text())
    audit = json.loads(args.audit.read_text())
    hashes = {row["source"]: row["sha256"] for row in audit["results"]}
    if audit["requested_corpus_pin"] != corpus_pin["commit"]:
        parser.error("corpus pin does not match the retained corpus audit")
    if audit["engine_build"] != {"commit": pin["commit"], "dirty": False}:
        parser.error("engine pin does not match the corpus audit")
    annual_slots = (
        "adjusted_gross_income", "ctc_foreign_earned_income_exclusion_adjustment",
        "ctc_possession_income_exclusion_adjustment", "ctc_puerto_rico_income_exclusion_adjustment",
    )
    eitc_slots = (
        "employee_compensation_includible_in_gross_income",
        "net_earnings_from_self_employment_after_self_employment_tax_deduction",
        "pension_or_annuity_amount", "nonresident_alien_income_not_connected_with_united_states_business",
        "penal_institution_service_compensation", "subsidized_state_work_activity_service_compensation",
    )
    cases = (
        ("ctc-magi", "CTCMagiTests", "us/statutes/26/24.yaml", "26 USC §24(b)(1) MAGI output only",
         "ctc_modified_adjusted_gross_income", annual_slots, [
            (annual(2018), ("401000", "0", "0", "0"), "401000"),
            (annual(2018), ("0", "0", "0", "0"), "0"),
            (annual(2025), ("100.10", "0.02", "0.30", "4.05"), "104.47"),
            (annual(2025), ("-10.50", "1", "2", "8.25"), "0.75"),
            (annual(2025), ("400000", "100", "200", "700"), "401000"),
         ]),
        ("ctc-phaseout", "CTCPhaseoutTests", "us/statutes/26/24.yaml", "26 USC §24(b) phaseout amount only",
         "ctc_phaseout_amount", (*annual_slots, "ctc_subsection_h_special_rules_apply", "filing_status",
                                 "ctc_phaseout_joint_threshold_applies", "ctc_phaseout_separate_threshold_applies"), [
            (annual(2025), (magi, "0", "0", "0", special, status, joint, separate), expected)
            for magi, special, status, joint, separate, expected in (
                ("399999.99", True, 1, False, False, "0"),
                ("400000", True, 1, False, False, "0"),
                ("400000.01", True, 1, False, False, "50"),
                ("201000.01", True, 0, False, False, "100"),
                ("111000", False, 1, True, False, "50"),
                ("55000.01", False, 0, False, True, "50"),
                ("75000.01", False, 0, False, False, "50"),
            )
         ]),
        ("eitc-earned-income", "EITCEarnedIncomeTests", "us/statutes/26/32/c/2.yaml",
         "26 USC §32(c)(2) earned income before the section 112 election only",
         "earned_income_before_section_112_election", eitc_slots, [
            (annual(2024), ("30000", "12000", "0", "0", "0", "0"), "42000"),
            (annual(2024), ("20000", "5000", "3000", "2000", "1000", "4000"), "15000"),
            (annual(2024), ("500", "0", "600", "0", "0", "0"), "0"),
         ]),
        ("eitc-section112-election", "EITCSection112ElectionTests", "us/statutes/26/32/c/2.yaml",
         "26 USC §32(c)(2) earned income with the section 112 election branch",
         "earned_income", (*eitc_slots, "taxpayer_elects_to_treat_section_112_excluded_amounts_as_earned_income",
                           "member_below_grade_of_commissioned_officer_in_armed_forces",
                           "served_in_combat_zone_during_month",
                           "active_service_compensation_as_enlisted_member_excluding_pensions_and_retirement_pay",
                           "commissioned_officer_in_armed_forces_excluding_commissioned_warrant_officer",
                           "armed_forces_member_in_missing_status_during_vietnam_conflict_as_result_of_conflict",
                           "civilian_employee_in_missing_status_during_vietnam_conflict_as_result_of_conflict"), [
            (annual(2024), ("10000", "0", "0", "0", "0", "0", elected,
                            True, True, "6000", False, False, False), expected)
            for elected, expected in ((False, "10000"), (True, "16000"))
         ]),
        ("snap-net-income-limit", "SNAPNetIncomeLimitTests",
         "us/policies/usda/snap/fy-2024-cola/income-eligibility-standards.yaml",
         "FY 2024 SNAP COLA page 2: designated net income limit table output only",
         "snap_net_income_limit_100_percent_fpl_48_states_dc", ("household_size",), [
            (("month", "2023-10-01", "2023-10-31"), (size,), expected)
            for size, expected in ((1, "1215"), (4, "2500"), (8, "4214"), (9, "4643"), (10, "5072"))
         ]),
        ("capital-loss-match", "CapitalLossMatchTests", "us/statutes/26/1211.yaml",
         "26 USC §1211(b)(1) filing-status match, including unmatched and missing subjects",
         "other_taxpayer_capital_loss_limit_by_filing_status", ("filing_status",), [
            (annual(2026), (0,), "3000"),
            (annual(2026), (2,), "1500"),
            (annual(2026), (9,), {"fault": "noMatchingArm", "diagnostic":
                "no `match` arm in `us:statutes/26/1211#other_taxpayer_capital_loss_limit_by_filing_status` "
                "covers `filing_status` = 9 (arms: 2, 0, 1, 3, 4); add an arm for it or a final `_ =>` arm"}),
            (annual(2026), (None,), {"fault": "missingInput", "diagnostic":
                "missing input `us:statutes/26/1211#input.filing_status` for entity `entity:1` over 2026-01-01..2026-12-31"}),
         ]),
    )
    for component in cases:
        compare(args.engine.resolve(), args.lake.resolve(), root, pin, corpus_pin, hashes, *component)
    compare(args.engine.resolve(), args.lake.resolve(), root, pin, corpus_pin, hashes,
            "ctc-after-advance", "CTCAfterAdvanceTests", "us/statutes/26/24.yaml",
            "26 USC §24: pinned corpus output after advance payments, base and subsection (h) pathways",
            "ctc_after_advance_payments", (), ctc_amount_cases(annual_slots), filtered_counts=True)
    compare(args.engine.resolve(), args.lake.resolve(), root, pin, corpus_pin, hashes,
            "ctc-refundable-cap", "CTCRefundableCapTests", "us/statutes/26/24/h.yaml",
            "26 USC §24(h)(5): refundable maximum in the pinned corpus, not the final refundable amount",
            "ctc_refundable_maximum_under_subsection_h", (), ctc_refundable_cap_cases(), filtered_counts=True)


def ctc_refundable_cap_cases():
    qualifying = {"ctc_child_satisfies_subsection_c": True,
                  "taxpayer_or_spouse_ssn_included_on_return": True,
                  "qualifying_child_ssn_included_on_return": True,
                  "taxpayer_or_spouse_ssn_is_valid_for_subsection_h": True,
                  "qualifying_child_ssn_is_valid_for_subsection_h": True}
    invalid_ssn = {**qualifying, "qualifying_child_ssn_is_valid_for_subsection_h": False}
    missing_taxpayer_ssn = {**qualifying, "taxpayer_or_spouse_ssn_included_on_return": False}
    non_child = {"ctc_child_satisfies_subsection_c": False}
    relation = "us:statutes/26/24/h#relation.dependent_of_tax_unit"
    for year, people, expected in (
        (2025, [], "0"),
        (2018, [qualifying], "1400"),
        (2025, [qualifying, invalid_ssn, non_child, qualifying], "2800"),
        (2025, [missing_taxpayer_ssn, missing_taxpayer_ssn], "0"),
    ):
        yield annual(year), {}, people, relation, expected


def ctc_amount_cases(annual_slots):
    child = {"ctc_child_satisfies_subsection_c": True, "ctc_person_satisfies_dependency_rules": True,
             "taxpayer_or_spouse_ssn_included_on_return": True, "qualifying_child_ssn_included_on_return": True,
             "taxpayer_or_spouse_ssn_is_valid_for_subsection_h": True,
             "qualifying_child_ssn_is_valid_for_subsection_h": True}
    adult = {"ctc_child_satisfies_subsection_c": False, "ctc_person_satisfies_dependency_rules": True,
             "noncitizen_exception_to_other_dependent_credit_under_subsection_h": False}
    excluded = {**adult, "noncitizen_exception_to_other_dependent_credit_under_subsection_h": True}
    base_child = {"ctc_child_satisfies_dependency_rules": True, "age": 16,
                  "ctc_child_deduction_allowed": True, "certain_noncitizen_exception_applies": False,
                  "ctc_child_missing_identification": False}
    for special, magi, advance, fraud, people, expected in (
        (True, "100000", "0", False, [], "0"),
        (True, "100000", "0", False, [child], "2200"),
        (True, "400000.01", "100", False, [child, adult, excluded], "2550"),
        (True, "100000", "3000", False, [child], "0"),
        (True, "100000", "0", True, [child], "0"),
        (False, "75000.01", "0", False, [base_child, {**base_child, "age": 17}], "950"),
        (False, "70000", "0", False, [{**base_child, "ctc_child_missing_identification": True}], "0"),
    ):
        facts = dict(zip(annual_slots, (magi, "0", "0", "0"), strict=True))
        facts.update(ctc_subsection_h_special_rules_apply=special, filing_status=1,
                     ctc_phaseout_joint_threshold_applies=False, ctc_phaseout_separate_threshold_applies=False,
                     taxpayer_identification_number_issued_after_return_due_date=False, taxable_year_months=12,
                     ctc_fraud_disallowance_period_applies=fraud,
                     ctc_reckless_or_intentional_disregard_disallowance_period_applies=False,
                     prior_deficiency_denial_without_required_eligibility_information=False,
                     ctc_advance_payments_received=advance)
        relation = ("us:statutes/26/24/h#relation.dependent_of_tax_unit" if special else
                    "us:statutes/26/24#relation.ctc_qualifying_child_of_tax_unit")
        yield annual(2025), facts, people, relation, expected


def compare(engine, lake, root, pin, corpus_pin, hashes, report, module_name,
            relative, scope, rule, slots, cases, *, filtered_counts=False):
    source_hash = hashlib.sha256((root / relative).read_bytes()).hexdigest()
    if hashes.get(relative) != source_hash:
        raise ValueError(f"source does not match the retained corpus audit: {relative}")
    with tempfile.TemporaryDirectory(prefix="rulespec-legal-") as work:
        artifact = Path(work) / "legal.json"
        subprocess.run([str(engine), "compile", "--program", str(root / relative),
                        "--rulespec-root", str(root), "--output", str(artifact)], check=True, timeout=120)
        raw = artifact.read_bytes()
        program = json.loads(raw)
        if program["engine_build"] != {"commit": pin["commit"], "dirty": False}:
            raise ValueError("clean pinned engine required")
        for module in program["source_closure"]["modules"]:
            path = module["target"].replace("us:", "us/", 1) + ".yaml"
            if hashes.get(path) != module["sha256"]:
                raise ValueError(f"dependency does not match the retained corpus audit: {path}")
        lines = ["import RuleSpecLean.Decimal", "", "open RuleSpecLean.DecimalModel", ""]
        if report == "capital-loss-match":
            lines.insert(0, "import RuleSpecLean.Core")
        results = []
        output = next(row for row in program["program"]["derived"] if row["name"] == rule)
        aliases = {row["slot"]: row["canonical_request_name"] for row in program["metadata"]["input_catalog"]}
        for index, example in enumerate(cases):
            if filtered_counts:
                (period_kind, start, end), facts, people, relation, expected = example
            else:
                (period_kind, start, end), amounts, expected = example
                facts, people = dict(zip(slots, amounts, strict=True)), []
            kinds = {bool: "bool", int: "integer", str: "decimal"}
            interval = {"start": start, "end": end}

            def records(values, entity, entity_id):
                return [{"name": aliases[slot], "entity": entity, "entity_id": entity_id,
                         "interval": interval, "value": {"kind": kinds[type(value)], "value": value}}
                        for slot, value in values.items() if value is not None]

            inputs = records(facts, output["entity"], "entity:1")
            relations = []
            for member, values in enumerate(people):
                entity_id = f"person:{member}"
                inputs.extend(records(values, "Person", entity_id))
                relations.append({"name": relation,
                                  "tuple": ["entity:1", entity_id], "interval": interval})
            request = {"mode": "explain", "dataset": {"relations": relations, "inputs": inputs},
                "queries": [{"entity_id": "entity:1", "period": {"period_kind": period_kind,
                             "start": start, "end": end}, "outputs": [output["id"]]}]}
            env = bind(program, request, rule, validate_value=snapshot_literal, filtered_counts=filtered_counts)
            case = {"rule": rule, "env": env, "as_of": start, "request": request,
                    "filtered_counts": filtered_counts}
            if isinstance(expected, dict):
                case.update(expected)
            outcome, blocks = check_case(artifact, program, case, engine, f"{module_name}Case{index}")
            if not isinstance(expected, dict) and Fraction(outcome["output"]) != Fraction(expected):
                raise ValueError(f"{rule} case {index}: expected {expected}, got {outcome['output']}")
            results.append({"request": request, "expected": expected, **outcome})
            lines.extend(blocks)
            if report == "capital-loss-match":
                namespace = f"Scale6CapitalLossCase{index}"
                compiler = Compiler(program, start)
                compiler.compile([rule])
                source, _ = emit(compiler, [rule])
                lines.append(source.removeprefix("import RuleSpecLean.Core\n").replace(
                    "RuleSpecLean.Generated", f"RuleSpecLean.{namespace}"))
                if "fault" in outcome:
                    try:
                        run(compiler.normal[rule], env, compiler.normal)
                    except EvalFault as exc:
                        if str(exc) != outcome["fault"]:
                            raise ValueError(f"scale-6 fault differs from Rust for case {index}: {exc}") from exc
                    else:
                        raise ValueError(f"scale-6 unexpectedly succeeded for case {index}")
                    target = f"(.error .{outcome['fault']})"
                else:
                    official = ("integer", outcome["official_value"])
                    if run(compiler.normal[rule], env, compiler.normal) != official:
                        raise ValueError(f"scale-6 result differs from Rust for case {index}")
                    target = f"(.ok {lean_value(official)})"
                lean_env = ", ".join(f"({lean_str(slot)}, {lean_value(parse_value(value))})"
                                     for slot, value in sorted(env.items()))
                lines.append(f"open RuleSpecLean in\n#guard sameResult (RuleSpecLean.eval [{lean_env}] "
                             f"RuleSpecLean.{namespace}.output_0) {target}")
        Path(f"RuleSpecLean/{module_name}.lean").write_text("\n".join(lines) + "\n")
        subprocess.run([str(lake), "build", f"RuleSpecLean.{module_name}"], check=True, timeout=300)
        Path(f"reports/{report}.json").write_text(json.dumps({
            "source": relative, "source_sha256": source_hash, "corpus_pin": corpus_pin["commit"],
            "source_closure": program["source_closure"], "artifact_sha256": hashlib.sha256(raw).hexdigest(),
            "engine_build": program["engine_build"], "scope": scope,
            "status": "Rust/Python/Lean passed", "cases": len(results), "results": results,
            **({"scale6_cases": len(results)} if report == "capital-loss-match" else {}),
        }, indent=2, ensure_ascii=False) + "\n")
        print(f"{report}: {len(results)} three-way checks passed")


if __name__ == "__main__":
    main()
