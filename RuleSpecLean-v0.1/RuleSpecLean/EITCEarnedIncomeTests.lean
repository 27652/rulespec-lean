import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace EITCEarnedIncomeTestsCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(30000), 0⟩)) (Expr.lit ⟨(12000), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_0
end EITCEarnedIncomeTestsCase0

#guard match eval EITCEarnedIncomeTestsCase0.output with
  | .ok result => equalValue result ⟨(42000), 0⟩
  | .error _ => false

namespace EITCEarnedIncomeTestsCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(20000), 0⟩)) (Expr.lit ⟨(5000), 0⟩)) (Expr.lit ⟨(3000), 0⟩)) (Expr.lit ⟨(2000), 0⟩)) (Expr.lit ⟨(1000), 0⟩)) (Expr.lit ⟨(4000), 0⟩)))
def output : Expr := rule_0
end EITCEarnedIncomeTestsCase1

#guard match eval EITCEarnedIncomeTestsCase1.output with
  | .ok result => equalValue result ⟨(15000), 0⟩
  | .error _ => false

namespace EITCEarnedIncomeTestsCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(500), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(600), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_0
end EITCEarnedIncomeTestsCase2

#guard match eval EITCEarnedIncomeTestsCase2.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false
