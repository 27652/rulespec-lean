import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel

namespace SNAPPublishedOutput0
open RuleSpecLean.DecimalModel

def output : Expr := (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))
end SNAPPublishedOutput0

#guard match eval SNAPPublishedOutput0.output with
  | .ok value => equalValue value ⟨(2), 1⟩
  | .error _ => false


namespace SNAPPublishedOutput1
open RuleSpecLean.DecimalModel

def output : Expr := (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩))
end SNAPPublishedOutput1

#guard match eval SNAPPublishedOutput1.output with
  | .ok value => equalValue value ⟨(35), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput2
open RuleSpecLean.DecimalModel

def output : Expr := (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))
end SNAPPublishedOutput2

#guard match eval SNAPPublishedOutput2.output with
  | .ok value => equalValue value ⟨(5), 1⟩
  | .error _ => false


namespace SNAPPublishedOutput3
open RuleSpecLean.DecimalModel

def output : Expr := (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩))
end SNAPPublishedOutput3

#guard match eval SNAPPublishedOutput3.output with
  | .ok value => equalValue value ⟨(3), 1⟩
  | .error _ => false


namespace SNAPPublishedOutput4
open RuleSpecLean.DecimalModel

def output : Expr := (Expr.lookup [((0), ⟨(10), 0⟩)] (Expr.lit ⟨(0), 0⟩))
end SNAPPublishedOutput4

#guard match eval SNAPPublishedOutput4.output with
  | .ok value => equalValue value ⟨(10), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput5
open RuleSpecLean.DecimalModel

def output : Expr := (Expr.lookup [((0), ⟨(8), 2⟩)] (Expr.lit ⟨(0), 0⟩))
end SNAPPublishedOutput5

#guard match eval SNAPPublishedOutput5.output with
  | .ok value => equalValue value ⟨(8), 2⟩
  | .error _ => false


namespace SNAPPublishedOutput6
open RuleSpecLean.DecimalModel

def output : Expr := (Expr.lookup [((0), ⟨(2), 0⟩)] (Expr.lit ⟨(0), 0⟩))
end SNAPPublishedOutput6

#guard match eval SNAPPublishedOutput6.output with
  | .ok value => equalValue value ⟨(2), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput7
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(1000), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def output : Expr := rule_0
end SNAPPublishedOutput7

#guard match eval SNAPPublishedOutput7.output with
  | .ok value => equalValue value ⟨(1000), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput8
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(1000), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def output : Expr := rule_0
end SNAPPublishedOutput8

#guard match eval SNAPPublishedOutput8.output with
  | .ok value => equalValue value ⟨(200), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput9
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def output : Expr := rule_0
end SNAPPublishedOutput9

#guard match eval SNAPPublishedOutput9.output with
  | .ok value => equalValue value ⟨(0), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput10
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def output : Expr := rule_0
end SNAPPublishedOutput10

#guard match eval SNAPPublishedOutput10.output with
  | .ok value => equalValue value ⟨(0), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput11
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(1000), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(1000), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_3 : Expr := rule_2
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_5 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_6 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_0 rule_1) rule_3) rule_4) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_5))
def output : Expr := rule_6
end SNAPPublishedOutput11

