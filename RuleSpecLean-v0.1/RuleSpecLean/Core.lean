import Lean

namespace RuleSpecLean

-- Prototype exact subset: decimal values carry a coefficient at scale 6.
-- Bounds are deliberately conservative. This is NOT rust_decimal emulation.
def scale : Int := 1000000
def limit : Int := 1000000000000000000000

inductive Judgment where
  | holds | notHolds | undetermined
  deriving Repr, BEq, DecidableEq

inductive Value where
  | integer (n : Int)
  | decimal (coefficient : Int)
  | boolean (b : Bool)
  | text (s : String)
  | judgment (j : Judgment)
  deriving Repr, BEq, DecidableEq

inductive Fault where
  | missingInput | missingVersion | missingParameter
  | divisionByZero | typeMismatch | outsideExactDomain | noMatchingArm
  deriving Repr, BEq, DecidableEq

abbrev Result := Except Fault Value
abbrev Env := List (String × Value)

inductive UOp where
  | numeric | floor | ceil | negateJudgment
  deriving Repr

inductive BOp where
  | add | sub | mul | div | max | min
  | eq | ne | lt | lte | gt | gte
  | andAlso | orElse
  deriving Repr

inductive Expr where
  | lit (v : Value)
  | input (name : String)
  | fault (e : Fault)
  | noMatch (subject : Expr)
  | unary (op : UOp) (a : Expr)
  | binary (op : BOp) (a b : Expr)
  | choose (c yes no : Expr)
  | lookup (entries : List (Int × Value)) (idx : Expr)
  deriving Repr

def checked (n : Int) : Result :=
  if -limit ≤ n ∧ n ≤ limit then .ok (.decimal n)
  else .error .outsideExactDomain

def validateValue (v : Value) : Result :=
  match v with
  | .integer n =>
      if -(2^63 : Int) ≤ n ∧ n < (2^63 : Int) then .ok v
      else .error .outsideExactDomain
  | .decimal n => checked n
  | _ => .ok v

def asNum (v : Value) : Except Fault Int :=
  match v with
  | .integer n => .ok (n * scale)
  | .decimal n => .ok n
  | _ => .error .typeMismatch

def asJudgment (v : Value) : Except Fault Judgment :=
  match v with
  | .judgment j => .ok j
  | _ => .error .typeMismatch

def truth (p : Bool) : Value :=
  .judgment (if p then .holds else .notHolds)

def jNot : Judgment → Judgment
  | .holds => .notHolds
  | .notHolds => .holds
  | .undetermined => .undetermined

def jAnd (x y : Judgment) : Judgment :=
  if x == .notHolds || y == .notHolds then .notHolds
  else if x == .undetermined || y == .undetermined then .undetermined
  else .holds

def jOr (x y : Judgment) : Judgment :=
  if x == .holds || y == .holds then .holds
  else if x == .undetermined || y == .undetermined then .undetermined
  else .notHolds

def exactQuotient (n d : Int) : Result :=
  if d == 0 then .error .divisionByZero
  else if n % d != 0 then .error .outsideExactDomain
  else checked (n / d)

def unary (op : UOp) (v : Value) : Result := do
  match op with
  | .negateJudgment => return .judgment (jNot (← asJudgment v))
  | .numeric => checked (← asNum v)
  | .floor => checked (((← asNum v) / scale) * scale)
  | .ceil => checked ((- ((- (← asNum v)) / scale)) * scale)

def compareNumbers (op : BOp) (a b : Int) : Result :=
  match op with
  | .eq => .ok (truth (a == b))
  | .ne => .ok (truth (a != b))
  | .lt => .ok (truth (decide (a < b)))
  | .lte => .ok (truth (decide (a ≤ b)))
  | .gt => .ok (truth (decide (a > b)))
  | .gte => .ok (truth (decide (a ≥ b)))
  | _ => .error .typeMismatch

def equalityOnly (op : BOp) (same : Bool) : Result :=
  match op with
  | .eq => .ok (truth same)
  | .ne => .ok (truth (!same))
  | _ => .error .typeMismatch

def compareValues (op : BOp) (a b : Value) : Result :=
  match a, b with
  | .boolean x, .boolean y => equalityOnly op (x == y)
  | .text x, .text y => equalityOnly op (x == y)
  | _, _ => do
      let x ← asNum a
      let y ← asNum b
      compareNumbers op x y

