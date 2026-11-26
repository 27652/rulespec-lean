import RuleSpecLean.Proofs.Legal3403Artifact

namespace RuleSpecLean.Legal3403Binding

open Lean ScalarPreservation Legal3403Artifact Legal3403Preservation

def slot := "tax_required_to_be_deducted_and_withheld_under_this_chapter"
private def inputId := "us:statutes/26/3403#input." ++ slot
private def outputId := "us:statutes/26/3403#employer_liability_for_chapter_withholding_tax_payment"

/-- One employer, one January-to-January tax-year query, one matching
    withholding fact in whole dollars. The constructor fixes the identifiers,
    mode, period kind and absence of relations for this fragment. -/
structure AnnualRequest where
  employer : String
  year : Nat
  dollars : Int

def AnnualRequest.valid (request : AnnualRequest) : Prop :=
  request.employer ≠ "" ∧ 1 ≤ request.year ∧ request.year < 9999 ∧
  -limit ≤ request.dollars * scale ∧ request.dollars * scale ≤ limit

instance (request : AnnualRequest) : Decidable request.valid :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _ ∧ _ ∧ _))

def bind (request : AnnualRequest) : Option (List (String × Int) × Int) :=
  if request.valid then some ([(slot, request.dollars * scale)], jan1 request.year) else none

theorem bind_corresponds (request : AnnualRequest) (valid : request.valid) :
    bind request = some ([(slot, request.dollars * scale)], jan1 request.year) := by
  simp [bind, valid]

theorem bind_rejects (request : AnnualRequest) (invalid : ¬ request.valid) : bind request = none := by
  simp [bind, invalid]

def evalRequest (rawArtifact : String) (request : AnnualRequest) : Except String (Except Fault Value) := do
  let some (env, day) := bind request | throw "unsupported §3403 annual request"
  evalArtifact rawArtifact env day

theorem bound_request_preserves_result (rawArtifact : String) (request : AnnualRequest)
    (valid : request.valid) (decoded : decode rawArtifact = .ok sourceVersions) :
    evalRequest rawArtifact request =
      .ok (eval (encodeEnv [(slot, request.dollars * scale)]) (snapshotTarget (jan1 request.year))) := by
  unfold evalRequest
  rw [bind_corresponds request valid]
  exact decoded_artifact_preserves_result _ _ _ decoded

/-- Canonical wire shape of the restricted request, including identical input
    and query intervals and the same employer identity on both. -/
