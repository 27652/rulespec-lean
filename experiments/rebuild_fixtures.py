"""Recompile retained legal/fault sources using the pinned official engine."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True, type=Path)
    args = parser.parse_args()
    engine = args.engine.resolve()
    pin = json.loads(Path("fixtures/upstream-pin.json").read_text())
    caps = json.loads(subprocess.run([str(engine), "capabilities"], capture_output=True,
                                    text=True, check=True, timeout=30).stdout)
    if caps["engine_build"] != {"commit": pin["commit"], "dirty": False}:
        parser.error("clean pinned engine required")
    legal_pin = json.loads(Path("fixtures/legal-pin.json").read_text())
    source = Path("fixtures/legal-3403.rules.yaml")
    if hashlib.sha256(source.read_bytes()).hexdigest() != legal_pin["source_sha256"]:
        parser.error("legal source checksum mismatch")
    for stem, relative in [("legal-3403", legal_pin["source_path"]),
                           ("faults", "us/policies/faults/rules.yaml"),
                           ("decimal-dependency", "us/policies/decimal-dependency/rules.yaml"),
                           ("selected-year", "us/policies/selected-year/rules.yaml"),
                           ("direct-count", "us/policies/direct-count/rules.yaml")]:
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / "rulespec-us"
            module = root / relative
            module.parent.mkdir(parents=True)
            shutil.copyfile(f"fixtures/{stem}.rules.yaml", module)
            subprocess.run([str(engine), "compile", "--program", str(module),
                            "--rulespec-root", str(root), "--output",
                            str(Path(f"fixtures/{stem}.artifact.json").resolve())],
                           check=True, timeout=120)


if __name__ == "__main__":
    main()
