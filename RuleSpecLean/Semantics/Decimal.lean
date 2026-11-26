import Lean

namespace RuleSpecLean.DecimalModel

def maxCoefficient : Int := 79228162514264337593543950335

structure Decimal where
  coefficient : Int
  scale : Nat
  deriving Repr, BEq, DecidableEq

def valid (v : Decimal) : Bool :=
  decide (-maxCoefficient ≤ v.coefficient ∧ v.coefficient ≤ maxCoefficient ∧ v.scale ≤ 28)

inductive Rounding where
  | halfUp | halfEven | floor | ceil
  deriving Repr, BEq, DecidableEq

def round (v : Decimal) (places : Nat) (mode : Rounding) : Option Decimal := do
  if !valid v || places > 28 then none
  else if places ≥ v.scale then some v
  else
    let divisor := 10 ^ (v.scale - places)
    let magnitude := v.coefficient.natAbs / divisor
    let remainder := v.coefficient.natAbs % divisor
    let negative := v.coefficient < 0
    let increment : Bool := match mode with
      | .halfUp => decide (2 * remainder ≥ divisor)
      | .halfEven => decide (2 * remainder > divisor ∨
          (2 * remainder = divisor ∧ magnitude % 2 = 1))
      | .floor => decide (negative ∧ remainder ≠ 0)
      | .ceil => decide (¬negative ∧ remainder ≠ 0)
    let result : Int := Int.ofNat (magnitude + if increment then 1 else 0)
    some ⟨if negative then -result else result, places⟩

theorem roundInvalid (v : Decimal) (places : Nat) (mode : Rounding)
    (h : valid v = false) : round v places mode = none := by
  simp [round, h]

theorem round_keeps_value_at_or_above_scale (v : Decimal) (places : Nat) (mode : Rounding)
    (hv : valid v = true) (hscale : v.scale ≤ places) (hplaces : places ≤ 28) :
    round v places mode = some v := by
  simp [round, hv, hscale, Nat.not_lt.mpr hplaces]

theorem round_result_scale (v result : Decimal) (places : Nat) (mode : Rounding)
    (h : round v places mode = some result) : result.scale = min v.scale places := by
  unfold round at h
  split at h
  · contradiction
  split at h
  · rename_i hscale
    cases h
    exact (Nat.min_eq_left hscale).symm
  · rename_i hscale
    cases h
    exact (Nat.min_eq_right (Nat.le_of_lt (Nat.lt_of_not_ge hscale))).symm

inductive Fault where
  | invalidDecimal | divisionByZero | arithmeticOverflow
  | invalidParameterIndex | missingParameterValue
  | missingInput | missingRuleVersion | noMatchingArm
  deriving Repr, BEq, DecidableEq

inductive Arithmetic where
  | add | sub | mul | div
  deriving Repr, BEq, DecidableEq

def roundRatio (n d : Nat) : Nat :=
  let q := n / d
  let r := n % d
  q + if 2 * r > d ∨ (2 * r = d ∧ q % 2 = 1) then 1 else 0

def fitRatio (n : Int) (d : Nat) : Nat → Except Fault Decimal
  | 0 =>
      let c := roundRatio n.natAbs d
      if c > maxCoefficient.toNat then .error .arithmeticOverflow
      else .ok ⟨if n < 0 then -(Int.ofNat c) else Int.ofNat c, 0⟩
  | s + 1 =>
      let c := roundRatio (n.natAbs * 10^(s+1)) d
      if c > maxCoefficient.toNat then fitRatio n d s
      else .ok ⟨if n < 0 then -(Int.ofNat c) else Int.ofNat c, s+1⟩

private def divisionPower (coefficient : Nat) : Nat → Nat
  | 0 => 0
  | power + 1 =>
      if coefficient * 10^(power+1) ≤ maxCoefficient.toNat then power+1
      else divisionPower coefficient power

