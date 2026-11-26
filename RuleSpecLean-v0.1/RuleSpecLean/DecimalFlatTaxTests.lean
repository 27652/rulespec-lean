import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace FlatTaxCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(0), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase0

#guard match eval FlatTaxCase0.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace FlatTaxCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(999), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase1

#guard match eval FlatTaxCase1.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace FlatTaxCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(1000), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase2

#guard match eval FlatTaxCase2.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace FlatTaxCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(1001), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase3

#guard match eval FlatTaxCase3.output with
  | .ok result => equalValue result ⟨(1), 0⟩
  | .error _ => false

namespace FlatTaxCase4
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(2999), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase4

#guard match eval FlatTaxCase4.output with
  | .ok result => equalValue result ⟨(200), 0⟩
  | .error _ => false

namespace FlatTaxCase5
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(3000), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase5

#guard match eval FlatTaxCase5.output with
  | .ok result => equalValue result ⟨(400), 0⟩
  | .error _ => false

namespace FlatTaxCase6
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(3001), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase6

#guard match eval FlatTaxCase6.output with
  | .ok result => equalValue result ⟨(401), 0⟩
  | .error _ => false

namespace FlatTaxCase7
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(497738), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase7

#guard match eval FlatTaxCase7.output with
  | .ok result => equalValue result ⟨(99348), 0⟩
  | .error _ => false

namespace FlatTaxCase8
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(466471), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase8

#guard match eval FlatTaxCase8.output with
  | .ok result => equalValue result ⟨(93095), 0⟩
  | .error _ => false

namespace FlatTaxCase9
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(33221), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase9

#guard match eval FlatTaxCase9.output with
  | .ok result => equalValue result ⟨(6445), 0⟩
  | .error _ => false

namespace FlatTaxCase10
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(654227), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase10

#guard match eval FlatTaxCase10.output with
  | .ok result => equalValue result ⟨(130646), 0⟩
  | .error _ => false

namespace FlatTaxCase11
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(703789), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase11

#guard match eval FlatTaxCase11.output with
  | .ok result => equalValue result ⟨(140558), 0⟩
  | .error _ => false

namespace FlatTaxCase12
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(84960), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase12

#guard match eval FlatTaxCase12.output with
  | .ok result => equalValue result ⟨(16792), 0⟩
  | .error _ => false

namespace FlatTaxCase13
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(897353), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase13

#guard match eval FlatTaxCase13.output with
  | .ok result => equalValue result ⟨(179271), 0⟩
  | .error _ => false

namespace FlatTaxCase14
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(305497), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase14

#guard match eval FlatTaxCase14.output with
  | .ok result => equalValue result ⟨(60900), 0⟩
  | .error _ => false

namespace FlatTaxCase15
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(340532), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase15

#guard match eval FlatTaxCase15.output with
  | .ok result => equalValue result ⟨(67907), 0⟩
  | .error _ => false

namespace FlatTaxCase16
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(670438), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase16

#guard match eval FlatTaxCase16.output with
  | .ok result => equalValue result ⟨(133888), 0⟩
  | .error _ => false

namespace FlatTaxCase17
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(235846), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase17

#guard match eval FlatTaxCase17.output with
  | .ok result => equalValue result ⟨(46970), 0⟩
  | .error _ => false

namespace FlatTaxCase18
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(662975), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase18

#guard match eval FlatTaxCase18.output with
  | .ok result => equalValue result ⟨(132395), 0⟩
  | .error _ => false

namespace FlatTaxCase19
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(656922), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase19

#guard match eval FlatTaxCase19.output with
  | .ok result => equalValue result ⟨(131185), 0⟩
  | .error _ => false

namespace FlatTaxCase20
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(308901), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase20

#guard match eval FlatTaxCase20.output with
  | .ok result => equalValue result ⟨(61581), 0⟩
  | .error _ => false

namespace FlatTaxCase21
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(109153), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase21

#guard match eval FlatTaxCase21.output with
  | .ok result => equalValue result ⟨(21631), 0⟩
  | .error _ => false

namespace FlatTaxCase22
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(427954), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase22