def AnnualRequest.toJson (request : AnnualRequest) : Json := Id.run do
  let jan1Text := fun (year : Nat) =>
    let digits := toString year
    String.ofList (List.replicate (4 - digits.length) '0') ++ digits ++ "-01-01"
  let interval := [("start", Json.str (jan1Text request.year)), ("end", Json.str (jan1Text (request.year + 1)))]
  let input := Json.mkObj [("name", .str inputId), ("entity", .str "Employer"),
    ("entity_id", .str request.employer), ("interval", Json.mkObj interval),
    ("value", Json.mkObj [("kind", .str "decimal"), ("value", .str (toString request.dollars))])]
  let query := Json.mkObj [("entity_id", .str request.employer),
    ("period", Json.mkObj (("period_kind", .str "tax_year") :: interval)),
    ("outputs", .arr #[.str outputId])]
  return Json.mkObj [("mode", .str "explain"), ("queries", .arr #[query]),
    ("dataset", Json.mkObj [("inputs", .arr #[input]), ("relations", .arr #[])])]

private def field (node : Json) (key : String) : Except String String := do
  (← node.getObjVal? key).getStr?

private def readRequestFields (wire : Json) : Except String AnnualRequest := do
  let query ← (← wire.getObjVal? "queries").getArrVal? 0
  let input ← (← (← wire.getObjVal? "dataset").getObjVal? "inputs").getArrVal? 0
  let employer ← field query "entity_id"
  let start ← field (← query.getObjVal? "period") "start"
  let some year := (start.take 4).toNat? | throw "invalid query year"
  let value ← field (← input.getObjVal? "value") "value"
  let some dollars := value.toInt? | throw "expected whole dollars"
  pure (AnnualRequest.mk employer year dollars)

/-- Recognize the existing wire requests by reconstructing and comparing their
    shape. Extra facts, mismatched intervals and noncanonical dates are rejected. -/
def decodeRequest (wire : Json) : Except String AnnualRequest := do
  let request ← readRequestFields wire
  if wire == request.toJson && decide request.valid then .ok request
  else .error "unsupported §3403 annual request shape"

theorem decoded_request_valid (wire : Json) (request : AnnualRequest)
    (decoded : decodeRequest wire = .ok request) : request.valid := by
  cases h : readRequestFields wire with
  | error msg => simp [decodeRequest, h, Bind.bind, Except.bind] at decoded
  | ok fields =>
    by_cases accepted : (wire == fields.toJson) = true ∧ fields.valid
    · have same : fields = request := by
        simpa [decodeRequest, h, Bind.bind, Except.bind, accepted.1, accepted.2] using decoded
      exact same ▸ accepted.2
    · simp [decodeRequest, h, Bind.bind, Except.bind, Bool.and_eq_true, accepted] at decoded

def evalWireRequest (rawArtifact : String) (wire : Json) : Except String (Except Fault Value) := do
  let request ← decodeRequest wire
  evalRequest rawArtifact request

theorem wire_request_preserves_result (rawArtifact : String) (wire : Json) (request : AnnualRequest)
    (requestDecoded : decodeRequest wire = .ok request)
    (artifactDecoded : decode rawArtifact = .ok sourceVersions) :
    evalWireRequest rawArtifact wire =
      .ok (eval (encodeEnv [(slot, request.dollars * scale)]) (snapshotTarget (jan1 request.year))) := by
  unfold evalWireRequest
  rw [requestDecoded]
  exact bound_request_preserves_result _ _ (decoded_request_valid _ _ requestDecoded) artifactDecoded

theorem retained_wire_request_preserves_result (wire : Json) (request : AnnualRequest)
    (requestDecoded : decodeRequest wire = .ok request) :
    evalWireRequest retainedArtifact wire =
      .ok (eval (encodeEnv [(slot, request.dollars * scale)]) (snapshotTarget (jan1 request.year))) :=
  wire_request_preserves_result _ _ _ requestDecoded retained_artifact_decodes

private def sample : AnnualRequest := ⟨"employer:1", 2026, 15⟩

#guard (decodeRequest sample.toJson).isOk
#guard (decodeRequest (sample.toJson.setObjVal! "mode" (.str "batch"))).toOption.isNone
#guard (decodeRequest ({ sample with year := 9999 }.toJson)).toOption.isNone
#guard (decodeRequest ({ sample with dollars := limit }.toJson)).toOption.isNone

private def mismatchedEmployer : Except String AnnualRequest := do
  let dataset ← sample.toJson.getObjVal? "dataset"
  let input ← (← dataset.getObjVal? "inputs").getArrVal? 0
  let dataset := dataset.setObjVal! "inputs" (.arr #[input.setObjVal! "entity_id" (.str "employer:2")])
  decodeRequest (sample.toJson.setObjVal! "dataset" dataset)

#guard mismatchedEmployer.toOption.isNone

-- Selection uses the query start even when the interval reaches firstDay.
#guard (match evalWireRequest retainedArtifact ({ sample with year := 1989 }.toJson) with
  | .ok (.error .missingVersion) => true
  | _ => false)
#guard (match evalWireRequest retainedArtifact ({ sample with year := 1990 }.toJson) with
  | .ok (.ok (.decimal coefficient)) => coefficient == 15 * scale
  | _ => false)

private def fixtureMatches : Except String Bool := do
  let cases ← (← Json.parse (include_str "../../fixtures/legal-3403.cases.json")).getArr?
  let checks ← cases.mapM fun row => do
    let request ← decodeRequest (← row.getObjVal? "request")
    let expected ← field (← (← row.getObjVal? "env").getObjVal? slot) "value"
    let some dollars := expected.toInt? | throw "invalid fixture amount"
    let asOf ← field row "as_of"
    pure (asOf == "2026-01-01" && bind request == some ([(slot, dollars * scale)], 739617))
  pure (checks.size == 105 && checks.all id)

#guard fixtureMatches.toOption == some true

end RuleSpecLean.Legal3403Binding