-- Each recursive step increases scale by at least one, from at least -28 to at most 28.
private def divisionDigits (divisor : Nat) : Nat → Nat → Nat → Int → Except Fault (Nat × Nat)
  | 0, _, _, _ => .error .arithmeticOverflow
  | fuel+1, coefficient, remainder, scale => do
      if remainder == 0 && scale >= 0 then return (coefficient, scale.toNat)
      let cap := min 9 (if remainder == 0 then (-scale).toNat else (28-scale).toNat)
      let power := divisionPower coefficient cap
      if scale < 0 && (power == 0 ||
          (remainder != 0 && power != 9 && scale + (power : Int) < 0)) then
        .error .arithmeticOverflow
      else if power == 0 then
        let rounded := roundRatio (coefficient * divisor + remainder) divisor
        if rounded ≤ maxCoefficient.toNat then return (rounded, scale.toNat)
        else if scale ≤ 0 then .error .arithmeticOverflow
        else return (roundRatio rounded 10, (scale-1).toNat)
      else
        let numerator := (coefficient * divisor + remainder) * 10^power
        let next := numerator / divisor
        let nextScale := scale + (power : Int)
        if next > maxCoefficient.toNat then
          if nextScale ≤ 0 then .error .arithmeticOverflow
          else return (roundRatio numerator (divisor*10), (nextScale-1).toNat)
        else divisionDigits divisor fuel next (numerator % divisor) nextScale

private def unscaleDivision8 : Nat → Nat → Nat → Nat × Nat
  | 0, coefficient, scale => (coefficient, scale)
  | fuel+1, coefficient, scale =>
    if 8 ≤ scale && coefficient % 2^32 == 0 && coefficient % 10^8 == 0 then
      unscaleDivision8 fuel (coefficient / 10^8) (scale - 8)
    else (coefficient, scale)

private def unscaleDivision (coefficient scale : Nat) : Nat × Nat :=
  [4, 2, 1].foldl (fun (c, s) power =>
    if power ≤ s && c % 10^power == 0 then (c / 10^power, s - power)
    else (c, s)) (unscaleDivision8 (scale / 8) coefficient scale)

private def divide (a b : Decimal) : Except Fault Decimal := do
  if b.coefficient == 0 then .error .divisionByZero
  else if a.coefficient == 0 then .ok ⟨0, 0⟩
  else
    let n := a.coefficient.natAbs
    let d := b.coefficient.natAbs
    let remainder := n % d
    let (c, s) ← divisionDigits d 57 (n / d) remainder ((a.scale : Int) - b.scale)
    let (c, s) := if remainder == 0 then (c, s) else unscaleDivision c s
    return ⟨if (a.coefficient < 0) = (b.coefficient < 0) then Int.ofNat c else -(Int.ofNat c), s⟩

def arithmetic (op : Arithmetic) (a b : Decimal) : Except Fault Decimal :=
  if !valid a || !valid b then .error .invalidDecimal
  else match op with
  | .add | .sub =>
    if a.coefficient == 0 then
      .ok (if op == .add then b else { b with coefficient := -b.coefficient })
    else if b.coefficient == 0 then .ok a
    else
      let s := max a.scale b.scale
      let x := a.coefficient * (10 : Int)^(s-a.scale)
      let y := b.coefficient * (10 : Int)^(s-b.scale)
      fitRatio (if op == .add then x+y else x-y) (10^s) s
  | .mul =>
      let scale := a.scale + b.scale
      if a.coefficient == 0 || b.coefficient == 0 ||
         (scale > 47 && a.coefficient.natAbs < 2^32 && b.coefficient.natAbs < 2^32) then
        .ok ⟨0, 0⟩
      else fitRatio (a.coefficient * b.coefficient) (10^scale) (min 28 scale)
  | .div => divide a b

def equalValue (a b : Decimal) : Bool :=
  a.coefficient * (10 : Int)^b.scale == b.coefficient * (10 : Int)^a.scale

def lessValue (a b : Decimal) : Bool :=
  decide (a.coefficient * (10 : Int)^b.scale < b.coefficient * (10 : Int)^a.scale)

inductive Comparison where
  | eq | ne | lt | lte | gt | gte

def compareValue (op : Comparison) (a b : Decimal) : Bool :=
  match op with
  | .eq => equalValue a b
  | .ne => !equalValue a b
  | .lt => lessValue a b
  | .lte => !lessValue b a
  | .gt => lessValue b a
  | .gte => !lessValue a b