#guard match eval SNAPPublishedOutput11.output with
  | .ok value => equalValue value ⟨(591), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput12
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_1 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(1000), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_2 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(1000), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_4 : Expr := rule_3
def rule_5 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_1 rule_2) rule_4) rule_5) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_0))
def rule_7 : Expr := (Expr.choose (Predicate.compare .gt rule_0 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(500), 0⟩) (Expr.binary .mul rule_6 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def output : Expr := rule_7
end SNAPPublishedOutput12

#guard match eval SNAPPublishedOutput12.output with
  | .ok value => equalValue value ⟨(205), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput13
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_1 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(1000), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_2 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(1000), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_4 : Expr := rule_3
def rule_5 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_1 rule_2) rule_4) rule_5) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_0))
def rule_7 : Expr := (Expr.choose (Predicate.compare .gt rule_0 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(500), 0⟩) (Expr.binary .mul rule_6 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_7 (Expr.extreme false rule_7 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def output : Expr := rule_8
end SNAPPublishedOutput13

#guard match eval SNAPPublishedOutput13.output with
  | .ok value => equalValue value ⟨(205), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput14
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(1000), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(1000), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_3 : Expr := rule_2
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_5 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_6 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_0 rule_1) rule_3) rule_4) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_5))
def rule_7 : Expr := (Expr.choose (Predicate.compare .gt rule_5 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(500), 0⟩) (Expr.binary .mul rule_6 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_7 (Expr.extreme false rule_7 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_9 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_6 rule_8))
def output : Expr := rule_9
end SNAPPublishedOutput14

#guard match eval SNAPPublishedOutput14.output with
  | .ok value => equalValue value ⟨(386), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput15
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.lit ⟨(1), 0⟩))
def rule_1 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(8), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def output : Expr := rule_1
end SNAPPublishedOutput15

#guard match eval SNAPPublishedOutput15.output with
  | .ok value => equalValue value ⟨(24), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput16
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.extreme true (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(1), 0⟩)))) (Expr.binary .mul (Expr.extreme true (Expr.binary .sub (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(218), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_1 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(1000), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_2 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(1000), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_4 : Expr := rule_3
def rule_5 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_7 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_1 rule_2) rule_4) rule_5) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_6))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt rule_6 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(500), 0⟩) (Expr.binary .mul rule_7 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_9 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_8 (Expr.extreme false rule_8 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_10 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_7 rule_9))
def rule_11 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.rounded 0 .ceil (Expr.binary .mul rule_10 (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩)))))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .sub rule_0 (Expr.binary .mul rule_10 (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩)))))))
def output : Expr := rule_11
end SNAPPublishedOutput16

#guard match eval SNAPPublishedOutput16.output with
  | .ok value => equalValue value ⟨(182), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput17
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(200), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def output : Expr := rule_0
end SNAPPublishedOutput17

#guard match eval SNAPPublishedOutput17.output with
  | .ok value => equalValue value ⟨(199), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput18
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(500), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_3 : Expr := rule_2
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_5 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(200), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_6 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_0 rule_1) rule_3) rule_4) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_5))
def output : Expr := rule_6
end SNAPPublishedOutput18

#guard match eval SNAPPublishedOutput18.output with
  | .ok value => equalValue value ⟨(92), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput19
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(200), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_1 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(500), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_2 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_4 : Expr := rule_3
def rule_5 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_1 rule_2) rule_4) rule_5) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_0))
def rule_7 : Expr := (Expr.choose (Predicate.compare .gt rule_0 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(900), 0⟩) (Expr.binary .mul rule_6 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def output : Expr := rule_7
end SNAPPublishedOutput19

#guard match eval SNAPPublishedOutput19.output with
  | .ok value => equalValue value ⟨(0), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput20
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(200), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_1 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(500), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_2 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_4 : Expr := rule_3
def rule_5 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_1 rule_2) rule_4) rule_5) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_0))
def rule_7 : Expr := (Expr.choose (Predicate.compare .gt rule_0 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(900), 0⟩) (Expr.binary .mul rule_6 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_7 (Expr.extreme false rule_7 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def output : Expr := rule_8
end SNAPPublishedOutput20

#guard match eval SNAPPublishedOutput20.output with
  | .ok value => equalValue value ⟨(0), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput21
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(500), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_3 : Expr := rule_2
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_5 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(200), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_6 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_0 rule_1) rule_3) rule_4) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_5))
def rule_7 : Expr := (Expr.choose (Predicate.compare .gt rule_5 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(900), 0⟩) (Expr.binary .mul rule_6 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_7 (Expr.extreme false rule_7 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_9 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_6 rule_8))
def output : Expr := rule_9
end SNAPPublishedOutput21

#guard match eval SNAPPublishedOutput21.output with
  | .ok value => equalValue value ⟨(92), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput22
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(900), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_3 : Expr := rule_2
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_5 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_6 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_0 rule_1) rule_3) rule_4) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_5))
def rule_7 : Expr := (Expr.choose (Predicate.compare .gt rule_5 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.binary .mul rule_6 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_7 (Expr.extreme false rule_7 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_9 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_6 rule_8))
def output : Expr := rule_9
end SNAPPublishedOutput22

#guard match eval SNAPPublishedOutput22.output with
  | .ok value => equalValue value ⟨(691), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput23
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.extreme true (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(1), 0⟩)))) (Expr.binary .mul (Expr.extreme true (Expr.binary .sub (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(218), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_1 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(900), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_2 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_4 : Expr := rule_3
def rule_5 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_7 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_1 rule_2) rule_4) rule_5) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_6))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt rule_6 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.binary .mul rule_7 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_9 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_8 (Expr.extreme false rule_8 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_10 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_7 rule_9))
def rule_11 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.rounded 0 .ceil (Expr.binary .mul rule_10 (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩)))))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .sub rule_0 (Expr.binary .mul rule_10 (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩)))))))
def output : Expr := rule_11
end SNAPPublishedOutput23