#guard match eval FlatTaxCase22.output with
  | .ok result => equalValue result ⟨(85391), 0⟩
  | .error _ => false

namespace FlatTaxCase23
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(361836), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase23

#guard match eval FlatTaxCase23.output with
  | .ok result => equalValue result ⟨(72168), 0⟩
  | .error _ => false

namespace FlatTaxCase24
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(258359), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase24

#guard match eval FlatTaxCase24.output with
  | .ok result => equalValue result ⟨(51472), 0⟩
  | .error _ => false

namespace FlatTaxCase25
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(570273), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase25

#guard match eval FlatTaxCase25.output with
  | .ok result => equalValue result ⟨(113855), 0⟩
  | .error _ => false

namespace FlatTaxCase26
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(826608), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase26

#guard match eval FlatTaxCase26.output with
  | .ok result => equalValue result ⟨(165122), 0⟩
  | .error _ => false

namespace FlatTaxCase27
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(134613), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase27

#guard match eval FlatTaxCase27.output with
  | .ok result => equalValue result ⟨(26723), 0⟩
  | .error _ => false

namespace FlatTaxCase28
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(561960), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase28

#guard match eval FlatTaxCase28.output with
  | .ok result => equalValue result ⟨(112192), 0⟩
  | .error _ => false

namespace FlatTaxCase29
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(684563), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase29

#guard match eval FlatTaxCase29.output with
  | .ok result => equalValue result ⟨(136713), 0⟩
  | .error _ => false

namespace FlatTaxCase30
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(596457), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase30

#guard match eval FlatTaxCase30.output with
  | .ok result => equalValue result ⟨(119092), 0⟩
  | .error _ => false

namespace FlatTaxCase31
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(894986), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase31

#guard match eval FlatTaxCase31.output with
  | .ok result => equalValue result ⟨(178798), 0⟩
  | .error _ => false

namespace FlatTaxCase32
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(425233), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase32

#guard match eval FlatTaxCase32.output with
  | .ok result => equalValue result ⟨(84847), 0⟩
  | .error _ => false

namespace FlatTaxCase33
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(412881), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase33

#guard match eval FlatTaxCase33.output with
  | .ok result => equalValue result ⟨(82377), 0⟩
  | .error _ => false

namespace FlatTaxCase34
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(726223), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase34

#guard match eval FlatTaxCase34.output with
  | .ok result => equalValue result ⟨(145045), 0⟩
  | .error _ => false

namespace FlatTaxCase35
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(386287), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase35

#guard match eval FlatTaxCase35.output with
  | .ok result => equalValue result ⟨(77058), 0⟩
  | .error _ => false

namespace FlatTaxCase36
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(389362), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase36

#guard match eval FlatTaxCase36.output with
  | .ok result => equalValue result ⟨(77673), 0⟩
  | .error _ => false

namespace FlatTaxCase37
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(214224), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase37

#guard match eval FlatTaxCase37.output with
  | .ok result => equalValue result ⟨(42645), 0⟩
  | .error _ => false

namespace FlatTaxCase38
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(517329), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase38

#guard match eval FlatTaxCase38.output with
  | .ok result => equalValue result ⟨(103266), 0⟩
  | .error _ => false

namespace FlatTaxCase39
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(874012), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase39

#guard match eval FlatTaxCase39.output with
  | .ok result => equalValue result ⟨(174603), 0⟩
  | .error _ => false

namespace FlatTaxCase40
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(78609), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase40

#guard match eval FlatTaxCase40.output with
  | .ok result => equalValue result ⟨(15522), 0⟩
  | .error _ => false

namespace FlatTaxCase41
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(600544), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase41

#guard match eval FlatTaxCase41.output with
  | .ok result => equalValue result ⟨(119909), 0⟩
  | .error _ => false

namespace FlatTaxCase42
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(761609), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase42

#guard match eval FlatTaxCase42.output with
  | .ok result => equalValue result ⟨(152122), 0⟩
  | .error _ => false

namespace FlatTaxCase43
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(247899), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase43

#guard match eval FlatTaxCase43.output with
  | .ok result => equalValue result ⟨(49380), 0⟩
  | .error _ => false

namespace FlatTaxCase44
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(746558), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase44

