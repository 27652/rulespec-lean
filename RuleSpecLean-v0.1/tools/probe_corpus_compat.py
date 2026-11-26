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


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True, type=Path)
    parser.add_argument("--corpus", required=True, type=Path)
    parser.add_argument("--audit", default=Path("reports/corpus-static.json"), type=Path)
    parser.add_argument("--snap-report", type=Path,
                        help="Probe SNAP only, adding the corpus-defined relation slots in a second stage")
    args = parser.parse_args()
    engine = str(args.engine.resolve())
    audit = json.loads(args.audit.read_text())
    caps = subprocess.check_output([engine, "capabilities"], text=True, timeout=30)
    if json.loads(caps)["engine_build"] != audit["engine_build"]:
        parser.error("engine build differs from static audit")
    audited = {row["source"]: row["sha256"] for row in audit["results"]}

    dependencies = DEPENDENCIES[1:] if args.snap_report else DEPENDENCIES
    entrypoints = ENTRYPOINTS[-1:] if args.snap_report else ENTRYPOINTS
    sources = (*dependencies, *entrypoints)
    if args.snap_report:
        sources += (SNAP_RELATION, SNAP_COMPOSITION)

    with tempfile.TemporaryDirectory(prefix="rulespec-compat-") as work:
        root = Path(work) / "rulespec-us"
        shutil.copytree(args.corpus.resolve(), root)
        for name in sources:
            if digest((root / name).read_bytes()) != audited[name]:
                parser.error(f"source differs from static audit: {name}")
        print(f"Engine: {audit['engine_build']['commit']}")
        print(f"Corpus audit pin: {audit['requested_corpus_pin']}")
        overlay = {}
        for name in dependencies:
            path = root / name
            raw = path.read_bytes()
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
                composition = yaml.safe_load((root / SNAP_COMPOSITION).read_bytes())
                reference, = (rule["data_relation"] for rule in composition["rules"]
                              if rule["kind"] == "data_relation" and rule["name"] == "member_of_household")
                slots = reference["arguments"]
                path = root / SNAP_RELATION
                raw = path.read_bytes()
                expected = yaml.safe_load(raw)
                relation, = (rule["data_relation"] for rule in expected["rules"]
                             if rule["kind"] == "data_relation" and rule["name"] == "member_of_household")
                if reference["arity"] != relation["arity"] or relation != {"arity": 2} or slots != ["Person", "Household"]:
                    parser.error("unexpected SNAP relation signature")
                relation["arguments"] = slots
                candidate = raw.replace(b"      arity: 2\n", b"      arity: 2\n      arguments: [Person, Household]\n", 1)
                if yaml.safe_load(candidate) != expected:
                    parser.error("unexpected changes outside the SNAP relation declaration")
                path.write_bytes(candidate)
                overlay[SNAP_RELATION] = digest(candidate)
                print(f"{SNAP_RELATION}: {digest(raw)} -> {overlay[SNAP_RELATION]}; slots: {slots}")
            artifact = Path(work) / f"probe-{index}.json"
            result = subprocess.run([engine, "compile", "--program", str(root / name),
                                     "--rulespec-root", str(root), "--output", str(artifact)],
                                    capture_output=True, text=True, timeout=120)
            print(f"{name}: exit {result.returncode}")
            attempt = {"stage": "metadata-and-slots" if args.snap_report and index else "metadata-only",
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
                if args.snap_report and index == 1:
                    if closure_paths != {name, SNAP_RELATION, *dependencies}:
                        parser.error("unexpected SNAP source closure")
                    relation, = (row for row in program["program"]["relations"]
                                 if row["name"] == SNAP_RELATION_ID)
                    if relation["arity"] != len(slots) or relation["slot_entities"] != slots:
                        parser.error("compiled SNAP relation slot order differs from corpus reference")
                    attempt["compiled_relation"] = relation
            else:
                print(attempt["diagnostic"])

        if args.snap_report:
            report = {"engine_build": audit["engine_build"], "corpus_pin": audit["requested_corpus_pin"],
                      "slot_reference": {"path": SNAP_COMPOSITION, "sha256": audited[SNAP_COMPOSITION],
                                         "predicate": "member_of_household", "arguments": slots},
                      "overlay": {path: {"original_sha256": audited[path], "overlay_sha256": sha}
                                  for path, sha in overlay.items()}, "attempts": attempts}
            args.snap_report.write_text(json.dumps(report, indent=2) + "\n")
            if (attempts[0]["exit_code"] != 1 or
                    f"[untyped_relation] relation `{SNAP_RELATION_ID}`" not in attempts[0]["diagnostic"]):
                raise SystemExit("SNAP metadata-only diagnostic differed from the expected relation error")
            if attempts[-1]["exit_code"] != 0:
                raise SystemExit("SNAP overlay did not compile; see probe report")


if __name__ == "__main__":
    main()