#guard match eval SNAPPublishedOutput23.output with
  | .ok value => equalValue value ⟨(90), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput24
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(1180), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_1 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_3 : Expr := rule_2
def rule_4 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_5 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_6 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_0 rule_1) rule_3) rule_4) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_5))
def rule_7 : Expr := (Expr.choose (Predicate.compare .gt rule_5 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.binary .mul rule_6 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_7 (Expr.extreme false rule_7 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_9 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_6 rule_8))
def output : Expr := rule_9
end SNAPPublishedOutput24

#guard match eval SNAPPublishedOutput24.output with
  | .ok value => equalValue value ⟨(971), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput25
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.extreme true (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(1), 0⟩)))) (Expr.binary .mul (Expr.extreme true (Expr.binary .sub (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(218), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_1 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(1180), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_2 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_4 : Expr := rule_3
def rule_5 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_7 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_1 rule_2) rule_4) rule_5) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_6))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt rule_6 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.binary .mul rule_7 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_9 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_8 (Expr.extreme false rule_8 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_10 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_7 rule_9))
def rule_11 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.rounded 0 .ceil (Expr.binary .mul rule_10 (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩)))))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .sub rule_0 (Expr.binary .mul rule_10 (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩)))))))
def output : Expr := rule_11
end SNAPPublishedOutput25

#guard match eval SNAPPublishedOutput25.output with
  | .ok value => equalValue value ⟨(6), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput26
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.lit ⟨(1), 0⟩))
def rule_1 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_0 (Expr.lookup [((0), ⟨(8), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def output : Expr := rule_1
end SNAPPublishedOutput26

#guard match eval SNAPPublishedOutput26.output with
  | .ok value => equalValue value ⟨(24), 0⟩
  | .error _ => false


namespace SNAPPublishedOutput27
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.extreme true (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(1), 0⟩)))) (Expr.binary .mul (Expr.extreme true (Expr.binary .sub (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(218), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_1 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(1200), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_2 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_4 : Expr := rule_3
def rule_5 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_7 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_1 rule_2) rule_4) rule_5) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_6))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt rule_6 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.binary .mul rule_7 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_9 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_8 (Expr.extreme false rule_8 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_10 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_7 rule_9))
def rule_11 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.rounded 0 .ceil (Expr.binary .mul rule_10 (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩)))))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .sub rule_0 (Expr.binary .mul rule_10 (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩)))))))
def output : Expr := rule_11
end SNAPPublishedOutput27

#guard match eval SNAPPublishedOutput27.output with
  | .ok value => equalValue value ⟨(0), 0⟩
  | .error _ => false
