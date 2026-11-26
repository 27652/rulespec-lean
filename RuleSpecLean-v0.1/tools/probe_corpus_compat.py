"""Probe compiler admission after scoped compatibility edits in a temporary corpus copy."""

import argparse
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile

import yaml


DEPENDENCIES = (
    "us/policies/irs/rev-proc-2025-32/earned-income-credit.yaml",
    "us/policies/usda/snap/fy-2026-cola/deductions.yaml",
    "us/policies/usda/snap/fy-2026-cola/maximum-allotments.yaml",
)
ENTRYPOINTS = ("us/statutes/26/24/d.yaml", "us/statutes/26/32.yaml", "us/regulations/7-cfr/273/10.yaml")
SNAP_RELATION = "us/statutes/7/2012/j.yaml"
SNAP_COMPOSITION = "us/policies/usda/snap/state-plan-composition.yaml"
SNAP_RELATION_ID = "us:statutes/7/2012/j#relation.member_of_household"
EITC_PAGE_15 = "us/policies/irs/rev-proc-2025-32/page-15.yaml"
EITC_CITATIONS = [f"us/guidance/irs/rev-proc-2025-32/page-{page}" for page in (14, 15)]


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


def retain_snap_verification(raw):
    """Detach only the obsolete values field, retaining its exact YAML for audit."""
    block, = re.findall(rb"^  source_verification:\n(?:^    .*\n)+", raw, flags=re.M)
    values, = re.findall(rb"^    values:\n(?:^      .*\n)+", block, flags=re.M)
    expected = yaml.safe_load(raw)
    verification = expected["module"]["source_verification"]
    legacy = verification.pop("values")
    if yaml.safe_load(values) != {"values": legacy} or not verification.get("corpus_citation_path"):
        raise ValueError("unexpected legacy source verification structure")
    candidate = raw.replace(block, block.replace(values, b""), 1)
    if yaml.safe_load(candidate) != expected:
        raise ValueError("unexpected change outside module.source_verification.values")
    return candidate, {"retained": verification, "legacy_values_yaml": values.decode("utf-8"),
                       "legacy_values_sha256": digest(values)}


def migrate_eitc_verification(raw, page_15):
    """Use the page containing the amounts; archive the original cross-page record."""
    block, = re.findall(rb"^  source_verification:\n(?:^    .*\n)+", raw, flags=re.M)
    expected = yaml.safe_load(raw)
    legacy = expected["module"]["source_verification"]
    if set(legacy) != {"corpus_citation_paths", "values"} or legacy["corpus_citation_paths"] != EITC_CITATIONS:
        raise ValueError("unexpected legacy EITC citations")
    citation = EITC_CITATIONS[1]
    reference = yaml.safe_load(page_15)
    if reference["module"]["source_verification"]["corpus_citation_path"] != citation:
        raise ValueError("unexpected EITC reference page")
    rule_matches = {}
    expected_values = {}
    for rule in expected["rules"]:
        version, = rule["versions"]
        field = "values" if rule.get("indexed_by") else "formula"
        name = rule["name"]
        amount = version[field] if field == "values" else int(version[field])
        matches = [reference_rule["name"] for reference_rule in reference["rules"]
                   if reference_rule["kind"] == "parameter" and reference_rule["source"] == rule["source"]
                   and any(v.get(field) == version[field] and v["effective_from"] == version["effective_from"]
                           for v in reference_rule["versions"])
                   and any(atom["source"].get("corpus_citation_path") == citation
                           and atom["path"] == f"versions[0].{field}"
                           for atom in reference_rule["metadata"]["proof"]["atoms"])]
        if rule["kind"] != "parameter" or len(matches) != 1 or amount != legacy["values"].get(name):
            raise ValueError(f"cannot corroborate EITC parameter on page 15: {name}")
        rule_matches[name] = matches[0]
        expected_values[name] = amount
    if len(rule_matches) != 7 or set(rule_matches) != set(legacy["values"]):
        raise ValueError("incomplete EITC parameter coverage")
    retained = {"corpus_citation_path": citation}
    expected["module"]["source_verification"] = retained
    candidate = raw.replace(block, f"  source_verification:\n    corpus_citation_path: {citation}\n".encode(), 1)
    if yaml.safe_load(candidate) != expected:
        raise ValueError("EITC migration changed executable source")
    return candidate, {"retained": retained, "context_citation_path": EITC_CITATIONS[0],
                       "legacy_verification_yaml": block.decode(), "legacy_verification_sha256": digest(block),
                       "reference": {"path": EITC_PAGE_15, "sha256": digest(page_15), "rule_matches": rule_matches}}, expected_values


