import RuleSpecLean.Legal3403Binding

namespace RuleSpecLean.Legal3403RustModel

open Lean Legal3403Artifact Legal3403Binding Legal3403Preservation ScalarPreservation

/-- Restricted transcription of the pinned Rust Explain path. Dates and
    decimal values have already been encoded; the CLI has resolved the input
    legal ID to its slot. There is exactly one record and one formula version. -/
structure Record where
  slotName : String
  employer : String
  startDay : Int
  endDay : Int
  coefficient : Int

/-- `Engine::lookup_input` first indexes by (slot, employer), then takes
    the first record whose interval contains the whole query period.
    Sorting and conflict detection are vacuous for one record. -/
def lookupSingleton (record : Record) (name employer : String) (startDay endDay : Int) : Option Int :=
  if record.slotName = name ∧ record.employer = employer ∧
      record.startDay ≤ startDay ∧ endDay ≤ record.endDay then
    some record.coefficient
  else none

def requestRecord (request : AnnualRequest) : Record :=
  ⟨slot, request.employer, jan1 request.year, jan1 (request.year + 1), request.dollars * scale⟩

def bindSingleton (request : AnnualRequest) : Option (List (String × Int) × Int) :=
  (lookupSingleton (requestRecord request) slot request.employer
    (jan1 request.year) (jan1 (request.year + 1))).map
      (fun coefficient => ([(slot, coefficient)], jan1 request.year))

theorem rust_binding_corresponds (request : AnnualRequest) (valid : request.valid) :
    bindSingleton request = bind request := by
  rw [bind_corresponds request valid]
  simp [bindSingleton, requestRecord, lookupSingleton]

/-- `Derived::semantics_at` calls `version_at(period.start)` for a nonempty
    version list. Filtering by the inclusive applicability test and taking
    the maximum on a singleton returns that row or no row. -/
def versionSingleton (startDay : Int) (version : VersionSelection.Version α) :
    Option (VersionSelection.Version α) :=
  ([version].filter fun row =>
    decide (row.firstDay ≤ startDay) &&
      (row.lastDay.map fun last => decide (startDay ≤ last)).getD true).head?

theorem rust_version_corresponds (startDay : Int) (version : VersionSelection.Version α) :
    versionSingleton startDay version = VersionSelection.select startDay [version] := by
  unfold versionSingleton
  by_cases active : VersionSelection.active startDay version = true <;>
    simp [VersionSelection.select, VersionSelection.active] at active ⊢

/-- Recorded semantics of the two Rust steps followed by the independent
    source evaluator. This does not translate or verify the Rust evaluator. -/
def evalRustModel (request : AnnualRequest) : Except Fault Value :=
  match bindSingleton request with
  | none => .error .missingInput
  | some (env, startDay) =>
    ((versionSingleton startDay ⟨firstDay, none, source⟩).map
      (fun version => encode (evaluate env version.body))).getD (.error .missingVersion)

theorem rust_model_matches_wire (rawArtifact : String) (wire : Json) (request : AnnualRequest)
    (requestDecoded : decodeRequest wire = .ok request)
    (artifactDecoded : decode rawArtifact = .ok sourceVersions) :
    evalWireRequest rawArtifact wire = .ok (evalRustModel request) := by
  have valid := decoded_request_valid wire request requestDecoded
  rw [wire_request_preserves_result _ _ _ requestDecoded artifactDecoded]
  unfold evalRustModel
  rw [rust_binding_corresponds request valid, bind_corresponds request valid]
  dsimp only
  rw [rust_version_corresponds, snapshot_target_preserves_result]
  rfl

end RuleSpecLean.Legal3403RustModel
