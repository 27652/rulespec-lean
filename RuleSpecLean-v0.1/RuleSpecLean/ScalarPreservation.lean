import RuleSpecLean.Core

namespace RuleSpecLean.ScalarPreservation

/-- A numeric source fragment with coefficients in the scale-6 representation.
Inputs and table values are decimal coefficients. Date resolution is outside this fragment. -/
inductive Source where
  | literal (coefficient : Int)
  | input (name : String)
  | normalize (operand : Source)
  | noMatch (subject : Source)
  | lookup (entries : List (Int × Int)) (index : Source)
  | add (left right : Source)
  | subtract (left right : Source)
  | multiply (left right : Source)
  | maximum (left right : Source)
  | divide (numerator denominator : Source)
  | ifLess (left right onTrue onFalse : Source)
  deriving DecidableEq

def lower : Source → Expr
  | .literal n => .lit (.decimal n)
  | .input name => .input name
  | .normalize a => .unary .numeric (lower a)
  | .noMatch a => .noMatch (lower a)
  | .lookup entries idx => .lookup (entries.map fun (k, v) => (k, .decimal v)) (lower idx)
  | .add a b => .binary .add (lower a) (lower b)
  | .subtract a b => .binary .sub (lower a) (lower b)
  | .multiply a b => .binary .mul (lower a) (lower b)
  | .maximum a b => .binary .max (lower a) (lower b)
  | .divide a b => .binary .div (lower a) (lower b)
  | .ifLess a b yes no => .choose (.binary .lt (lower a) (lower b)) (lower yes) (lower no)

def bounded (n : Int) : Except Fault Int :=
  if -limit ≤ n ∧ n ≤ limit then .ok n else .error .outsideExactDomain

/-- Source evaluation operates on coefficients directly. Division requires
an exact scale-6 quotient and tests the divisor before reading the numerator. -/
def evaluate (env : List (String × Int)) : Source → Except Fault Int
  | .literal n => bounded n
  | .input name =>
      match env.find? (fun entry => entry.1 == name) with
      | some entry => bounded entry.2
      | none => .error .missingInput
  | .normalize a => do
      let x ← evaluate env a
      bounded x
  | .noMatch a => do
      let _ ← evaluate env a
      .error .noMatchingArm
  | .lookup entries idx => do
      let n ← evaluate env idx
      if n % scale != 0 then .error .typeMismatch
      else
        let key := n / scale
        if key < -(2^63 : Int) ∨ key ≥ (2^63 : Int) then .error .typeMismatch
        else
          match entries.find? (fun p => p.1 == key) with
          | some p => bounded p.2
          | none => .error .missingParameter
  | .add a b => do
      let x ← evaluate env a
      let y ← evaluate env b
      bounded (x + y)
  | .subtract a b => do
      let x ← evaluate env a
      let y ← evaluate env b
      bounded (x - y)
  | .multiply a b => do
      let x ← evaluate env a
      let y ← evaluate env b
      if (x * y) % scale != 0 then .error .outsideExactDomain
      else bounded ((x * y) / scale)
  | .maximum a b => do
      let x ← evaluate env a
      let y ← evaluate env b
      bounded (max x y)
  | .divide a b => do
      let y ← evaluate env b
      if y == 0 then .error .divisionByZero
      else
        let x ← evaluate env a
        if (x * scale) % y != 0 then .error .outsideExactDomain
        else bounded ((x * scale) / y)
  | .ifLess a b yes no => do
      let x ← evaluate env a
      let y ← evaluate env b
      if x < y then evaluate env yes else evaluate env no

def encode : Except Fault Int → Result
  | .ok n => .ok (.decimal n)
  | .error fault => .error fault

private theorem checked_eq (n : Int) : checked n = encode (bounded n) := by
  by_cases h : -limit ≤ n ∧ n ≤ limit <;> simp [checked, encode, bounded, h]

def encodeEnv (env : List (String × Int)) : Env :=
  env.map fun (name, coefficient) => (name, .decimal coefficient)

private theorem input_preserved (env : List (String × Int)) (name : String) :
    eval (encodeEnv env) (.input name) = encode (evaluate env (.input name)) := by
  induction env with
  | nil => rfl
  | cons entry rest ih =>
      obtain ⟨key, coefficient⟩ := entry
      by_cases h : (key == name) = true
      · simp [encodeEnv, eval, evaluate, List.find?, h, validateValue, checked_eq]
      · simpa [encodeEnv, eval, evaluate, List.find?, h] using ih

private theorem table_preserved (entries : List (Int × Int)) (key : Int) :
    (match (entries.map fun (k, v) => (k, Value.decimal v)).find? (fun p => p.1 == key) with
     | some p => validateValue p.2
     | none => .error .missingParameter) =
    encode (match entries.find? (fun p => p.1 == key) with
            | some p => bounded p.2
            | none => .error .missingParameter) := by
  induction entries with
  | nil => rfl
  | cons entry rest ih =>
      obtain ⟨k, v⟩ := entry
      by_cases h : (k == key) = true
      · simp [List.find?, h, validateValue, checked_eq]
      · simpa [List.find?, h] using ih