mutual
inductive Expr where
  | lit (value : Decimal)
  | missingInput
  | missingRuleVersion
  | noMatch (subject : Expr)
  | binary (op : Arithmetic) (left right : Expr)
  | extreme (greatest : Bool) (left right : Expr)
  | rounded (places : Nat) (mode : Rounding) (body : Expr)
  | choose (condition : Predicate) (onTrue onFalse : Expr)
  | lookup (entries : List (Int × Decimal)) (index : Expr)
  | countWhere (predicates : List Predicate)
  | sumWhere (members : List (Predicate × Expr))

inductive Predicate where
  | missingRuleVersion
  | constant (value : Bool)
  | compare (op : Comparison) (left right : Expr)
  | compareBool (equality : Bool) (left right : Option Bool)
  | negate (item : Predicate)
  | andAlso (left right : Predicate)
  | orElse (left right : Predicate)
end

-- Rounded dependency bodies remain explicit nodes, not metadata on consumers.
mutual
def eval : Expr → Except Fault Decimal
  | .lit value => if valid value then .ok value else .error .invalidDecimal
  | .missingInput => .error .missingInput
  | .missingRuleVersion => .error .missingRuleVersion
  | .noMatch subject => do
      let _ ← eval subject
      .error .noMatchingArm
  | .countWhere predicates => do
      let count ← evalCount predicates
      return ⟨count, 0⟩
  | .sumWhere members => evalSum members ⟨0, 0⟩
  | .lookup entries index => do
      let value ← eval index
      let divisor := (10 : Int)^value.scale
      let key := value.coefficient / divisor
      if value.coefficient % divisor != 0 || key < -(2^63) || key ≥ 2^63 then
        .error .invalidParameterIndex
      else
        match entries.find? (fun entry => entry.1 == key) with
        | some (_, result) => if valid result then .ok result else .error .invalidDecimal
        | none => .error .missingParameterValue
  | .choose condition onTrue onFalse => do
      if ← evalPredicate condition then eval onTrue else eval onFalse
  | .extreme greatest left right => do
      let a ← eval left
      let b ← eval right
      return if (if greatest then lessValue a b else lessValue b a) then b else a
  | .rounded places mode body => do
      let value ← eval body
      match round value places mode with
      | some result => .ok result
      | none => .error .invalidDecimal
  | .binary .div left right => do
      let b ← eval right
      if b.coefficient == 0 then .error .divisionByZero
      else arithmetic .div (← eval left) b
  | .binary op left right => do
      let a ← eval left
      let b ← eval right
      arithmetic op a b

def evalPredicate : Predicate → Except Fault Bool
  | .missingRuleVersion => .error .missingRuleVersion
  | .constant value => .ok value
  | .compare op left right => do
      let a ← eval left
      let b ← eval right
      return compareValue op a b
  | .compareBool equality left right =>
      match left, right with
      | some a, some b => .ok ((a == b) == equality)
      | _, _ => .error .missingInput
  | .negate item => return !(← evalPredicate item)
  | .andAlso left right => do
      if ← evalPredicate left then evalPredicate right else return false
  | .orElse left right => do
      if ← evalPredicate left then return true else evalPredicate right

def evalCount : List Predicate → Except Fault Int
  | [] => .ok 0
  | predicate :: rest => do
      let selected ← evalPredicate predicate
      let count ← evalCount rest
      return if selected then count + 1 else count

def evalSum : List (Predicate × Expr) → Decimal → Except Fault Decimal
  | [], total => .ok total
  | (predicate, value) :: rest, total => do
      if ← evalPredicate predicate then
        let next ← arithmetic .add total (← eval value)
        evalSum rest next
      else evalSum rest total
end

/-- An unmatched branch preserves errors encountered while reading its subject. -/
theorem eval_noMatch (subject : Expr) :
    eval (.noMatch subject) = match eval subject with
      | .ok _ => .error .noMatchingArm
      | .error fault => .error fault := by
  cases h : eval subject <;> simp [eval, h] <;> rfl

end RuleSpecLean.DecimalModel
