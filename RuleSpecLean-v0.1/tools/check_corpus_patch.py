"""Check the review patch against pinned sources and replay its compiled artifacts."""

import argparse
import difflib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

from tools.check_eitc_final import CASE, CTC_CASE, CTC_SS_CASE, DENIAL_CASE
from tools.probe_corpus_compat import (
    DEPENDENCIES, EITC_PAGE_15, ENTRYPOINTS, SNAP_COMPOSITION, SNAP_RELATION,
    compile_entry, digest, migrate_eitc_verification, retain_snap_verification, type_snap_relation,
)

PATCH = Path("reports/corpus-compat.patch")
CREDIT_PROBE = Path("reports/eitc-citation-probe.json")
SNAP_PROBE = Path("reports/snap-membership.json")


def expected_changes(corpus):
    def read(name):
        return (corpus / name).read_bytes()

    eitc, deductions, allotments = DEPENDENCIES
    return {
        eitc: migrate_eitc_verification(read(eitc), read(EITC_PAGE_15))[0],
        deductions: retain_snap_verification(read(deductions))[0],
        allotments: retain_snap_verification(read(allotments))[0],
        SNAP_RELATION: type_snap_relation(read(SNAP_RELATION), read(SNAP_COMPOSITION))[0],
    }


def patch_text(corpus, changes):
    lines = []
    for name, candidate in sorted(changes.items()):
        lines.extend(difflib.unified_diff((corpus / name).read_text().splitlines(keepends=True),
                                          candidate.decode().splitlines(keepends=True),
                                          fromfile=f"a/{name}", tofile=f"b/{name}"))
    # Git accepts bare empty context lines; avoid whitespace-only lines in the tracked patch.
    return "".join("\n" if line == " \n" else line for line in lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for option in ("engine", "lake", "corpus", "report"):
        parser.add_argument(f"--{option}", type=Path, required=True)
    parser.add_argument("--audit", type=Path, default=Path("reports/corpus-static.json"))
    args = parser.parse_args()
    engine = str(args.engine.resolve())
    audit = json.loads(args.audit.read_bytes())
    build = json.loads(subprocess.check_output([engine, "capabilities"], timeout=30))["engine_build"]
    if build != audit["engine_build"]:
        raise ValueError("engine build differs from static audit")
    hashes = {row["source"]: row["sha256"] for row in audit["results"]}
    paths = (*ENTRYPOINTS, *DEPENDENCIES, SNAP_RELATION, SNAP_COMPOSITION, EITC_PAGE_15)
    for name in paths:
        if digest((args.corpus / name).read_bytes()) != hashes[name]:
            raise ValueError(f"source differs from static audit: {name}")
    changes = expected_changes(args.corpus)
    patch = PATCH.read_bytes()
    if patch != patch_text(args.corpus, changes).encode():
        raise ValueError("review patch differs from the validated source transformations")
    credit = json.loads(CREDIT_PROBE.read_bytes())
    snap = json.loads(SNAP_PROBE.read_bytes())["compatibility_probe"]
    attempts = {row["entrypoint"]: row for row in (*credit["attempts"], snap["attempts"][-1])}
    report = {"engine_build": build, "corpus_pin": audit["requested_corpus_pin"],
              "patch_sha256": digest(patch),
              "patched_files": {name: {"original_sha256": hashes[name], "patched_sha256": digest(raw)}
                                for name, raw in sorted(changes.items())},
              "entries": {}, "replays": {}}

    with tempfile.TemporaryDirectory(prefix="rulespec-review-patch-") as work:
        directory = Path(work)
        root = directory / "rulespec-us"
        shutil.copytree(args.corpus.resolve(), root)
        for name in ENTRYPOINTS:
            result = compile_entry(engine, root, name, directory / "unpatched.json")
            diagnostic = result.stderr.strip().replace(str(root), "<corpus-copy>")
            first_error = ("unknown field `values`" if name == ENTRYPOINTS[-1]
                           else "declares removed plural `corpus_citation_paths`")
            if result.returncode != 1 or first_error not in diagnostic:
                raise ValueError(f"unexpected baseline compile result for {name}: {diagnostic}")
            report["entries"][name] = {"unpatched": {"exit_code": result.returncode, "diagnostic": diagnostic}}
            print(f"{name}: unpatched exit {result.returncode} ({first_error})", flush=True)

        # Run outside any repository so git apply resolves the paths relative to the corpus copy.
        for flags in (["--check"], []):
            subprocess.run(["git", "apply", *flags, str(PATCH.resolve())], cwd=root, check=True, timeout=30)
        for name, candidate in changes.items():
            if (root / name).read_bytes() != candidate:
                raise ValueError(f"applied patch differs from the validated transformation: {name}")

        artifacts = []
        for index, name in enumerate(ENTRYPOINTS):
            artifact = directory / f"entry-{index}.json"
            result = compile_entry(engine, root, name, artifact)
            if result.returncode != 0:
                raise ValueError(f"patched compile failed for {name}: {result.stderr.strip()}")
            evidence = attempts[name]
            raw = artifact.read_bytes()
            if digest(raw) != evidence["artifact_sha256"]:
                raise ValueError(f"patched artifact differs from the previously verified artifact: {name}")
            for module in json.loads(raw)["source_closure"]["modules"]:
                path = module["target"].replace("us:", "us/", 1) + ".yaml"
                expected = digest(changes[path]) if path in changes else hashes[path]
                if digest((root / path).read_bytes()) != expected or module["sha256"] != expected:
                    raise ValueError(f"patched source closure differs for {path}")
            artifacts.append(artifact)
            report["entries"][name]["patched"] = {key: evidence[key] for key in (
                "exit_code", "artifact_format_version", "artifact_sha256", "derived_outputs", "source_closure")}
            print(f"{name}: patched exit 0; {evidence['derived_outputs']} derived outputs; "
                  f"{len(evidence['source_closure']['modules'])} closure modules verified", flush=True)

        snap_probe = directory / "snap-probe.json"
        snap_probe.write_text(json.dumps(snap))
        suites = (
            (0, ["--case", CTC_CASE], "ctc-refundable-credit", "CTCRefundableCreditTests"),
            (0, ["--case", CTC_SS_CASE], "ctc-social-security-excess", "CTCSocialSecurityExcessTests"),
            (1, ["--case", CASE], "eitc-final-credit", "EITCFinalCreditTests"),
            (1, ["--case", DENIAL_CASE], "eitc-investment-income-denial", "EITCInvestmentIncomeDenialTests"),
            (2, ["--allotment"], "snap-allotment", "SNAPAllotmentTests"),
            (2, ["--other-outputs"], "snap-other-outputs", "SNAPPublishedOutputsTests"),
        )
        for index, options, name, module in suites:
            tool = "check_snap_membership" if index == 2 else "check_eitc_final"
            probe = snap_probe if index == 2 else CREDIT_PROBE
            replay = directory / f"{name}.json"
            lean = directory / f"{module}.lean"
            subprocess.run([sys.executable, "-m", f"tools.{tool}", *options, "--engine", engine,
                            "--lake", str(args.lake), "--audit", str(args.audit), "--corpus", str(root),
                            "--verified-artifact", str(artifacts[index]), str(probe),
                            "--report", str(replay), "--lean", str(lean)], check=True, timeout=300)
            reference = Path("reports") / replay.name
            raw_replay = replay.read_bytes()
            if raw_replay != reference.read_bytes() or lean.read_bytes() != (Path("RuleSpecLean") / lean.name).read_bytes():
                raise ValueError(f"patched replay differs from checked-in evidence: {name}")
            report["replays"][name] = {"public_expectations_passed": json.loads(raw_replay)["lean_guards_passed"],
                                       "report": str(reference), "report_sha256": digest(raw_replay)}
    for name in paths:
        if digest((args.corpus / name).read_bytes()) != hashes[name]:
            raise ValueError(f"pinned source changed during patch verification: {name}")
    args.report.write_text(json.dumps(report, indent=2) + "\n")


if __name__ == "__main__":
    main()
