"""Probe compiler admission after removing three legacy metadata blocks in a temporary copy."""

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


def digest(raw):
    return hashlib.sha256(raw).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True, type=Path)
    parser.add_argument("--corpus", required=True, type=Path)
    parser.add_argument("--audit", default=Path("reports/corpus-static.json"), type=Path)
    args = parser.parse_args()
    engine = str(args.engine.resolve())
    audit = json.loads(args.audit.read_text())
    caps = subprocess.check_output([engine, "capabilities"], text=True, timeout=30)
    if json.loads(caps)["engine_build"] != audit["engine_build"]:
        parser.error("engine build differs from static audit")
    audited = {row["source"]: row["sha256"] for row in audit["results"]}

    with tempfile.TemporaryDirectory(prefix="rulespec-compat-") as work:
        root = Path(work) / "rulespec-us"
        shutil.copytree(args.corpus.resolve(), root)
        for name in (*DEPENDENCIES, *ENTRYPOINTS):
            if digest((root / name).read_bytes()) != audited[name]:
                parser.error(f"source differs from static audit: {name}")
        print(f"Engine: {audit['engine_build']['commit']}")
        print(f"Corpus audit pin: {audit['requested_corpus_pin']}")
        for name in DEPENDENCIES:
            path = root / name
            raw = path.read_bytes()
            candidate, count = re.subn(rb"^  source_verification:\n(?:^    .*\n)+", b"", raw, flags=re.M)
            expected = yaml.safe_load(raw)
            del expected["module"]["source_verification"]
            if count != 1 or expected != yaml.safe_load(candidate):
                parser.error(f"unexpected change outside module.source_verification: {name}")
            path.write_bytes(candidate)
            print(f"{name}: {digest(raw)} -> {digest(candidate)}")
        for index, name in enumerate(ENTRYPOINTS):
            artifact = Path(work) / f"probe-{index}.json"
            result = subprocess.run([engine, "compile", "--program", str(root / name),
                                     "--rulespec-root", str(root), "--output", str(artifact)],
                                    capture_output=True, text=True, timeout=120)
            print(f"{name}: exit {result.returncode}")
            if result.returncode == 0:
                program = json.loads(artifact.read_bytes())
                for dependency in program["source_closure"]["modules"]:
                    path = dependency["target"].replace("us:", "us/", 1) + ".yaml"
                    expected_hash = digest((root / path).read_bytes()) if path in DEPENDENCIES else audited[path]
                    if dependency["sha256"] != expected_hash:
                        parser.error(f"closure differs from expected overlay: {path}")
                print(f"  Artifact v{program['artifact_format_version']}; "
                      f"{len(program['program']['derived'])} derived outputs")
            else:
                print(result.stderr.strip().replace(str(root), "<corpus-copy>"))


if __name__ == "__main__":
    main()
