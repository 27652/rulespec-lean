"""Compile the pinned upstream example and create deterministic scalar cases.

Use a binary built from the commit in fixtures/upstream-pin.json. The local
rulespec-us directory is only a compiler namespace fixture, NOT a corpus clone.
"""
import argparse
import hashlib
import json
from pathlib import Path
import random
import shutil
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", required=True, type=Path)
    args = parser.parse_args()
    engine = args.engine.resolve()
    source = Path("fixtures/upstream-flat-tax.rules.yaml")
    pin = json.loads(Path("fixtures/upstream-pin.json").read_text())
    capabilities = subprocess.run([str(engine), "capabilities"], capture_output=True,
                                  text=True, check=True, timeout=30)
    build = json.loads(capabilities.stdout)["engine_build"]
    if build.get("commit") != pin["commit"] or build.get("dirty") is not False:
        parser.error("binary must report the pinned commit and dirty=false; see build.rs upstream")
    if hashlib.sha256(source.read_bytes()).hexdigest() != pin["source_sha256"]:
        parser.error("upstream source checksum mismatch")
    artifact_path = Path("fixtures/upstream-flat-tax.artifact.json").resolve()
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp) / "rulespec-us"
        module = root / "us/policies/flat-tax/rules.yaml"
        module.parent.mkdir(parents=True)
        shutil.copyfile(source, module)
        subprocess.run([str(engine), "compile", "--program", str(module),
                        "--rulespec-root", str(root), "--output", str(artifact_path)],
                       check=True, timeout=120)
    artifact = json.loads(artifact_path.read_text())
    rules = artifact["program"]["derived"]
    rule = next(r for r in rules if r.get("id") == "us:policies/flat-tax/rules#income_tax")
    catalog = artifact["metadata"]["input_catalog"]
    slot = next(row for row in catalog if row["slot"] == "income")
    rng = random.Random(20261126)
    incomes = [0, 999, 1000, 1001, 2999, 3000, 3001]
    incomes += [rng.randrange(0, 1000000) for _ in range(100)]
    cases = []
    for i, income in enumerate(incomes):
        value = {"kind": "integer", "value": income}
        cases.append({"name": f"income-{i}-{income}", "as_of": "2025-01-01",
                      "rule": rule["name"], "public_output": rule["id"],
                      "env": {slot["slot"]: value}, "request": {
                          "mode": "explain", "dataset": {"inputs": [{
                              "name": slot["canonical_request_name"], "entity": "Person",
                              "entity_id": "person:1", "interval": {
                                  "start": "2025-01-01", "end": "2026-01-01"},
                              "value": value}], "relations": []},
                          "queries": [{"entity_id": "person:1", "period": {
                              "period_kind": "tax_year", "start": "2025-01-01",
                              "end": "2026-01-01"}, "outputs": [rule["id"]]}]}})
    Path("fixtures/upstream-flat-tax.cases.json").write_text(json.dumps(cases, indent=2) + "\n")
    print(f"Prepared {len(cases)} cases; run tools.check_reference next")


if __name__ == "__main__":
    main()