def binary (op : BOp) (a b : Value) : Result := do
  match op with
  | .eq | .ne | .lt | .lte | .gt | .gte => compareValues op a b
  | .andAlso => return .judgment (jAnd (← asJudgment a) (← asJudgment b))
  | .orElse => return .judgment (jOr (← asJudgment a) (← asJudgment b))
  | _ =>
      let x ← asNum a
      let y ← asNum b
      match op with
      | .add => checked (x + y)
      | .sub => checked (x - y)
      | .mul => exactQuotient (x * y) scale
      | .div => exactQuotient (x * scale) y
      | .max => checked (max x y)
      | .min => checked (min x y)
      | _ => .error .typeMismatch

-- Reference-inspired evaluator. Rule references become acyclic Expr definitions.
-- The prototype preserves lazy branches and divisor-first evaluation.
def eval (env : Env) : Expr → Result
  | .lit v => validateValue v
  | .input n =>
      match env.find? (fun p => p.1 == n) with
      | some p => validateValue p.2
      | none => .error .missingInput
  | .fault e => .error e
  | .noMatch subject => do
      let _ ← eval env subject
      .error .noMatchingArm
  | .unary op a => do
      unary op (← eval env a)
  | .choose c yes no => do
      let j ← asJudgment (← eval env c)
      if j == .holds then eval env yes else eval env no
  | .lookup entries idx => do
      let n ← asNum (← eval env idx)
      if n % scale != 0 then .error .typeMismatch
      else
        let key := n / scale
        if key < -(2^63 : Int) ∨ key ≥ (2^63 : Int) then
          .error .typeMismatch
        else
          match entries.find? (fun p => p.1 == key) with
          | some p => validateValue p.2
          | none => .error .missingParameter
  | .binary .div a b => do
      let bv ← eval env b
      let y ← asNum bv
      if y == 0 then .error .divisionByZero
      else binary .div (← eval env a) bv
  | .binary .andAlso a b => do
      let av ← eval env a
      let j ← asJudgment av
      if j == .notHolds then .ok (.judgment .notHolds)
      else binary .andAlso av (← eval env b)
  | .binary .orElse a b => do
      let av ← eval env a
      let j ← asJudgment av
      if j == .holds then .ok (.judgment .holds)
      else binary .orElse av (← eval env b)
  | .binary op a b => do
      let av ← eval env a
      let bv ← eval env b
      binary op av bv

theorem eval_noMatch (env : Env) (subject : Expr) :
    eval env (.noMatch subject) = match eval env subject with
      | .ok _ => .error .noMatchingArm
      | .error fault => .error fault := by
  cases h : eval env subject <;> simp [eval, h] <;> rfl

/-- An absent parameter table still evaluates and validates the index. -/
theorem eval_emptyLookup (env : Env) (idx : Expr) :
    eval env (.lookup [] idx) = (do
      let n ← asNum (← eval env idx)
      if n % scale != 0 then .error .typeMismatch
      else
        let key := n / scale
        if key < -(2^63 : Int) ∨ key ≥ (2^63 : Int) then .error .typeMismatch
        else .error .missingParameter) := by
  rfl

def sameResult (a b : Result) : Bool :=
  match a, b with
  | .ok x, .ok y => x == y
  | .error x, .error y => x == y
  | _, _ => false

theorem lazyTrue (env : Env) (a b : Expr) :
    eval env (.choose (.lit (.judgment .holds)) a b) = eval env a := by
  rfl

theorem lazyUnknown (env : Env) (a b : Expr) :
    eval env (.choose (.lit (.judgment .undetermined)) a b) = eval env b := by
  rfl

theorem andShortCircuit (env : Env) (right : Expr) :
    eval env (.binary .andAlso (.lit (.judgment .notHolds)) right) = .ok (.judgment .notHolds) := by
  rfl

theorem orShortCircuit (env : Env) (right : Expr) :
    eval env (.binary .orElse (.lit (.judgment .holds)) right) = .ok (.judgment .holds) := by
  rfl

theorem andUnknown (env : Env) (right : Expr) :
    eval env (.binary .andAlso (.lit (.judgment .undetermined)) right) =
      (eval env right).bind (fun v => binary .andAlso (.judgment .undetermined) v) := by
  rfl

theorem orUnknown (env : Env) (right : Expr) :
    eval env (.binary .orElse (.lit (.judgment .undetermined)) right) =
      (eval env right).bind (fun v => binary .orElse (.judgment .undetermined) v) := by
  rfl

theorem divisionZeroFirst (env : Env) (a : Expr) :
    eval env (.binary .div a (.lit (.integer 0))) = .error .divisionByZero := by
  rfl

end RuleSpecLean