#guard match eval FlatTaxCase44.output with
  | .ok result => equalValue result ⟨(149112), 0⟩
  | .error _ => false

namespace FlatTaxCase45
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(810527), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase45

#guard match eval FlatTaxCase45.output with
  | .ok result => equalValue result ⟨(161906), 0⟩
  | .error _ => false

namespace FlatTaxCase46
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(829937), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase46

#guard match eval FlatTaxCase46.output with
  | .ok result => equalValue result ⟨(165788), 0⟩
  | .error _ => false

namespace FlatTaxCase47
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(110773), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase47

#guard match eval FlatTaxCase47.output with
  | .ok result => equalValue result ⟨(21955), 0⟩
  | .error _ => false

namespace FlatTaxCase48
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(368812), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase48

#guard match eval FlatTaxCase48.output with
  | .ok result => equalValue result ⟨(73563), 0⟩
  | .error _ => false

namespace FlatTaxCase49
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(631587), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase49

#guard match eval FlatTaxCase49.output with
  | .ok result => equalValue result ⟨(126118), 0⟩
  | .error _ => false

namespace FlatTaxCase50
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(417506), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase50

#guard match eval FlatTaxCase50.output with
  | .ok result => equalValue result ⟨(83302), 0⟩
  | .error _ => false

namespace FlatTaxCase51
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(268583), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase51

#guard match eval FlatTaxCase51.output with
  | .ok result => equalValue result ⟨(53517), 0⟩
  | .error _ => false

namespace FlatTaxCase52
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(551351), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase52

#guard match eval FlatTaxCase52.output with
  | .ok result => equalValue result ⟨(110071), 0⟩
  | .error _ => false

namespace FlatTaxCase53
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(383524), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase53

#guard match eval FlatTaxCase53.output with
  | .ok result => equalValue result ⟨(76505), 0⟩
  | .error _ => false

namespace FlatTaxCase54
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(272893), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase54

#guard match eval FlatTaxCase54.output with
  | .ok result => equalValue result ⟨(54379), 0⟩
  | .error _ => false

namespace FlatTaxCase55
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(38213), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase55

#guard match eval FlatTaxCase55.output with
  | .ok result => equalValue result ⟨(7443), 0⟩
  | .error _ => false

namespace FlatTaxCase56
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(436703), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase56

#guard match eval FlatTaxCase56.output with
  | .ok result => equalValue result ⟨(87141), 0⟩
  | .error _ => false

namespace FlatTaxCase57
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(310510), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase57

#guard match eval FlatTaxCase57.output with
  | .ok result => equalValue result ⟨(61902), 0⟩
  | .error _ => false

namespace FlatTaxCase58
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(29497), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase58

#guard match eval FlatTaxCase58.output with
  | .ok result => equalValue result ⟨(5700), 0⟩
  | .error _ => false

namespace FlatTaxCase59
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(185659), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase59

#guard match eval FlatTaxCase59.output with
  | .ok result => equalValue result ⟨(36932), 0⟩
  | .error _ => false

namespace FlatTaxCase60
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(481267), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase60

#guard match eval FlatTaxCase60.output with
  | .ok result => equalValue result ⟨(96054), 0⟩
  | .error _ => false

namespace FlatTaxCase61
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(355466), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase61

#guard match eval FlatTaxCase61.output with
  | .ok result => equalValue result ⟨(70894), 0⟩
  | .error _ => false

namespace FlatTaxCase62
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(190077), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase62

#guard match eval FlatTaxCase62.output with
  | .ok result => equalValue result ⟨(37816), 0⟩
  | .error _ => false

namespace FlatTaxCase63
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(139330), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase63

#guard match eval FlatTaxCase63.output with
  | .ok result => equalValue result ⟨(27666), 0⟩
  | .error _ => false

namespace FlatTaxCase64
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(142048), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase64

#guard match eval FlatTaxCase64.output with
  | .ok result => equalValue result ⟨(28210), 0⟩
  | .error _ => false

namespace FlatTaxCase65
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(221754), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase65

#guard match eval FlatTaxCase65.output with
  | .ok result => equalValue result ⟨(44151), 0⟩
  | .error _ => false

namespace FlatTaxCase66
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(983176), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase66

