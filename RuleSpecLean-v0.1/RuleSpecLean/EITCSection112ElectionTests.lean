import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace EITCSection112ElectionTestsCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(10000), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)))
def rule_1 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.orElse (Predicate.compareBool true (some true) (some true)) (Predicate.orElse (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.andAlso (Predicate.compare .lte Expr.missingInput (Expr.lookup [((0), ⟨(2), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true none (some true))) (Predicate.constant true))) (Predicate.constant false))) (Predicate.constant true))) (Expr.lit ⟨(6000), 0⟩) (Expr.lit ⟨(0), 0⟩))) (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.orElse (Predicate.compareBool true (some true) (some true)) (Predicate.orElse (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.andAlso (Predicate.compare .lte Expr.missingInput (Expr.lookup [((0), ⟨(2), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true none (some true))) (Predicate.constant true))) (Predicate.constant false))) (Predicate.constant true))) (Expr.extreme false Expr.missingInput Expr.missingInput) (Expr.lit ⟨(0), 0⟩)))) (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true none (some true))) (Predicate.constant true))) Expr.missingInput (Expr.lit ⟨(0), 0⟩)))) (Expr.choose (Predicate.compareBool true (some false) (some true)) Expr.missingInput (Expr.lit ⟨(0), 0⟩)))
def rule_2 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) rule_0) (Expr.choose (Predicate.compareBool true (some false) (some true)) rule_1 (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_2
end EITCSection112ElectionTestsCase0

#guard match eval EITCSection112ElectionTestsCase0.output with
  | .ok result => equalValue result ⟨(10000), 0⟩
  | .error _ => false

namespace EITCSection112ElectionTestsCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(10000), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)))
def rule_1 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.orElse (Predicate.compareBool true (some true) (some true)) (Predicate.orElse (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.andAlso (Predicate.compare .lte Expr.missingInput (Expr.lookup [((0), ⟨(2), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true none (some true))) (Predicate.constant true))) (Predicate.constant false))) (Predicate.constant true))) (Expr.lit ⟨(6000), 0⟩) (Expr.lit ⟨(0), 0⟩))) (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.orElse (Predicate.compareBool true (some true) (some true)) (Predicate.orElse (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.andAlso (Predicate.compare .lte Expr.missingInput (Expr.lookup [((0), ⟨(2), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true none (some true))) (Predicate.constant true))) (Predicate.constant false))) (Predicate.constant true))) (Expr.extreme false Expr.missingInput Expr.missingInput) (Expr.lit ⟨(0), 0⟩)))) (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true none (some true))) (Predicate.constant true))) Expr.missingInput (Expr.lit ⟨(0), 0⟩)))) (Expr.choose (Predicate.compareBool true (some false) (some true)) Expr.missingInput (Expr.lit ⟨(0), 0⟩)))
def rule_2 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) rule_0) (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_1 (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_2
end EITCSection112ElectionTestsCase1

#guard match eval EITCSection112ElectionTestsCase1.output with
  | .ok result => equalValue result ⟨(16000), 0⟩
  | .error _ => false
