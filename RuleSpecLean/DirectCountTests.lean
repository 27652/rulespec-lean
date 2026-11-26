import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace DirectCountCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DirectCountCase0

#guard match eval DirectCountCase0.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace DirectCountCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DirectCountCase1

#guard match eval DirectCountCase1.output with
  | .ok result => equalValue result ⟨(1), 0⟩
  | .error _ => false

namespace DirectCountCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lit ⟨(2), 0⟩) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DirectCountCase2

#guard match eval DirectCountCase2.output with
  | .ok result => equalValue result ⟨(2), 0⟩
  | .error _ => false

namespace DirectCountCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lit ⟨(2), 0⟩) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DirectCountCase3

#guard match eval DirectCountCase3.output with
  | .ok result => equalValue result ⟨(2), 0⟩
  | .error _ => false

namespace RelatedSumCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.sumWhere [])
def output : Expr := rule_0
end RelatedSumCase0

#guard match eval RelatedSumCase0.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace RelatedSumCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.sumWhere [((Predicate.compareBool true (some true) (some true)), (Expr.lit ⟨(315), 2⟩)), ((Predicate.compareBool true (some false) (some true)), Expr.missingInput)])
def output : Expr := rule_0
end RelatedSumCase1

#guard match eval RelatedSumCase1.output with
  | .ok result => equalValue result ⟨(315), 2⟩
  | .error _ => false

namespace RelatedSumCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.sumWhere [((Predicate.compareBool true (some true) (some true)), (Expr.lit ⟨(910), 2⟩)), ((Predicate.compareBool true (some true) (some true)), (Expr.lit ⟨(-104), 2⟩))])
def output : Expr := rule_0
end RelatedSumCase2

#guard match eval RelatedSumCase2.output with
  | .ok result => equalValue result ⟨(806), 2⟩
  | .error _ => false

namespace RelatedSumCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.sumWhere [((Predicate.compareBool true (some true) (some true)), Expr.missingInput)])
def output : Expr := rule_0
end RelatedSumCase3

#guard match eval RelatedSumCase3.output with
  | .error fault => fault == .missingInput
  | .ok _ => false

namespace RelatedSumCase4
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.sumWhere [((Predicate.compareBool true (some true) (some true)), (Expr.lit ⟨(79228162514264337593543950335), 0⟩)), ((Predicate.compareBool true (some true) (some true)), (Expr.lit ⟨(79228162514264337593543950335), 0⟩))])
def output : Expr := rule_0
end RelatedSumCase4

#guard match eval RelatedSumCase4.output with
  | .error fault => fault == .arithmeticOverflow
  | .ok _ => false
