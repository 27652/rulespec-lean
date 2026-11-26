import RuleSpecLean.Legal3403Artifact
import RuleSpecLean.Decimal

#print axioms RuleSpecLean.ScalarPreservation.lowering_preserves_result
#print axioms RuleSpecLean.ScalarPreservation.lookup_preserves_result
#print axioms RuleSpecLean.ScalarPreservation.recognize_sound
#print axioms RuleSpecLean.ScalarPreservation.recognized_target_preserves_result
#print axioms RuleSpecLean.Legal3403Preservation.generated_preserves_result
#print axioms RuleSpecLean.VersionSelection.select_sound
#print axioms RuleSpecLean.VersionSelection.select_none_iff
#print axioms RuleSpecLean.DecimalModel.round_result_scale
#print axioms RuleSpecLean.DecimalModel.round_keeps_value_at_or_above_scale
#print axioms RuleSpecLean.VersionSelection.select_append_latest
#print axioms RuleSpecLean.VersionSelection.select_mapBody
#print axioms RuleSpecLean.Legal3403Preservation.versioned_lowering_preserves_result
#print axioms RuleSpecLean.Legal3403Preservation.generated_preserves_active_version
#print axioms RuleSpecLean.eval_noMatch
#print axioms RuleSpecLean.eval_emptyLookup
#print axioms RuleSpecLean.andShortCircuit
#print axioms RuleSpecLean.orShortCircuit
#print axioms RuleSpecLean.andUnknown
#print axioms RuleSpecLean.orUnknown
#print axioms RuleSpecLean.lazyUnknown
#print axioms RuleSpecLean.DecimalModel.eval_noMatch
#print axioms RuleSpecLean.Legal3403Preservation.no_source_version_before_first_day
#print axioms RuleSpecLean.Legal3403Preservation.snapshot_target_preserves_result
#print axioms RuleSpecLean.Legal3403Artifact.matches_retained_source_sound
#print axioms RuleSpecLean.Legal3403Artifact.decoded_artifact_preserves_result
#print axioms RuleSpecLean.Legal3403Artifact.retained_artifact_decodes
#print axioms RuleSpecLean.Legal3403Artifact.retained_artifact_preserves_result

-- The general implications must stay independent of native evaluation.
-- Only the concrete fixture certificate and its corollary may use it.
run_cmd do
  let logical := [``propext, ``Classical.choice, ``Quot.sound]
  for theoremName in [``RuleSpecLean.Legal3403Artifact.matches_retained_source_sound,
      ``RuleSpecLean.Legal3403Artifact.decoded_artifact_preserves_result] do
    for axiomName in ← Lean.collectAxioms theoremName do
      unless logical.contains axiomName do
        throwError "unexpected axiom {axiomName} in {theoremName}"
  for theoremName in [``RuleSpecLean.Legal3403Artifact.retained_artifact_decodes,
      ``RuleSpecLean.Legal3403Artifact.retained_artifact_preserves_result] do
    for axiomName in ← Lean.collectAxioms theoremName do
      unless (``Lean.ofReduceBool :: ``Lean.trustCompiler :: logical).contains axiomName do
        throwError "unexpected axiom {axiomName} in {theoremName}"
