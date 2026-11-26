import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace CTCRefundableCapTestsCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [])
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(1400), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_1
end CTCRefundableCapTestsCase0

#guard match eval CTCRefundableCapTestsCase0.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace CTCRefundableCapTestsCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [(Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.constant true)))])
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(1400), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_1
end CTCRefundableCapTestsCase1

#guard match eval CTCRefundableCapTestsCase1.output with
  | .ok result => equalValue result ⟨(1400), 0⟩
  | .error _ => false

namespace CTCRefundableCapTestsCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [(Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.constant true))), (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.constant true))) (Predicate.constant true))), (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.constant true))), (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.constant true)))])
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(1400), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_1
end CTCRefundableCapTestsCase2

#guard match eval CTCRefundableCapTestsCase2.output with
  | .ok result => equalValue result ⟨(2800), 0⟩
  | .error _ => false

namespace CTCRefundableCapTestsCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [(Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.constant true))), (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.constant true)))])
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(1400), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_1
end CTCRefundableCapTestsCase3

#guard match eval CTCRefundableCapTestsCase3.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false
