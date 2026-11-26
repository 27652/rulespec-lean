import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace CTCMagiTestsCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(401000), 0⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def output : Expr := rule_0
end CTCMagiTestsCase0

#guard match eval CTCMagiTestsCase0.output with
  | .ok result => equalValue result ⟨(401000), 0⟩
  | .error _ => false

namespace CTCMagiTestsCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def output : Expr := rule_0
end CTCMagiTestsCase1

#guard match eval CTCMagiTestsCase1.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace CTCMagiTestsCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(10010), 2⟩)) (Expr.lit ⟨(2), 2⟩))) (Expr.lit ⟨(30), 2⟩))) (Expr.lit ⟨(405), 2⟩))
def output : Expr := rule_0
end CTCMagiTestsCase2

#guard match eval CTCMagiTestsCase2.output with
  | .ok result => equalValue result ⟨(10447), 2⟩
  | .error _ => false

namespace CTCMagiTestsCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(-1050), 2⟩)) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(2), 0⟩))) (Expr.lit ⟨(825), 2⟩))
def output : Expr := rule_0
end CTCMagiTestsCase3

#guard match eval CTCMagiTestsCase3.output with
  | .ok result => equalValue result ⟨(75), 2⟩
  | .error _ => false

namespace CTCMagiTestsCase4
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(400000), 0⟩)) (Expr.lit ⟨(100), 0⟩))) (Expr.lit ⟨(200), 0⟩))) (Expr.lit ⟨(700), 0⟩))
def output : Expr := rule_0
end CTCMagiTestsCase4

#guard match eval CTCMagiTestsCase4.output with
  | .ok result => equalValue result ⟨(401000), 0⟩
  | .error _ => false
