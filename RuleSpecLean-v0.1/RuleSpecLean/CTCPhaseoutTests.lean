import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace CTCPhaseoutTestsCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(39999999), 2⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_2 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_1 rule_2)
def rule_4 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 rule_3)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def output : Expr := rule_4
end CTCPhaseoutTestsCase0

#guard match eval CTCPhaseoutTestsCase0.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace CTCPhaseoutTestsCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(400000), 0⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_2 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_1 rule_2)
def rule_4 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 rule_3)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def output : Expr := rule_4
end CTCPhaseoutTestsCase1

#guard match eval CTCPhaseoutTestsCase1.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace CTCPhaseoutTestsCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(40000001), 2⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_2 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_1 rule_2)
def rule_4 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 rule_3)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def output : Expr := rule_4
end CTCPhaseoutTestsCase2

#guard match eval CTCPhaseoutTestsCase2.output with
  | .ok result => equalValue result ⟨(50), 0⟩
  | .error _ => false

namespace CTCPhaseoutTestsCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(20100001), 2⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_2 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) rule_1 rule_2)
def rule_4 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 rule_3)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def output : Expr := rule_4
end CTCPhaseoutTestsCase3

#guard match eval CTCPhaseoutTestsCase3.output with
  | .ok result => equalValue result ⟨(100), 0⟩
  | .error _ => false

namespace CTCPhaseoutTestsCase4
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(111000), 0⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_2 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) rule_1 rule_2)
def rule_4 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 rule_3)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def output : Expr := rule_4
end CTCPhaseoutTestsCase4

#guard match eval CTCPhaseoutTestsCase4.output with
  | .ok result => equalValue result ⟨(50), 0⟩
  | .error _ => false

namespace CTCPhaseoutTestsCase5
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(5500001), 2⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_2 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some true) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) rule_1 rule_2)
def rule_4 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 rule_3)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def output : Expr := rule_4
end CTCPhaseoutTestsCase5

#guard match eval CTCPhaseoutTestsCase5.output with
  | .ok result => equalValue result ⟨(50), 0⟩
  | .error _ => false

namespace CTCPhaseoutTestsCase6
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(7500001), 2⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(400000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(200000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_2 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(110000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.lookup [((0), ⟨(55000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(75000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) rule_1 rule_2)
def rule_4 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(50), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.rounded 0 .ceil (Expr.binary .div (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 rule_3)) (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩)))))
def output : Expr := rule_4
end CTCPhaseoutTestsCase6

#guard match eval CTCPhaseoutTestsCase6.output with
  | .ok result => equalValue result ⟨(50), 0⟩
  | .error _ => false