theorem lowering_preserves_result (env : List (String × Int)) (term : Source) :
    eval (encodeEnv env) (lower term) = encode (evaluate env term) := by
  induction term with
  | literal n => exact checked_eq n
  | input name => exact input_preserved env name
  | normalize a ha =>
      simp only [lower, evaluate, eval, ha]
      cases evaluate env a <;> simp [encode, bind, Except.bind, unary, asNum, checked_eq]
  | noMatch a ha =>
      rw [lower, eval_noMatch, ha]
      cases h : evaluate env a <;> simp [evaluate, h, encode, bind, Except.bind]
  | lookup entries idx hi =>
      simp only [lower, eval, hi, evaluate]
      cases evaluate env idx with
      | error => rfl
      | ok n =>
          simp only [encode, bind, Except.bind, asNum]
          split
          · rfl
          · split
            · rfl
            · exact table_preserved entries (n / scale)
  | add a b ha hb =>
      simp only [lower, evaluate, eval, ha, hb]
      cases evaluate env a <;> cases evaluate env b <;>
        simp [encode, bind, Except.bind, binary, asNum, checked_eq]
  | subtract a b ha hb =>
      simp only [lower, evaluate, eval, ha, hb]
      cases evaluate env a <;> cases evaluate env b <;>
        simp [encode, bind, Except.bind, binary, asNum, checked_eq]
  | multiply a b ha hb =>
      simp only [lower, evaluate, eval, ha, hb]
      cases evaluate env a <;> cases evaluate env b <;>
        simp [encode, bind, Except.bind, binary, asNum, exactQuotient, scale, checked_eq] <;>
        split <;> rfl
  | maximum a b ha hb =>
      simp only [lower, evaluate, eval, ha, hb]
      cases evaluate env a <;> cases evaluate env b <;>
        simp [encode, bind, Except.bind, binary, asNum, checked_eq]
  | divide a b ha hb =>
      simp only [lower, evaluate, eval, ha, hb]
      cases evaluate env b with
      | error f => rfl
      | ok y =>
          by_cases hz : y == 0
          · simp [encode, bind, Except.bind, asNum, hz]
          · cases evaluate env a <;>
              simp [encode, bind, Except.bind, asNum, binary, exactQuotient, hz, checked_eq] <;>
              split <;> rfl
  | ifLess a b yes no ha hb hy hn =>
      simp only [lower, evaluate, eval, ha, hb]
      cases evaluate env a with
      | error => rfl
      | ok x =>
          cases evaluate env b with
          | error => rfl
          | ok y =>
              have holds : (Judgment.holds == Judgment.holds) = true := rfl
              have notHolds : (Judgment.notHolds == Judgment.holds) = false := rfl
              by_cases h : x < y <;>
                simp [encode, bind, Except.bind, binary, compareValues, compareNumbers,
                  asNum, asJudgment, truth, h, hy, hn, holds, notHolds]

private def recognizeTable : List (Int × Value) → Option (List (Int × Int))
  | [] => some []
  | (key, .decimal value) :: rest => ((key, value) :: ·) <$> recognizeTable rest
  | _ => none

private theorem recognizeTable_sound (table : List (Int × Value)) (entries : List (Int × Int))
    (h : recognizeTable table = some entries) :
    (entries.map fun (key, value) => (key, Value.decimal value)) = table := by
  induction table generalizing entries with
  | nil => cases h; rfl
  | cons entry rest ih =>
    obtain ⟨key, value⟩ := entry
    cases value <;> simp [recognizeTable] at h
    rename_i value
    cases ht : recognizeTable rest with
    | none => simp [ht] at h
    | some tail =>
      simp [ht] at h
      subst entries
      simp [ih tail ht]

/-- Independently check that a generated target term belongs to this fragment.
Every accepted tree is reconstructed without consulting Python or artifact metadata. -/
def recognize : Expr → Option Source
  | .lit (.decimal n) => some (.literal n)
  | .input name => some (.input name)
  | .unary .numeric a => .normalize <$> recognize a
  | .noMatch a => .noMatch <$> recognize a
  | .lookup entries idx => Source.lookup <$> recognizeTable entries <*> recognize idx
  | .binary .add a b => Source.add <$> recognize a <*> recognize b
  | .binary .sub a b => Source.subtract <$> recognize a <*> recognize b
  | .binary .mul a b => Source.multiply <$> recognize a <*> recognize b
  | .binary .max a b => Source.maximum <$> recognize a <*> recognize b
  | .binary .div a b => Source.divide <$> recognize a <*> recognize b
  | .choose (.binary .lt a b) yes no =>
      Source.ifLess <$> recognize a <*> recognize b <*> recognize yes <*> recognize no
  | _ => none

theorem recognize_sound (target : Expr) (source : Source)
    (h : recognize target = some source) : lower source = target := by
  induction target using recognize.induct generalizing source <;>
    simp_all [recognize, Seq.seq, Functor.map, Option.map] <;>
    repeat' (first | split at h | cases h | rfl | contradiction) <;>
    simp_all [lower]
  exact recognizeTable_sound _ _ (by assumption)

theorem recognized_target_preserves_result (env : List (String × Int))
    (target : Expr) (source : Source) (h : recognize target = some source) :
    eval (encodeEnv env) target = encode (evaluate env source) := by
  rw [← recognize_sound target source h]
  exact lowering_preserves_result env source

theorem lookup_preserves_result (env : List (String × Int))
    (entries : List (Int × Int)) (idx : Source) :
    eval (encodeEnv env) (.lookup (entries.map fun (k, v) => (k, .decimal v)) (lower idx)) =
      encode (evaluate env (.lookup entries idx)) :=
  lowering_preserves_result env (.lookup entries idx)

example : (recognize (.lookup [(0, .decimal 1250000)] (.input "index"))).isSome = true := rfl

example : recognize (.lookup [(0, .integer 1)] (.input "index")) = none := rfl

example : evaluate [("index", 0)] (.lookup [(0, 1250000)] (.input "index")) = .ok 1250000 := rfl

example : evaluate [("index", 500000)] (.lookup [] (.input "index")) = .error .typeMismatch := rfl

example : evaluate [] (.lookup [] (.input "index")) = .error .missingInput := rfl

example : evaluate [("index", 0)] (.lookup [] (.input "index")) = .error .missingParameter := rfl

end RuleSpecLean.ScalarPreservation