#guard match eval FlatTaxCase66.output with
  | .ok result => equalValue result ⟨(196436), 0⟩
  | .error _ => false

namespace FlatTaxCase67
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(652866), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase67

#guard match eval FlatTaxCase67.output with
  | .ok result => equalValue result ⟨(130374), 0⟩
  | .error _ => false

namespace FlatTaxCase68
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(358407), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase68

#guard match eval FlatTaxCase68.output with
  | .ok result => equalValue result ⟨(71482), 0⟩
  | .error _ => false

namespace FlatTaxCase69
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(831027), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase69

#guard match eval FlatTaxCase69.output with
  | .ok result => equalValue result ⟨(166006), 0⟩
  | .error _ => false

namespace FlatTaxCase70
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(931286), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase70

#guard match eval FlatTaxCase70.output with
  | .ok result => equalValue result ⟨(186058), 0⟩
  | .error _ => false

namespace FlatTaxCase71
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(865877), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase71

#guard match eval FlatTaxCase71.output with
  | .ok result => equalValue result ⟨(172976), 0⟩
  | .error _ => false

namespace FlatTaxCase72
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(817939), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase72

#guard match eval FlatTaxCase72.output with
  | .ok result => equalValue result ⟨(163388), 0⟩
  | .error _ => false

namespace FlatTaxCase73
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(486949), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase73

#guard match eval FlatTaxCase73.output with
  | .ok result => equalValue result ⟨(97190), 0⟩
  | .error _ => false

namespace FlatTaxCase74
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(650680), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase74

#guard match eval FlatTaxCase74.output with
  | .ok result => equalValue result ⟨(129936), 0⟩
  | .error _ => false

namespace FlatTaxCase75
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(810032), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase75

#guard match eval FlatTaxCase75.output with
  | .ok result => equalValue result ⟨(161807), 0⟩
  | .error _ => false

namespace FlatTaxCase76
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(354614), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase76

#guard match eval FlatTaxCase76.output with
  | .ok result => equalValue result ⟨(70723), 0⟩
  | .error _ => false

namespace FlatTaxCase77
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(422325), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase77

#guard match eval FlatTaxCase77.output with
  | .ok result => equalValue result ⟨(84265), 0⟩
  | .error _ => false

namespace FlatTaxCase78
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(634662), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase78

#guard match eval FlatTaxCase78.output with
  | .ok result => equalValue result ⟨(126733), 0⟩
  | .error _ => false

namespace FlatTaxCase79
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(788725), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase79

#guard match eval FlatTaxCase79.output with
  | .ok result => equalValue result ⟨(157545), 0⟩
  | .error _ => false

namespace FlatTaxCase80
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(601381), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase80

#guard match eval FlatTaxCase80.output with
  | .ok result => equalValue result ⟨(120077), 0⟩
  | .error _ => false

namespace FlatTaxCase81
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(820162), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase81

#guard match eval FlatTaxCase81.output with
  | .ok result => equalValue result ⟨(163833), 0⟩
  | .error _ => false

namespace FlatTaxCase82
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(474693), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase82

#guard match eval FlatTaxCase82.output with
  | .ok result => equalValue result ⟨(94739), 0⟩
  | .error _ => false

namespace FlatTaxCase83
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(451377), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase83

#guard match eval FlatTaxCase83.output with
  | .ok result => equalValue result ⟨(90076), 0⟩
  | .error _ => false

namespace FlatTaxCase84
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(97552), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase84

#guard match eval FlatTaxCase84.output with
  | .ok result => equalValue result ⟨(19311), 0⟩
  | .error _ => false

namespace FlatTaxCase85
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(873758), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase85

#guard match eval FlatTaxCase85.output with
  | .ok result => equalValue result ⟨(174552), 0⟩
  | .error _ => false

namespace FlatTaxCase86
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(458692), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase86

#guard match eval FlatTaxCase86.output with
  | .ok result => equalValue result ⟨(91539), 0⟩
  | .error _ => false

namespace FlatTaxCase87
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(743440), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase87

#guard match eval FlatTaxCase87.output with
  | .ok result => equalValue result ⟨(148488), 0⟩
  | .error _ => false

