#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

case ${1:-offline} in
  offline|upstream) mode=${1:-offline} ;;
  *) echo 'Usage: bash scripts/verify.sh [offline|upstream]' >&2; exit 2 ;;
esac

PYTHON=$(command -v "${PYTHON:-python3}")
LAKE=$(command -v "${LAKE:-lake}")
repo=$PWD
work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT

if [[ $mode == offline ]]; then
  "$PYTHON" -m unittest discover -v
  "$PYTHON" -m tools.compile_ir fixtures/ctc-like.artifact.json --as-of 2025-01-01 --output credit \
    --lean "$work/Generated.lean" --manifest "$work/generated-manifest.json"
  cmp RuleSpecLean/Generated.lean "$work/Generated.lean"
  cmp generated-manifest.json "$work/generated-manifest.json"

  targets=(RuleSpecLean RuleSpecLean.Tests RuleSpecLean.Proofs.ProofAudit)
  for test in RuleSpecLean/*Tests.lean; do
    targets+=("${test%.lean}")
  done
  "$LAKE" build "${targets[@]//\//.}"
  "$LAKE" env lean RuleSpecLean/Proofs/ProofAudit.lean | tee "$work/proof-axioms.log"
  if grep -q 'sorryAx' "$work/proof-axioms.log"; then exit 1; fi
  exit 0
fi

: "${ENGINE:?Set ENGINE to the pinned Rust binary}"
: "${ENGINE_SOURCE:?Set ENGINE_SOURCE to the pinned engine source directory}"
: "${CORPUS:?Set CORPUS to the pinned rulespec-us directory}"
: "${ORACLE:?Set ORACLE to the built Decimal oracle}"
RUSTC=$(command -v "${RUSTC:-rustc}")
ENGINE=$(realpath "$ENGINE")
ENGINE_SOURCE=$(realpath "$ENGINE_SOURCE")
CORPUS=$(realpath "$CORPUS")
ORACLE=$(realpath "$ORACLE")
EVIDENCE=$(realpath -m "${EVIDENCE:-.verification/upstream}")
mkdir -p "$EVIDENCE"

# Some experiment modules write generated fixtures or reports in place. Run
# them in a private copy so the retained research baseline stays untouched.
mkdir "$work/project"
cp -R RuleSpecLean RuleSpecLean.lean fixtures reports tools tests \
  lakefile.toml lake-manifest.json lean-toolchain "$work/project/"
mkdir "$work/project/experiments"
cp experiments/*.py "$work/project/experiments/"
cd "$work/project"

run() {
  local module=$1
  shift
  "$PYTHON" -m "experiments.$module" "$@"
}
engine_args=(--engine "$ENGINE" --lake "$LAKE")
audit=$EVIDENCE/corpus-static.json
corpus_args=("${engine_args[@]}" --corpus "$CORPUS" --audit "$audit")
baseline=reports/v0.1

{
  run prepare_reference --engine "$ENGINE"
  run rebuild_fixtures --engine "$ENGINE"
  for fixture in fixtures/*.artifact.json fixtures/*.cases.json; do
    cmp "$repo/$fixture" "$fixture"
  done
  run check_reference fixtures/upstream-flat-tax.artifact.json fixtures/upstream-flat-tax.cases.json \
    "${engine_args[@]}" --report "$EVIDENCE/reference.json"
  run check_faults fixtures/faults.artifact.json fixtures/faults.cases.json "${engine_args[@]}"
  run check_reference fixtures/legal-3403.artifact.json fixtures/legal-3403.cases.json "${engine_args[@]}" \
    --lean RuleSpecLean/Legal3403.lean --report "$EVIDENCE/legal-3403.json"
  "$LAKE" build RuleSpecLean.Proofs.ProofAudit
  "$LAKE" env lean RuleSpecLean/Proofs/ProofAudit.lean | tee "$EVIDENCE/proof-axioms.log"
  if grep -q 'sorryAx' "$EVIDENCE/proof-axioms.log"; then exit 1; fi
  run check_3403_rust_model "${engine_args[@]}" --report "$EVIDENCE/legal-3403-rust-model.json"
  run check_3403_rust_source --source "$ENGINE_SOURCE" --rustc "$RUSTC" --lake "$LAKE" \
    --report "$EVIDENCE/legal-3403-rust-source.json"
  cmp "$baseline/proofs/legal-3403-rust-model.json" "$EVIDENCE/legal-3403-rust-model.json"
  cmp "$baseline/proofs/legal-3403-rust-source.json" "$EVIDENCE/legal-3403-rust-source.json"

  run check_decimal --oracle "$ORACLE" --lake "$LAKE"
  run check_arithmetic --oracle "$ORACLE" --lake "$LAKE"
  run check_arithmetic --extended --oracle "$ORACLE" | tee "$EVIDENCE/decimal-arithmetic-extended.log"
  run check_decimal_dependency "${engine_args[@]}"
  run check_decimal_dependency --flat-tax "${engine_args[@]}"
  run check_selected_year "${engine_args[@]}"
  run check_input_defaults "${engine_args[@]}"
  run check_direct_count "${engine_args[@]}"
  cp "$baseline/interop/faults.json" "$baseline/decimal/"*.json "$baseline/binding/"*.json "$EVIDENCE/"

  run audit_corpus --engine "$ENGINE" --corpus "$CORPUS" --report "$audit"
  cmp "$baseline/corpus/corpus-static.json" "$audit"
  run check_legal_components "${corpus_args[@]}"
  cp "$baseline/legal/"{ctc-magi,ctc-phaseout,ctc-after-advance,ctc-refundable-cap,eitc-earned-income,eitc-section112-election,snap-net-income-limit,capital-loss-match}.json "$EVIDENCE/"
  run replay_corpus "${corpus_args[@]}" --baseline "$baseline/corpus/corpus-replay.json" \
    --report "$EVIDENCE/corpus-replay.json"
  cmp "$baseline/corpus/corpus-replay.json" "$EVIDENCE/corpus-replay.json"
  run check_corpus_patch "${corpus_args[@]}" --report "$EVIDENCE/corpus-patch-validation.json"
  cmp "$baseline/corpus/corpus-patch-validation.json" "$EVIDENCE/corpus-patch-validation.json"
  # The validator checks these retained replay files byte-for-byte against
  # fresh outputs. Include them alongside their recorded hashes.
  for replay in ctc-refundable-credit ctc-social-security-excess \
      ctc-section112-refundable-credit ctc-section911-refundable-credit \
      eitc-final-credit eitc-investment-income-denial snap-allotment snap-other-outputs; do
    cp "$baseline/legal/$replay.json" "$EVIDENCE/"
  done

  # The patch validator above already replays the four CTC cases, both EITC
  # cases and all §273.10 expectations. Membership is a separate output.
  run check_snap_membership --retain-source-verification "${corpus_args[@]}" \
    --report "$EVIDENCE/snap-membership.json" --lean "$work/SNAPMembershipTests.lean"
  cmp RuleSpecLean/SNAPMembershipTests.lean "$work/SNAPMembershipTests.lean"
  cmp "$baseline/legal/snap-membership.json" "$EVIDENCE/snap-membership.json"

  "$PYTHON" -m unittest discover -v
} 2>&1 | tee "$EVIDENCE/integration.log"
