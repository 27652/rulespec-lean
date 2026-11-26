import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace CTCAfterAdvanceTestsCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [])
def rule_1 : Expr := (Expr.countWhere [])
def rule_2 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(2200), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.binary .mul rule_1 (Expr.lookup [((0), ⟨(500), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.binary .sub (Expr.countWhere []) (Expr.countWhere []))
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_2 (Expr.binary .mul rule_3 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_5 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(100000), 0⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_7 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_8 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_6 rule_7)
def rule_9 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_5 rule_8)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def rule_10 : Expr := (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.orElse (Predicate.compare .gte (Expr.lit ⟨(12), 0⟩) (Expr.lookup [((0), ⟨(12), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.orElse (Predicate.compareBool true none (some true)) (Predicate.constant false))) (Predicate.constant true))) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.constant true))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_4 rule_9)) (Expr.lit ⟨(0), 0⟩))
def rule_11 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_10 (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_11
end CTCAfterAdvanceTestsCase0

#guard match eval CTCAfterAdvanceTestsCase0.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace CTCAfterAdvanceTestsCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [(Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.constant true)))])
def rule_1 : Expr := (Expr.countWhere [(Predicate.orElse (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some true) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true none (some true))) (Predicate.constant true))) (Predicate.orElse (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true)))) (Predicate.constant true))) (Predicate.constant false)))])
def rule_2 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(2200), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.binary .mul rule_1 (Expr.lookup [((0), ⟨(500), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.binary .sub (Expr.countWhere []) (Expr.countWhere []))
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_2 (Expr.binary .mul rule_3 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_5 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(100000), 0⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_7 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_8 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_6 rule_7)
def rule_9 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_5 rule_8)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def rule_10 : Expr := (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.orElse (Predicate.compare .gte (Expr.lit ⟨(12), 0⟩) (Expr.lookup [((0), ⟨(12), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.orElse (Predicate.compareBool true none (some true)) (Predicate.constant false))) (Predicate.constant true))) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.constant true))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_4 rule_9)) (Expr.lit ⟨(0), 0⟩))
def rule_11 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_10 (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_11
end CTCAfterAdvanceTestsCase1

#guard match eval CTCAfterAdvanceTestsCase1.output with
  | .ok result => equalValue result ⟨(2200), 0⟩
  | .error _ => false

namespace CTCAfterAdvanceTestsCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [(Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.constant true))), (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.constant true))), (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.constant true)))])
def rule_1 : Expr := (Expr.countWhere [(Predicate.orElse (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some true) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true none (some true))) (Predicate.constant true))) (Predicate.orElse (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true)))) (Predicate.constant true))) (Predicate.constant false))), (Predicate.orElse (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.orElse (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true)))) (Predicate.constant true))) (Predicate.constant false))), (Predicate.orElse (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some true) (some true))) (Predicate.constant true))) (Predicate.orElse (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true none (some true)) (Predicate.constant true)))) (Predicate.constant true))) (Predicate.constant false)))])
def rule_2 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(2200), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.binary .mul rule_1 (Expr.lookup [((0), ⟨(500), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.binary .sub (Expr.countWhere []) (Expr.countWhere []))
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_2 (Expr.binary .mul rule_3 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_5 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(40000001), 2⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_7 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_8 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_6 rule_7)
def rule_9 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_5 rule_8)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def rule_10 : Expr := (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.orElse (Predicate.compare .gte (Expr.lit ⟨(12), 0⟩) (Expr.lookup [((0), ⟨(12), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.orElse (Predicate.compareBool true none (some true)) (Predicate.constant false))) (Predicate.constant true))) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.constant true))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_4 rule_9)) (Expr.lit ⟨(0), 0⟩))
def rule_11 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_10 (Expr.lit ⟨(100), 0⟩)))
def output : Expr := rule_11
end CTCAfterAdvanceTestsCase2

#guard match eval CTCAfterAdvanceTestsCase2.output with
  | .ok result => equalValue result ⟨(2550), 0⟩
  | .error _ => false

namespace CTCAfterAdvanceTestsCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [(Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.constant true)))])
def rule_1 : Expr := (Expr.countWhere [(Predicate.orElse (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some true) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true none (some true))) (Predicate.constant true))) (Predicate.orElse (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true)))) (Predicate.constant true))) (Predicate.constant false)))])
def rule_2 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(2200), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.binary .mul rule_1 (Expr.lookup [((0), ⟨(500), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.binary .sub (Expr.countWhere []) (Expr.countWhere []))
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_2 (Expr.binary .mul rule_3 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_5 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(100000), 0⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_7 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_8 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_6 rule_7)
def rule_9 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_5 rule_8)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def rule_10 : Expr := (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.orElse (Predicate.compare .gte (Expr.lit ⟨(12), 0⟩) (Expr.lookup [((0), ⟨(12), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.orElse (Predicate.compareBool true none (some true)) (Predicate.constant false))) (Predicate.constant true))) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.constant true))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_4 rule_9)) (Expr.lit ⟨(0), 0⟩))
def rule_11 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_10 (Expr.lit ⟨(3000), 0⟩)))
def output : Expr := rule_11
end CTCAfterAdvanceTestsCase3