namespace FlatTaxCase88
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(551714), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase88

#guard match eval FlatTaxCase88.output with
  | .ok result => equalValue result ⟨(110143), 0⟩
  | .error _ => false

namespace FlatTaxCase89
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(604), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase89

#guard match eval FlatTaxCase89.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace FlatTaxCase90
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(518272), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase90

#guard match eval FlatTaxCase90.output with
  | .ok result => equalValue result ⟨(103455), 0⟩
  | .error _ => false

namespace FlatTaxCase91
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(142639), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase91

#guard match eval FlatTaxCase91.output with
  | .ok result => equalValue result ⟨(28328), 0⟩
  | .error _ => false

namespace FlatTaxCase92
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(622967), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase92

#guard match eval FlatTaxCase92.output with
  | .ok result => equalValue result ⟨(124394), 0⟩
  | .error _ => false

namespace FlatTaxCase93
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(677322), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase93

#guard match eval FlatTaxCase93.output with
  | .ok result => equalValue result ⟨(135265), 0⟩
  | .error _ => false

namespace FlatTaxCase94
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(630513), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase94

#guard match eval FlatTaxCase94.output with
  | .ok result => equalValue result ⟨(125903), 0⟩
  | .error _ => false

namespace FlatTaxCase95
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(42047), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase95

#guard match eval FlatTaxCase95.output with
  | .ok result => equalValue result ⟨(8210), 0⟩
  | .error _ => false

namespace FlatTaxCase96
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(558323), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase96

#guard match eval FlatTaxCase96.output with
  | .ok result => equalValue result ⟨(111465), 0⟩
  | .error _ => false

namespace FlatTaxCase97
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(210841), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase97

#guard match eval FlatTaxCase97.output with
  | .ok result => equalValue result ⟨(41969), 0⟩
  | .error _ => false

namespace FlatTaxCase98
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(568754), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase98

#guard match eval FlatTaxCase98.output with
  | .ok result => equalValue result ⟨(113551), 0⟩
  | .error _ => false

namespace FlatTaxCase99
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(918788), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase99

#guard match eval FlatTaxCase99.output with
  | .ok result => equalValue result ⟨(183558), 0⟩
  | .error _ => false

namespace FlatTaxCase100
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(583454), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase100

#guard match eval FlatTaxCase100.output with
  | .ok result => equalValue result ⟨(116491), 0⟩
  | .error _ => false

namespace FlatTaxCase101
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(87976), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase101

#guard match eval FlatTaxCase101.output with
  | .ok result => equalValue result ⟨(17396), 0⟩
  | .error _ => false

namespace FlatTaxCase102
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(440442), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase102

#guard match eval FlatTaxCase102.output with
  | .ok result => equalValue result ⟨(87889), 0⟩
  | .error _ => false

namespace FlatTaxCase103
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(673037), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase103

#guard match eval FlatTaxCase103.output with
  | .ok result => equalValue result ⟨(134408), 0⟩
  | .error _ => false

namespace FlatTaxCase104
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(805110), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase104

#guard match eval FlatTaxCase104.output with
  | .ok result => equalValue result ⟨(160822), 0⟩
  | .error _ => false

namespace FlatTaxCase105
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(292404), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase105

#guard match eval FlatTaxCase105.output with
  | .ok result => equalValue result ⟨(58281), 0⟩
  | .error _ => false

namespace FlatTaxCase106
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.lit ⟨(732989), 0⟩)
def rule_1 : Expr := (Expr.extreme true (Expr.lit ⟨(0), 0⟩) (Expr.binary .sub rule_0 (Expr.lookup [((0), ⟨(1000), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def rule_2 : Expr := (Expr.choose (Predicate.compare .gte rule_0 (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩))) (Expr.lookup [((0), ⟨(2), 1⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(1), 1⟩)] (Expr.lit ⟨(0), 0⟩)))
def rule_3 : Expr := (Expr.rounded 0 .ceil (Expr.binary .mul rule_1 rule_2))
def output : Expr := rule_3
end FlatTaxCase106

#guard match eval FlatTaxCase106.output with
  | .ok result => equalValue result ⟨(146398), 0⟩
  | .error _ => false
