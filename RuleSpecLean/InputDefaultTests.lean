import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace InputDefaultCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(250), 2⟩)) (Expr.lit ⟨(125), 2⟩))
def output : Expr := rule_0
end InputDefaultCase0

#guard match eval InputDefaultCase0.output with
  | .ok v => equalValue v ⟨(375), 2⟩
  | .error _ => false


namespace InputDefaultCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def output : Expr := rule_0
end InputDefaultCase1

#guard match eval InputDefaultCase1.output with
  | .ok v => equalValue v ⟨(0), 0⟩
  | .error _ => false


namespace InputDefaultCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(-125), 2⟩)) (Expr.lit ⟨(-125), 2⟩))
def output : Expr := rule_0
end InputDefaultCase2

#guard match eval InputDefaultCase2.output with
  | .ok v => equalValue v ⟨(-25), 1⟩
  | .error _ => false
