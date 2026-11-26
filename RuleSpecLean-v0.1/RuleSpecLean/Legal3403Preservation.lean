import RuleSpecLean.Legal3403
import RuleSpecLean.ScalarPreservation
import RuleSpecLean.VersionSelection

namespace RuleSpecLean.Legal3403Preservation

open ScalarPreservation

/-- Lowering a version list and selecting on the target side preserves the
    selected source result, including missing versions and evaluation faults. -/
theorem versioned_lowering_preserves_result (env : List (String × Int)) (day : Int)
    (versions : List (VersionSelection.Version Source)) :
    ((VersionSelection.select day (versions.map (VersionSelection.mapBody lower))).map
      (fun v => eval (encodeEnv env) v.body)).getD (.error .missingVersion) =
    ((VersionSelection.select day versions).map
      (fun v => encode (evaluate env v.body))).getD (.error .missingVersion) := by
  rw [VersionSelection.select_mapBody]
  cases VersionSelection.select day versions with
  | none => rfl
  | some v => exact lowering_preserves_result env v.body

/-- Independent coefficient-level source term for the retained §3403 output. -/
def source : Source :=
  .maximum (.normalize (.literal 0))
    (.normalize (.input "tax_required_to_be_deducted_and_withheld_under_this_chapter"))

/-- Checks the actual module emitted from the pinned artifact, then transfers
the preservation theorem to every prebound decimal environment. -/
theorem generated_preserves_result (env : List (String × Int)) :
    eval (encodeEnv env) Generated.output_0 = encode (evaluate env source) :=
  recognized_target_preserves_result env Generated.output_0 source rfl

/-- Gregorian ordinal for the first day of the retained artifact's sole
    withholding-payment formula version (1990-01-01). -/
def firstDay : Int := 726468

def sourceVersions : List (VersionSelection.Version Source) := [⟨firstDay, none, source⟩]

/-- The generated output agrees with the selected source formula on any day
    in this version. Date encoding and source extraction are separate checks. -/
theorem generated_preserves_active_version (env : List (String × Int)) (day : Int)
    (active : firstDay ≤ day) :
    (VersionSelection.select day sourceVersions).map (fun v => encode (evaluate env v.body)) =
      some (eval (encodeEnv env) Generated.output_0) := by
  simp [sourceVersions, VersionSelection.select, VersionSelection.active, active, generated_preserves_result]

theorem no_source_version_before_first_day (day : Int) (early : day < firstDay) :
    VersionSelection.select day sourceVersions = none := by
  simp [sourceVersions, VersionSelection.select, VersionSelection.active, Int.not_le.mpr early]

/-- A snapshot wrapper for the retained output, over already encoded dates. -/
def snapshotTarget (day : Int) : Expr :=
  if firstDay ≤ day then Generated.output_0 else .fault .missingVersion

theorem snapshot_target_preserves_result (env : List (String × Int)) (day : Int) :
    eval (encodeEnv env) (snapshotTarget day) =
      ((VersionSelection.select day sourceVersions).map
        (fun v => encode (evaluate env v.body))).getD (.error .missingVersion) := by
  by_cases h : firstDay ≤ day
  · simp [snapshotTarget, h, generated_preserves_active_version env day h]
  · simp [snapshotTarget, h, no_source_version_before_first_day day (Int.lt_of_not_ge h), eval]

end RuleSpecLean.Legal3403Preservation
