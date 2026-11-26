import RuleSpecLean.Legal3403RustModel

namespace RuleSpecLean.Legal3403RustSource

open Lean Legal3403Artifact Legal3403Binding Legal3403Preservation Legal3403RustModel ScalarPreservation

/-- Singleton specialization of the pinned Rust index lookup followed by
    `flat_map`, `filter` and `next`. After `next` there are no tied records. -/
def inputBody (record : Record) (name employer : String) (startDay endDay : Int) : Option Int :=
  let bucket := if (record.slotName, record.employer) = (name, employer) then [record] else []
  ((bucket.filter fun row => decide (row.startDay ≤ startDay) && decide (endDay ≤ row.endDay)).head?).map
    Record.coefficient

theorem input_body_matches_model (record : Record) (name employer : String) (startDay endDay : Int) :
    inputBody record name employer startDay endDay = lookupSingleton record name employer startDay endDay := by
  by_cases nameMatches : record.slotName = name <;> by_cases employerMatches : record.employer = employer <;>
    by_cases startCovers : record.startDay ≤ startDay <;> by_cases endCovers : endDay ≤ record.endDay <;>
    simp [inputBody, lookupSingleton, nameMatches, employerMatches, startCovers, endCovers]

/-- The Rust selector enumerates the singleton before filtering. Its maximum
    by start is `head?` on a list with at most one entry. The index is discarded
    by `semantics_at`, which passes the query start, independent of its end. -/
def versionBody (startDay : Int) (version : VersionSelection.Version α) :
    Option (Nat × VersionSelection.Version α) :=
  ([(0, version)].filter fun (_, row) => decide (row.firstDay ≤ startDay) &&
    (row.lastDay.map fun last => decide (startDay ≤ last)).getD true).head?

theorem version_body_matches_model (startDay : Int) (version : VersionSelection.Version α) :
    (versionBody startDay version).map Prod.snd = versionSingleton startDay version := by
  by_cases active : VersionSelection.active startDay version = true <;>
    simp [versionBody, versionSingleton, VersionSelection.active] at active ⊢

/-- Evaluate with the two singleton source transcriptions and the independent
    scalar evaluator. No Rust JSON decoding or Decimal evaluation is modeled. -/
def evalSourceBodies (request : AnnualRequest) : Except Fault Value :=
  let startDay := jan1 request.year
  let endDay := jan1 (request.year + 1)
  match inputBody (requestRecord request) slot request.employer startDay endDay with
  | none => .error .missingInput
  | some coefficient =>
    (((versionBody startDay ⟨firstDay, none, source⟩).map Prod.snd).map
      (fun version => encode (evaluate [(slot, coefficient)] version.body))).getD (.error .missingVersion)

theorem source_bodies_match_model (request : AnnualRequest) :
    evalSourceBodies request = evalRustModel request := by
  dsimp only [evalSourceBodies, evalRustModel, bindSingleton]
  rw [input_body_matches_model, version_body_matches_model]
  cases lookupSingleton (requestRecord request) slot request.employer
    (jan1 request.year) (jan1 (request.year + 1)) <;> rfl

theorem source_bodies_match_wire (rawArtifact : String) (wire : Json) (request : AnnualRequest)
    (requestDecoded : decodeRequest wire = .ok request)
    (artifactDecoded : decode rawArtifact = .ok sourceVersions) :
    evalWireRequest rawArtifact wire = .ok (evalSourceBodies request) := by
  rw [source_bodies_match_model]
  exact rust_model_matches_wire rawArtifact wire request requestDecoded artifactDecoded

end RuleSpecLean.Legal3403RustSource
