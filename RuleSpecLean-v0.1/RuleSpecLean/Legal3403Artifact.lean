import Lean.Data.Json
import RuleSpecLean.Legal3403Preservation

namespace RuleSpecLean.Legal3403Artifact

open Lean ScalarPreservation Legal3403Preservation

private def rootId := "us:statutes/26/3403"
private def ruleName := "employer_liability_for_chapter_withholding_tax_payment"
private def inputName := "tax_required_to_be_deducted_and_withheld_under_this_chapter"

private def check (valid : Bool) (diagnostic : String) : Except String Unit :=
  if valid then pure () else throw diagnostic

private def field (node : Json) (key : String) : Except String String := do
  (← node.getObjVal? key).getStr?

/-- Recognize the supported formula and translate its operands into source syntax. -/
private def decodeFormula (node : Json) : Except String Source := do
  check ((← field node "kind") == "max") "expected max formula"
  let items ← (← node.getObjVal? "items").getArr?
  check (items.size == 2) "expected two max operands"
  let zero ← (← node.getObjVal? "items").getArrVal? 0
  let input ← (← node.getObjVal? "items").getArrVal? 1
  check (zero == Json.mkObj [("kind", .str "literal"), ("value", Json.mkObj
    [("kind", .str "decimal"), ("value", .str "0")])]) "expected decimal zero"
  let name ← field input "name"
  check (name == inputName && input == Json.mkObj [("kind", .str "input"), ("name", .str name)])
    "unexpected withholding input"
  pure (.maximum (.normalize (.literal 0)) (.normalize (.input name)))

/-- Gregorian ordinal of January 1, from the number of completed years. -/
private def jan1 (year : Nat) : Int :=
  let completed := year - 1
  Int.ofNat (365 * completed + completed / 4 - completed / 100 + completed / 400 + 1)

/-- Decode one decimal scalar output of the §3403 Artifact v3. The supported
    version shape is one open-ended version starting on 1990-01-01. Other
    outputs, provenance and request metadata are outside the decoder's scope. -/
def decode (raw : String) : Except String (List (VersionSelection.Version Source)) := do
  let artifact ← Json.parse raw
  check ((← (← artifact.getObjVal? "artifact_format_version").getNat?) == 3) "expected Artifact v3"
  check ((← field (← artifact.getObjVal? "source_closure") "root") == rootId) "unexpected closure root"
  let rules ← (← (← artifact.getObjVal? "program").getObjVal? "derived").getArr?
  let [rule] := rules.toList.filter (fun row => (field row "id").toOption == some (rootId ++ "#" ++ ruleName))
    | throw "expected exactly one matching output"
  check ((← field rule "name") == ruleName && (← field rule "dtype") == "decimal" &&
    (← field rule "semantics") == "scalar") "unexpected output type or name"
  let versions ← (← rule.getObjVal? "versions").getArr?
  let [version] := versions.toList | throw "expected a single formula version"
  check ((← field version "effective_from") == "1990-01-01" &&
    (version.getObjVal? "effective_to").toOption.isNone) "unexpected effective interval"
  check ((← field version "semantics") == "scalar") "expected scalar version"
  let formula ← version.getObjVal? "expr"
  check ((← rule.getObjVal? "expr") == formula) "summary and version formula differ"
  let body ← decodeFormula formula
  pure [⟨jan1 1990, none, body⟩]

def retainedArtifact : String := include_str "../fixtures/legal-3403.artifact.json"

def matchesRetainedSource (raw : String) : Bool :=
  match decode raw with
  | .ok versions => decide (versions = sourceVersions)
  | .error _ => false

theorem matches_retained_source_sound (raw : String) (accepted : matchesRetainedSource raw = true) :
    decode raw = .ok sourceVersions := by
  cases h : decode raw with
  | error msg => simp [matchesRetainedSource, h] at accepted
  | ok versions => simpa [matchesRetainedSource, h] using accepted

/-- The standard JSON parser uses partial definitions. This concrete certificate
    uses Lean's native evaluator; its axiom is visible in the proof audit. -/
theorem retained_artifact_decodes : decode retainedArtifact = .ok sourceVersions :=
  matches_retained_source_sound retainedArtifact (by native_decide)

#guard (decode (retainedArtifact.replace "1990-01-01" "1990-01-02")).toOption.isNone
#guard (decode (retainedArtifact.replace inputName "other_input")).toOption.isNone

/-- Parse, lower, select and evaluate within the supported source fragment. -/
def evalArtifact (raw : String) (env : List (String × Int)) (day : Int) :
    Except String (Except Fault Value) := do
  let versions ← decode raw
  pure (((VersionSelection.select day (versions.map (VersionSelection.mapBody lower))).map
    (fun v => eval (encodeEnv env) v.body)).getD (.error .missingVersion))

theorem decoded_artifact_preserves_result (raw : String) (env : List (String × Int)) (day : Int)
    (decoded : decode raw = .ok sourceVersions) :
    evalArtifact raw env day = .ok (eval (encodeEnv env) (snapshotTarget day)) := by
  unfold evalArtifact
  rw [decoded]
  change Except.ok _ = Except.ok _
  rw [versioned_lowering_preserves_result, snapshot_target_preserves_result]

theorem retained_artifact_preserves_result (env : List (String × Int)) (day : Int) :
    evalArtifact retainedArtifact env day = .ok (eval (encodeEnv env) (snapshotTarget day)) :=
  decoded_artifact_preserves_result retainedArtifact env day retained_artifact_decodes

end RuleSpecLean.Legal3403Artifact