def type_snap_relation(raw, composition):
    reference, = (rule["data_relation"] for rule in yaml.safe_load(composition)["rules"]
                  if rule["kind"] == "data_relation" and rule["name"] == "member_of_household")
    slots = reference["arguments"]
    expected = yaml.safe_load(raw)
    relation, = (rule["data_relation"] for rule in expected["rules"]
                 if rule["kind"] == "data_relation" and rule["name"] == "member_of_household")
    if reference["arity"] != relation["arity"] or relation != {"arity": 2} or slots != ["Person", "Household"]:
        raise ValueError("unexpected SNAP relation signature")
    relation["arguments"] = slots
    candidate = raw.replace(b"      arity: 2\n", b"      arity: 2\n      arguments: [Person, Household]\n", 1)
    if yaml.safe_load(candidate) != expected:
        raise ValueError("unexpected changes outside the SNAP relation declaration")
    return candidate, slots


def add_verified_artifact_args(parser):
    parser.add_argument("--verified-artifact", nargs=2, type=Path, metavar=("ARTIFACT", "PROBE"),
                        help="Replay an already compiled artifact that matches the given compatibility probe")


def load_verified_artifact(engine, artifact, probe, root, audit):
    provenance = json.loads(probe.read_bytes())
    build = json.loads(subprocess.check_output([str(engine.resolve()), "capabilities"], timeout=30))["engine_build"]
    if build != audit["engine_build"] or build != provenance["engine_build"]:
        raise ValueError("engine build differs from the audit or probe")
    if provenance["corpus_pin"] != audit["requested_corpus_pin"]:
        raise ValueError("probe corpus pin differs from the audit")
    attempt, = (row for row in provenance["attempts"] if row["exit_code"] == 0 and row["source_closure"]["root"] == root)
    raw = artifact.read_bytes()
    if digest(raw) != attempt["artifact_sha256"]:
        raise ValueError(f"artifact differs from the verified {root} artifact")
    return json.loads(raw), provenance, attempt


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True, type=Path)
    parser.add_argument("--corpus", required=True, type=Path)
    parser.add_argument("--audit", default=Path("reports/corpus-static.json"), type=Path)
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument("--snap-report", type=Path,
                        help="Probe SNAP only, adding the corpus-defined relation slots in a second stage")
    modes.add_argument("--eitc-report", type=Path, help="Probe the shared CTC/EITC dependency citation migration")
    parser.add_argument("--snap-artifact", type=Path, help="Export the verified temporary SNAP artifact")
    parser.add_argument("--eitc-artifact", type=Path, help="Export the verified temporary §32 artifact")
    parser.add_argument("--ctc-artifact", type=Path, help="Export the verified temporary §24(d) artifact")
    parser.add_argument("--retain-source-verification", action="store_true",
                        help="For SNAP, detach only legacy values and preserve the citation metadata")
    args = parser.parse_args()
    if args.snap_artifact and not args.snap_report:
        parser.error("--snap-artifact requires --snap-report")
    if args.eitc_artifact and not args.eitc_report:
        parser.error("--eitc-artifact requires --eitc-report")
    if args.ctc_artifact and not args.eitc_report:
        parser.error("--ctc-artifact requires --eitc-report")
    if args.retain_source_verification and not args.snap_report:
        parser.error("--retain-source-verification requires --snap-report")
    engine = str(args.engine.resolve())
    audit = json.loads(args.audit.read_text())
    caps = subprocess.check_output([engine, "capabilities"], text=True, timeout=30)
    if json.loads(caps)["engine_build"] != audit["engine_build"]:
        parser.error("engine build differs from static audit")
    audited = {row["source"]: row["sha256"] for row in audit["results"]}

    dependencies = DEPENDENCIES[1:] if args.snap_report else DEPENDENCIES[:1] if args.eitc_report else DEPENDENCIES
    entrypoints = ENTRYPOINTS[-1:] if args.snap_report else ENTRYPOINTS[:2] if args.eitc_report else ENTRYPOINTS
    sources = (*dependencies, *entrypoints)
    if args.snap_report:
        sources += (SNAP_RELATION, SNAP_COMPOSITION)
    if args.eitc_report:
        sources += (EITC_PAGE_15,)

    with tempfile.TemporaryDirectory(prefix="rulespec-compat-") as work:
        root = Path(work) / "rulespec-us"
        shutil.copytree(args.corpus.resolve(), root)
        for name in sources:
            if digest((root / name).read_bytes()) != audited[name]:
                parser.error(f"source differs from static audit: {name}")
        print(f"Engine: {audit['engine_build']['commit']}")
        print(f"Corpus audit pin: {audit['requested_corpus_pin']}")
        overlay = {}
        original_failures = {}
        if args.eitc_report:
            for name in entrypoints:
                result = compile_entry(engine, root, name, Path(work) / "original.json")
                diagnostic = result.stderr.strip().replace(str(root), "<corpus-copy>")
                if result.returncode != 1 or "declares removed plural `corpus_citation_paths`" not in diagnostic:
                    parser.error(f"unexpected unmigrated EITC diagnostic: {name}: {diagnostic}")
                original_failures[name] = {"exit_code": result.returncode, "diagnostic": diagnostic}
        verification_evidence = {}
        for name in dependencies:
            path = root / name
            raw = path.read_bytes()
            if args.eitc_report:
                candidate, verification_evidence[name], eitc_values = migrate_eitc_verification(
                    raw, (root / EITC_PAGE_15).read_bytes())
            elif args.retain_source_verification:
                candidate, verification_evidence[name] = retain_snap_verification(raw)
            else:
                candidate, count = re.subn(rb"^  source_verification:\n(?:^    .*\n)+", b"", raw, flags=re.M)
                expected = yaml.safe_load(raw)
                del expected["module"]["source_verification"]
                if count != 1 or expected != yaml.safe_load(candidate):
                    parser.error(f"unexpected change outside module.source_verification: {name}")
            path.write_bytes(candidate)
            overlay[name] = digest(candidate)
            print(f"{name}: {digest(raw)} -> {overlay[name]}")
        attempts = []
        for index, name in enumerate((*entrypoints, *entrypoints) if args.snap_report else entrypoints):
            if args.snap_report and index == 1:
                path = root / SNAP_RELATION
                raw = path.read_bytes()
                candidate, slots = type_snap_relation(raw, (root / SNAP_COMPOSITION).read_bytes())
                path.write_bytes(candidate)
                overlay[SNAP_RELATION] = digest(candidate)
                print(f"{SNAP_RELATION}: {digest(raw)} -> {overlay[SNAP_RELATION]}; slots: {slots}")
            artifact = Path(work) / f"probe-{index}.json"
            result = compile_entry(engine, root, name, artifact)
            print(f"{name}: exit {result.returncode}")
            attempt = {"stage": "singular-citation" if args.eitc_report else
                       "metadata-and-slots" if args.snap_report and index else "metadata-only",
                       "entrypoint": name, "exit_code": result.returncode,
                       "diagnostic": result.stderr.strip().replace(str(root), "<corpus-copy>")}
            attempts.append(attempt)
            if result.returncode == 0:
                raw_artifact = artifact.read_bytes()
                program = json.loads(raw_artifact)
                closure = program["source_closure"]
                closure_paths = set()
                for dependency in closure["modules"]:
                    path = dependency["target"].replace("us:", "us/", 1) + ".yaml"
                    expected_hash = overlay[path] if path in overlay else audited[path]
                    if dependency["sha256"] != expected_hash:
                        parser.error(f"closure differs from expected overlay: {path}")
                    if path in closure_paths:
                        parser.error(f"duplicate module in source closure: {path}")
                    closure_paths.add(path)
                print(f"  Artifact v{program['artifact_format_version']}; "
                      f"{len(program['program']['derived'])} derived outputs")
                attempt.update(artifact_format_version=program["artifact_format_version"],
                               artifact_sha256=digest(raw_artifact),
                               derived_outputs=len(program["program"]["derived"]),
                               source_closure=closure)
                if args.eitc_report:
                    dependency, = dependencies
                    expected_root = name.removesuffix(".yaml").replace("us/", "us:", 1)
                    if closure["root"] != expected_root or not {name, dependency} <= closure_paths:
                        parser.error(f"EITC source closure omits entrypoint or migrated dependency: {name}")
                    preimage = "axiom-rules-engine/source-closure/v1\n" + "".join(
                        f"{module['target']}\t{module['sha256']}\n" for module in closure["modules"])
                    if closure["digest"] != f"sha256:{digest(preimage.encode())}":
                        parser.error(f"EITC source closure digest differs: {name}")
                    attempt["compiled_eitc_parameters"] = check_eitc_parameters(program, dependency, eitc_values)
                if args.snap_report and index == 1:
                    if closure_paths != {name, SNAP_RELATION, *dependencies}:
                        parser.error("unexpected SNAP source closure")
                    relation, = (row for row in program["program"]["relations"]
                                 if row["name"] == SNAP_RELATION_ID)
                    if relation["arity"] != len(slots) or relation["slot_entities"] != slots:
                        parser.error("compiled SNAP relation slot order differs from corpus reference")
                    attempt["compiled_relation"] = relation
                    for path, evidence in verification_evidence.items():
                        module_id = path.removesuffix(".yaml").replace("us/", "us:", 1)
                        citation = evidence["retained"]["corpus_citation_path"]
                        rules = [row for kind in ("parameters", "derived") for row in program["program"][kind]
                                 if row["id"].startswith(f"{module_id}#")]
                        if not rules or any(row.get("corpus_citation_path") != citation for row in rules):
                            parser.error(f"compiled rule citation differs from retained source verification: {path}")
                        evidence["compiled_rule_count"] = len(rules)
            else:
                print(attempt["diagnostic"])

        if args.snap_report:
            report = {"engine_build": audit["engine_build"], "corpus_pin": audit["requested_corpus_pin"],
                      "slot_reference": {"path": SNAP_COMPOSITION, "sha256": audited[SNAP_COMPOSITION],
                                         "predicate": "member_of_household", "arguments": slots},
                      "overlay": {path: {"original_sha256": audited[path], "overlay_sha256": sha}
                                  for path, sha in overlay.items()}, "attempts": attempts}
            if args.retain_source_verification:
                report["source_verification"] = verification_evidence
            args.snap_report.write_text(json.dumps(report, indent=2) + "\n")
            if (attempts[0]["exit_code"] != 1 or
                    f"[untyped_relation] relation `{SNAP_RELATION_ID}`" not in attempts[0]["diagnostic"]):
                raise SystemExit("SNAP metadata-only diagnostic differed from the expected relation error")
            if attempts[-1]["exit_code"] != 0:
                raise SystemExit("SNAP overlay did not compile; see probe report")
            if args.snap_artifact:
                args.snap_artifact.write_bytes(raw_artifact)
        if args.eitc_report:
            args.eitc_report.write_text(json.dumps({
                "engine_build": audit["engine_build"], "corpus_pin": audit["requested_corpus_pin"],
                "original_failures": original_failures,
                "overlay": {path: {"original_sha256": audited[path], "overlay_sha256": sha}
                            for path, sha in overlay.items()},
                "source_verification": verification_evidence, "attempts": attempts,
            }, indent=2) + "\n")
            if any(attempt["exit_code"] for attempt in attempts):
                raise SystemExit("EITC overlay did not compile both entrypoints; see probe report")
            if args.eitc_artifact:
                args.eitc_artifact.write_bytes(raw_artifact)
            if args.ctc_artifact:
                args.ctc_artifact.write_bytes((Path(work) / "probe-0.json").read_bytes())


