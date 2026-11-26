import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel

namespace SNAPAllotmentCase0
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
def rule_12 : Expr := (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.lit ⟨(1), 0⟩))
def rule_13 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_12 (Expr.lookup [((0), ⟨(8), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_14 : Expr := (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.compare .lt rule_11 (Expr.lookup [((0), ⟨(10), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Expr.lit ⟨(0), 0⟩) (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.compare .lte (Expr.lit ⟨(1), 0⟩) (Expr.lookup [((0), ⟨(2), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.compare .lt rule_11 rule_13) (Predicate.constant true))) rule_13 rule_11))
def output : Expr := rule_14
end SNAPAllotmentCase0

#guard match eval SNAPAllotmentCase0.output with
  | .ok value => equalValue value ⟨(182), 0⟩
  | .error _ => false


namespace SNAPAllotmentCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.extreme true (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(1), 0⟩)))) (Expr.binary .mul (Expr.extreme true (Expr.binary .sub (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(218), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_1 : Expr := (Expr.binary .sub (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(500), 0⟩)) (Expr.lit ⟨(0), 0⟩))
def rule_2 : Expr := (Expr.rounded 0 .floor (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_3 : Expr := (Expr.lookup [((1), ⟨(209), 0⟩), ((2), ⟨(209), 0⟩), ((3), ⟨(209), 0⟩), ((4), ⟨(223), 0⟩), ((5), ⟨(261), 0⟩), ((6), ⟨(299), 0⟩)] (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(6), 0⟩)))
def rule_4 : Expr := rule_3
def rule_5 : Expr := (Expr.choose (Predicate.compareBool true (some false) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lookup [((0), ⟨(35), 0⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(0), 0⟩))
def rule_6 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.extreme false (Expr.lit ⟨(200), 0⟩) (Expr.lookup [((0), ⟨(19899), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_7 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub (Expr.binary .sub rule_1 rule_2) rule_4) rule_5) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩)) rule_6))
def rule_8 : Expr := (Expr.choose (Predicate.compare .gt rule_6 (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .sub (Expr.lit ⟨(900), 0⟩) (Expr.binary .mul rule_7 (Expr.lookup [((0), ⟨(5), 1⟩)] (Expr.lit ⟨(0), 0⟩))))) (Expr.lit ⟨(5), 1⟩)))))
def rule_9 : Expr := (Expr.choose (Predicate.compare .gt (Expr.countWhere []) (Expr.lit ⟨(0), 0⟩)) rule_8 (Expr.extreme false rule_8 (Expr.lookup [((0), ⟨(744), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_10 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_7 rule_9))
def rule_11 : Expr := (Expr.choose (Predicate.compareBool true (some true) (some true)) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.rounded 0 .ceil (Expr.binary .mul rule_10 (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩)))))) (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.binary .sub rule_0 (Expr.binary .mul rule_10 (Expr.lookup [((0), ⟨(3), 1⟩)] (Expr.lit ⟨(0), 0⟩)))))))
def rule_12 : Expr := (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.lit ⟨(1), 0⟩))
def rule_13 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_12 (Expr.lookup [((0), ⟨(8), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_14 : Expr := (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.compare .lt rule_11 (Expr.lookup [((0), ⟨(10), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Expr.lit ⟨(0), 0⟩) (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.compare .lte (Expr.lit ⟨(1), 0⟩) (Expr.lookup [((0), ⟨(2), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.compare .lt rule_11 rule_13) (Predicate.constant true))) rule_13 rule_11))
def output : Expr := rule_14
end SNAPAllotmentCase1

#guard match eval SNAPAllotmentCase1.output with
  | .ok value => equalValue value ⟨(270), 0⟩
  | .error _ => false


namespace SNAPAllotmentCase2
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
def rule_12 : Expr := (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.lit ⟨(1), 0⟩))
def rule_13 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_12 (Expr.lookup [((0), ⟨(8), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_14 : Expr := (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compare .lt rule_11 (Expr.lookup [((0), ⟨(10), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Expr.lit ⟨(0), 0⟩) (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some true) (some true))) (Predicate.andAlso (Predicate.compare .lte (Expr.lit ⟨(1), 0⟩) (Expr.lookup [((0), ⟨(2), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.compare .lt rule_11 rule_13) (Predicate.constant true))) rule_13 rule_11))
def output : Expr := rule_14
end SNAPAllotmentCase2

#guard match eval SNAPAllotmentCase2.output with
  | .ok value => equalValue value ⟨(90), 0⟩
  | .error _ => false


namespace SNAPAllotmentCase3
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
def rule_12 : Expr := (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.lit ⟨(1), 0⟩))
def rule_13 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_12 (Expr.lookup [((0), ⟨(8), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_14 : Expr := (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some false) (some true)) (Predicate.andAlso (Predicate.compare .lt rule_11 (Expr.lookup [((0), ⟨(10), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Expr.lit ⟨(0), 0⟩) (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some false) (some true))) (Predicate.andAlso (Predicate.compare .lte (Expr.lit ⟨(1), 0⟩) (Expr.lookup [((0), ⟨(2), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.compare .lt rule_11 rule_13) (Predicate.constant true))) rule_13 rule_11))
def output : Expr := rule_14
end SNAPAllotmentCase3

#guard match eval SNAPAllotmentCase3.output with
  | .ok value => equalValue value ⟨(24), 0⟩
  | .error _ => false


namespace SNAPAllotmentCase4
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
def rule_12 : Expr := (Expr.lookup [((1), ⟨(298), 0⟩), ((2), ⟨(546), 0⟩), ((3), ⟨(785), 0⟩), ((4), ⟨(994), 0⟩), ((5), ⟨(1183), 0⟩), ((6), ⟨(1421), 0⟩), ((7), ⟨(1571), 0⟩), ((8), ⟨(1789), 0⟩)] (Expr.lit ⟨(1), 0⟩))
def rule_13 : Expr := (Expr.rounded 0 .floor (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .mul rule_12 (Expr.lookup [((0), ⟨(8), 2⟩)] (Expr.lit ⟨(0), 0⟩)))) (Expr.lit ⟨(5), 1⟩)))
def rule_14 : Expr := (Expr.choose (Predicate.andAlso (Predicate.compareBool true (some true) (some true)) (Predicate.andAlso (Predicate.compare .lt rule_11 (Expr.lookup [((0), ⟨(10), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Expr.lit ⟨(0), 0⟩) (Expr.choose (Predicate.andAlso (Predicate.andAlso (Predicate.negate (Predicate.compareBool true (some true) (some true))) (Predicate.andAlso (Predicate.compare .lte (Expr.lit ⟨(1), 0⟩) (Expr.lookup [((0), ⟨(2), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Predicate.constant true))) (Predicate.andAlso (Predicate.compare .lt rule_11 rule_13) (Predicate.constant true))) rule_13 rule_11))
def output : Expr := rule_14
end SNAPAllotmentCase4

#guard match eval SNAPAllotmentCase4.output with
  | .ok value => equalValue value ⟨(0), 0⟩
  | .error _ => false