#guard match eval CTCAfterAdvanceTestsCase3.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace CTCAfterAdvanceTestsCase4
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [(Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.constant true)))])
def rule_1 : Expr := (Expr.countWhere [(Predicate.orElse (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some true) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true none (some true))) (Predicate.constant true))) (Predicate.orElse (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.negate (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true)))) (Predicate.constant true))) (Predicate.constant false)))])
def rule_2 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(2200), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.binary .mul rule_1 (Expr.lookup [((0), ⟨(500), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.binary .sub (Expr.countWhere []) (Expr.countWhere []))
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_2 (Expr.binary .mul rule_3 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_5 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(100000), 0⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_7 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_8 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_6 rule_7)
def rule_9 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_5 rule_8)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def rule_10 : Expr := (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.orElse (Predicate.compare .gte (Expr.lit ⟨(12), 0⟩) (Expr.lookup [((0), ⟨(12), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.orElse (Predicate.compareBool true none (some true)) (Predicate.constant false))) (Predicate.constant true))) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some true) (some true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.constant true))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_4 rule_9)) (Expr.lit ⟨(0), 0⟩))
def rule_11 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_10 (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_11
end CTCAfterAdvanceTestsCase4

#guard match eval CTCAfterAdvanceTestsCase4.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace CTCAfterAdvanceTestsCase5
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [])
def rule_1 : Expr := (Expr.countWhere [])
def rule_2 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(2200), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.binary .mul rule_1 (Expr.lookup [((0), ⟨(500), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.binary .sub (Expr.countWhere [(Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compare .lt (Expr.lit ⟨(16), 0⟩) (Expr.lookup [((0), ⟨(17), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))), (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compare .lt (Expr.lit ⟨(17), 0⟩) (Expr.lookup [((0), ⟨(17), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true)))]) (Expr.countWhere [(Predicate.compareBool true (some false) (some true)), (Predicate.compareBool true (some false) (some true))]))
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) rule_2 (Expr.binary .mul rule_3 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_5 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(7500001), 2⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_7 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_8 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) rule_6 rule_7)
def rule_9 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_5 rule_8)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def rule_10 : Expr := (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.orElse (Predicate.compare .gte (Expr.lit ⟨(12), 0⟩) (Expr.lookup [((0), ⟨(12), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.orElse (Predicate.compareBool true none (some true)) (Predicate.constant false))) (Predicate.constant true))) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.constant true))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_4 rule_9)) (Expr.lit ⟨(0), 0⟩))
def rule_11 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_10 (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_11
end CTCAfterAdvanceTestsCase5

#guard match eval CTCAfterAdvanceTestsCase5.output with
  | .ok result => equalValue result ⟨(950), 0⟩
  | .error _ => false

namespace CTCAfterAdvanceTestsCase6
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.countWhere [])
def rule_1 : Expr := (Expr.countWhere [])
def rule_2 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(2200), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.binary .mul rule_1 (Expr.lookup [((0), ⟨(500), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.binary .sub (Expr.countWhere [(Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compare .lt (Expr.lit ⟨(16), 0⟩) (Expr.lookup [((0), ⟨(17), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true)))]) (Expr.countWhere [(Predicate.compareBool true (some true) (some true))]))
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) rule_2 (Expr.binary .mul rule_3 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_5 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(70000), 0⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_7 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_8 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) rule_6 rule_7)
def rule_9 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_5 rule_8)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def rule_10 : Expr := (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.orElse (Predicate.compare .gte (Expr.lit ⟨(12), 0⟩) (Expr.lookup [((0), ⟨(12), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.orElse (Predicate.compareBool true none (some true)) (Predicate.constant false))) (Predicate.constant true))) (Predicate.andAlso (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.constant true))) (Predicate.constant true))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_4 rule_9)) (Expr.lit ⟨(0), 0⟩))
def rule_11 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_10 (Expr.lit ⟨(0), 0⟩)))
def output : Expr := rule_11
end CTCAfterAdvanceTestsCase6

#guard match eval CTCAfterAdvanceTestsCase6.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false
