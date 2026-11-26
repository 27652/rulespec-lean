import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel

namespace SNAPMembershipCase0
open RuleSpecLean.DecimalModel

def output : Predicate := (Predicate.compare .gt (Expr.countWhere [(Predicate.compareBool true (some true) (some true))]) (Expr.lit ⟨(0), 0⟩))
end SNAPMembershipCase0

#guard match evalPredicate SNAPMembershipCase0.output with
  | .ok value => value == true
  | .error _ => false


namespace SNAPMembershipCase1
open RuleSpecLean.DecimalModel

def output : Predicate := (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩))
end SNAPMembershipCase1

#guard match evalPredicate SNAPMembershipCase1.output with
  | .ok value => value == false
  | .error _ => false