def compile_entry(engine, root, name, artifact):
    return subprocess.run([engine, "compile", "--program", str(root / name),
                           "--rulespec-root", str(root), "--output", str(artifact)],
                          capture_output=True, text=True, timeout=120)


def check_eitc_parameters(program, dependency, expected):
    prefix = dependency.removesuffix(".yaml").replace("us/", "us:", 1) + "#"
    parameters = [row for row in program["program"]["parameters"] if row["id"].startswith(prefix)]
    if {row["id"].removeprefix(prefix) for row in parameters} != set(expected) or len(parameters) != len(expected):
        raise ValueError("compiled EITC parameter IDs differ from the original dependency")
    for parameter in parameters:
        amount = expected[parameter["id"].removeprefix(prefix)]
        values = amount if isinstance(amount, dict) else {0: amount}
        version, = parameter["versions"]
        if (parameter.get("corpus_citation_path") != EITC_CITATIONS[1] or
                version != {"effective_from": "2026-01-01", "values": {
                    str(key): {"kind": "integer", "value": value} for key, value in values.items()}}):
            raise ValueError(f"compiled EITC citation or value differs: {parameter['id']}")
    return [{key: row[key] for key in ("id", "corpus_citation_path", "versions")} for row in parameters]


if __name__ == "__main__":
    main()
