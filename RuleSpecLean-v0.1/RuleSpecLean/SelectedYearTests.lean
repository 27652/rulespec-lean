import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace SelectedYearCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lit ⟨(1234567890123456789012345678), 24⟩) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end SelectedYearCase0

#guard match eval SelectedYearCase0.output with
  | .ok result => equalValue result ⟨(1234567890123456789012345678), 24⟩
  | .error _ => false

namespace SelectedYearCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lit ⟨(1234567890123456789012345678), 24⟩) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end SelectedYearCase1

#guard match eval SelectedYearCase1.output with
  | .ok result => equalValue result ⟨(1234567890123456789012345678), 24⟩
  | .error _ => false

namespace SelectedYearCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lit ⟨(1234567890123456789012345678), 24⟩) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end SelectedYearCase2

#guard match eval SelectedYearCase2.output with
  | .ok result => equalValue result ⟨(1234567890123456789012345678), 24⟩
  | .error _ => false

namespace SelectedYearCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lit ⟨(10), 0⟩) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end SelectedYearCase3

#guard match eval SelectedYearCase3.output with
  | .ok result => equalValue result ⟨(10), 0⟩
  | .error _ => false

namespace SelectedYearCase4
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul Expr.missingInput (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end SelectedYearCase4

#guard match eval SelectedYearCase4.output with
  | .error fault => fault == .missingInput
  | .ok _ => false

namespace SelectedYearCase5
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lit ⟨(1234567890123456789012345678), 24⟩) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end SelectedYearCase5

#guard match eval SelectedYearCase5.output with
  | .ok result => equalValue result ⟨(1234567890123456789012345678), 24⟩
  | .error _ => false
