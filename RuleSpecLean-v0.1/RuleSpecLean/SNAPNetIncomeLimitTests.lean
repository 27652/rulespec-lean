import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace SNAPNetIncomeLimitTestsCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lookup [((1), ⟨(1215), 0⟩), ((2), ⟨(1644), 0⟩), ((3), ⟨(2072), 0⟩), ((4), ⟨(2500), 0⟩), ((5), ⟨(2929), 0⟩), ((6), ⟨(3357), 0⟩), ((7), ⟨(3785), 0⟩), ((8), ⟨(4214), 0⟩)] (Expr.extreme true (Expr.extreme false (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(1), 0⟩)))) (Expr.binary .mul (Expr.extreme true (Expr.binary .sub (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(429), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def output : Expr := rule_0
end SNAPNetIncomeLimitTestsCase0

#guard match eval SNAPNetIncomeLimitTestsCase0.output with
  | .ok result => equalValue result ⟨(1215), 0⟩
  | .error _ => false

namespace SNAPNetIncomeLimitTestsCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lookup [((1), ⟨(1215), 0⟩), ((2), ⟨(1644), 0⟩), ((3), ⟨(2072), 0⟩), ((4), ⟨(2500), 0⟩), ((5), ⟨(2929), 0⟩), ((6), ⟨(3357), 0⟩), ((7), ⟨(3785), 0⟩), ((8), ⟨(4214), 0⟩)] (Expr.extreme true (Expr.extreme false (Expr.lit ⟨(4), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(1), 0⟩)))) (Expr.binary .mul (Expr.extreme true (Expr.binary .sub (Expr.lit ⟨(4), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(429), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def output : Expr := rule_0
end SNAPNetIncomeLimitTestsCase1

#guard match eval SNAPNetIncomeLimitTestsCase1.output with
  | .ok result => equalValue result ⟨(2500), 0⟩
  | .error _ => false

namespace SNAPNetIncomeLimitTestsCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lookup [((1), ⟨(1215), 0⟩), ((2), ⟨(1644), 0⟩), ((3), ⟨(2072), 0⟩), ((4), ⟨(2500), 0⟩), ((5), ⟨(2929), 0⟩), ((6), ⟨(3357), 0⟩), ((7), ⟨(3785), 0⟩), ((8), ⟨(4214), 0⟩)] (Expr.extreme true (Expr.extreme false (Expr.lit ⟨(8), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(1), 0⟩)))) (Expr.binary .mul (Expr.extreme true (Expr.binary .sub (Expr.lit ⟨(8), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(429), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def output : Expr := rule_0
end SNAPNetIncomeLimitTestsCase2

#guard match eval SNAPNetIncomeLimitTestsCase2.output with
  | .ok result => equalValue result ⟨(4214), 0⟩
  | .error _ => false

namespace SNAPNetIncomeLimitTestsCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lookup [((1), ⟨(1215), 0⟩), ((2), ⟨(1644), 0⟩), ((3), ⟨(2072), 0⟩), ((4), ⟨(2500), 0⟩), ((5), ⟨(2929), 0⟩), ((6), ⟨(3357), 0⟩), ((7), ⟨(3785), 0⟩), ((8), ⟨(4214), 0⟩)] (Expr.extreme true (Expr.extreme false (Expr.lit ⟨(9), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(1), 0⟩)))) (Expr.binary .mul (Expr.extreme true (Expr.binary .sub (Expr.lit ⟨(9), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(429), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def output : Expr := rule_0
end SNAPNetIncomeLimitTestsCase3

#guard match eval SNAPNetIncomeLimitTestsCase3.output with
  | .ok result => equalValue result ⟨(4643), 0⟩
  | .error _ => false

namespace SNAPNetIncomeLimitTestsCase4
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lookup [((1), ⟨(1215), 0⟩), ((2), ⟨(1644), 0⟩), ((3), ⟨(2072), 0⟩), ((4), ⟨(2500), 0⟩), ((5), ⟨(2929), 0⟩), ((6), ⟨(3357), 0⟩), ((7), ⟨(3785), 0⟩), ((8), ⟨(4214), 0⟩)] (Expr.extreme true (Expr.extreme false (Expr.lit ⟨(10), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(1), 0⟩)))) (Expr.binary .mul (Expr.extreme true (Expr.binary .sub (Expr.lit ⟨(10), 0⟩) (Expr.lit ⟨(8), 0⟩)) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(429), 0⟩)] (Expr.lit ⟨(0), 0⟩))))
def output : Expr := rule_0
end SNAPNetIncomeLimitTestsCase4

#guard match eval SNAPNetIncomeLimitTestsCase4.output with
  | .ok result => equalValue result ⟨(5072), 0⟩
  | .error _ => false
