import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace DecimalCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(1005), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase0

#guard match eval DecimalCase0.output with
  | .ok result => equalValue result ⟨(202), 2⟩
  | .error _ => false

namespace DecimalCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(-1005), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase1

#guard match eval DecimalCase1.output with
  | .ok result => equalValue result ⟨(-202), 2⟩
  | .error _ => false

namespace DecimalCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(1004), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase2

#guard match eval DecimalCase2.output with
  | .ok result => equalValue result ⟨(2), 0⟩
  | .error _ => false

namespace DecimalCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(1015), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase3

#guard match eval DecimalCase3.output with
  | .ok result => equalValue result ⟨(204), 2⟩
  | .error _ => false

namespace DecimalCase4
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(5), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase4

#guard match eval DecimalCase4.output with
  | .ok result => equalValue result ⟨(2), 2⟩
  | .error _ => false

namespace DecimalCase5
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(-5), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase5

#guard match eval DecimalCase5.output with
  | .ok result => equalValue result ⟨(-2), 2⟩
  | .error _ => false

namespace DecimalCase6
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfEven (Expr.lit ⟨(1005), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase6

#guard match eval DecimalCase6.output with
  | .ok result => equalValue result ⟨(2), 0⟩
  | .error _ => false

namespace DecimalCase7
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfEven (Expr.lit ⟨(-1005), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase7

#guard match eval DecimalCase7.output with
  | .ok result => equalValue result ⟨(-2), 0⟩
  | .error _ => false

namespace DecimalCase8
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfEven (Expr.lit ⟨(1004), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase8

#guard match eval DecimalCase8.output with
  | .ok result => equalValue result ⟨(2), 0⟩
  | .error _ => false

namespace DecimalCase9
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfEven (Expr.lit ⟨(1015), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase9

#guard match eval DecimalCase9.output with
  | .ok result => equalValue result ⟨(204), 2⟩
  | .error _ => false

namespace DecimalCase10
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfEven (Expr.lit ⟨(5), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase10

#guard match eval DecimalCase10.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace DecimalCase11
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfEven (Expr.lit ⟨(-5), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase11

#guard match eval DecimalCase11.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace DecimalCase12
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .floor (Expr.lit ⟨(1005), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase12

#guard match eval DecimalCase12.output with
  | .ok result => equalValue result ⟨(2), 0⟩
  | .error _ => false

namespace DecimalCase13
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .floor (Expr.lit ⟨(-1005), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase13

#guard match eval DecimalCase13.output with
  | .ok result => equalValue result ⟨(-202), 2⟩
  | .error _ => false

namespace DecimalCase14
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .floor (Expr.lit ⟨(1004), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase14

#guard match eval DecimalCase14.output with
  | .ok result => equalValue result ⟨(2), 0⟩
  | .error _ => false

namespace DecimalCase15
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .floor (Expr.lit ⟨(1015), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase15

#guard match eval DecimalCase15.output with
  | .ok result => equalValue result ⟨(202), 2⟩
  | .error _ => false

namespace DecimalCase16
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .floor (Expr.lit ⟨(5), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase16

#guard match eval DecimalCase16.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace DecimalCase17
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .floor (Expr.lit ⟨(-5), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase17

#guard match eval DecimalCase17.output with
  | .ok result => equalValue result ⟨(-2), 2⟩
  | .error _ => false

namespace DecimalCase18
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .ceil (Expr.lit ⟨(1005), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase18

#guard match eval DecimalCase18.output with
  | .ok result => equalValue result ⟨(202), 2⟩
  | .error _ => false

namespace DecimalCase19
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .ceil (Expr.lit ⟨(-1005), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase19

#guard match eval DecimalCase19.output with
  | .ok result => equalValue result ⟨(-2), 0⟩
  | .error _ => false

namespace DecimalCase20
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .ceil (Expr.lit ⟨(1004), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase20

#guard match eval DecimalCase20.output with
  | .ok result => equalValue result ⟨(202), 2⟩
  | .error _ => false

namespace DecimalCase21
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .ceil (Expr.lit ⟨(1015), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase21

#guard match eval DecimalCase21.output with
  | .ok result => equalValue result ⟨(204), 2⟩
  | .error _ => false

namespace DecimalCase22
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .ceil (Expr.lit ⟨(5), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase22

#guard match eval DecimalCase22.output with
  | .ok result => equalValue result ⟨(2), 2⟩
  | .error _ => false

namespace DecimalCase23
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .ceil (Expr.lit ⟨(-5), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase23

#guard match eval DecimalCase23.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace DecimalCase24
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme false (Expr.extreme false (Expr.extreme true (Expr.rounded 0 .floor (Expr.lit ⟨(-325), 2⟩)) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(2), 0⟩))) (Expr.rounded 0 .ceil (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(-325), 2⟩)) (Expr.lit ⟨(25), 2⟩)))) (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_0
end DecimalCase24

#guard match eval DecimalCase24.output with
  | .ok result => equalValue result ⟨(-3), 0⟩
  | .error _ => false

namespace DecimalCase25
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme false (Expr.extreme false (Expr.extreme true (Expr.rounded 0 .floor (Expr.lit ⟨(-2), 0⟩)) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(2), 0⟩))) (Expr.rounded 0 .ceil (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(-2), 0⟩)) (Expr.lit ⟨(25), 2⟩)))) (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_0
end DecimalCase25

#guard match eval DecimalCase25.output with
  | .ok result => equalValue result ⟨(-2), 0⟩
  | .error _ => false

namespace DecimalCase26
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme false (Expr.extreme false (Expr.extreme true (Expr.rounded 0 .floor (Expr.lit ⟨(-10000000000000000000000000001), 28⟩)) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(2), 0⟩))) (Expr.rounded 0 .ceil (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(-10000000000000000000000000001), 28⟩)) (Expr.lit ⟨(25), 2⟩)))) (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_0
end DecimalCase26

#guard match eval DecimalCase26.output with
  | .ok result => equalValue result ⟨(-2), 0⟩
  | .error _ => false

namespace DecimalCase27
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme false (Expr.extreme false (Expr.extreme true (Expr.rounded 0 .floor (Expr.lit ⟨(-25), 2⟩)) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(2), 0⟩))) (Expr.rounded 0 .ceil (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(-25), 2⟩)) (Expr.lit ⟨(25), 2⟩)))) (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_0
end DecimalCase27

#guard match eval DecimalCase27.output with
  | .ok result => equalValue result ⟨(-1), 0⟩
  | .error _ => false

namespace DecimalCase28
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme false (Expr.extreme false (Expr.extreme true (Expr.rounded 0 .floor (Expr.lit ⟨(0), 0⟩)) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(2), 0⟩))) (Expr.rounded 0 .ceil (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(25), 2⟩)))) (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_0
end DecimalCase28

#guard match eval DecimalCase28.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace DecimalCase29
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme false (Expr.extreme false (Expr.extreme true (Expr.rounded 0 .floor (Expr.lit ⟨(19999999999999999999999999999), 28⟩)) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(2), 0⟩))) (Expr.rounded 0 .ceil (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(19999999999999999999999999999), 28⟩)) (Expr.lit ⟨(25), 2⟩)))) (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_0
end DecimalCase29

#guard match eval DecimalCase29.output with
  | .ok result => equalValue result ⟨(1), 0⟩
  | .error _ => false

namespace DecimalCase30
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.extreme false (Expr.extreme false (Expr.extreme true (Expr.rounded 0 .floor (Expr.lit ⟨(275), 2⟩)) (Expr.binary .sub (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(2), 0⟩))) (Expr.rounded 0 .ceil (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(275), 2⟩)) (Expr.lit ⟨(25), 2⟩)))) (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_0
end DecimalCase30

#guard match eval DecimalCase30.output with
  | .ok result => equalValue result ⟨(2), 0⟩
  | .error _ => false

namespace DecimalCase31
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .gte (Expr.lit ⟨(-25), 2⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .div (Expr.lit ⟨(-25), 2⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(-25), 2⟩))) (Expr.lit ⟨(-25), 2⟩))
def output : Expr := rule_0
end DecimalCase31

#guard match eval DecimalCase31.output with
  | .ok result => equalValue result ⟨(-25), 2⟩
  | .error _ => false

namespace DecimalCase32
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .gte (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .div (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(0), 0⟩))
def output : Expr := rule_0
end DecimalCase32

#guard match eval DecimalCase32.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace DecimalCase33
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .gte (Expr.lit ⟨(9999999999999999999999999999), 28⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .div (Expr.lit ⟨(9999999999999999999999999999), 28⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(9999999999999999999999999999), 28⟩))) (Expr.lit ⟨(9999999999999999999999999999), 28⟩))
def output : Expr := rule_0
end DecimalCase33

#guard match eval DecimalCase33.output with
  | .ok result => equalValue result ⟨(9999999999999999999999999999), 28⟩
  | .error _ => false

namespace DecimalCase34
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .gte (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .div (Expr.lit ⟨(1), 0⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase34

#guard match eval DecimalCase34.output with
  | .ok result => equalValue result ⟨(1), 0⟩
  | .error _ => false

namespace DecimalCase35
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .gte (Expr.lit ⟨(100), 2⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .div (Expr.lit ⟨(100), 2⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(100), 2⟩))) (Expr.lit ⟨(100), 2⟩))
def output : Expr := rule_0
end DecimalCase35

#guard match eval DecimalCase35.output with
  | .ok result => equalValue result ⟨(1), 0⟩
  | .error _ => false

namespace DecimalCase36
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .gte (Expr.lit ⟨(250), 2⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .div (Expr.lit ⟨(250), 2⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(250), 2⟩))) (Expr.lit ⟨(250), 2⟩))
def output : Expr := rule_0
end DecimalCase36

#guard match eval DecimalCase36.output with
  | .ok result => equalValue result ⟨(125), 2⟩
  | .error _ => false

namespace DecimalCase37
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.orElse (Predicate.compare .eq (Expr.lit ⟨(-1), 0⟩) (Expr.lit ⟨(0), 0⟩)) (Predicate.orElse (Predicate.andAlso (Predicate.negate (Predicate.compare .lt (Expr.lit ⟨(-1), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Predicate.andAlso (Predicate.compare .gte (Expr.binary .div (Expr.lit ⟨(-1), 0⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(-1), 0⟩))) (Expr.lit ⟨(15), 1⟩)) (Predicate.constant true))) (Predicate.constant false))) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(-1), 0⟩)) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .mul (Expr.lit ⟨(-1), 0⟩) (Expr.lit ⟨(1), 0⟩)))
def output : Expr := rule_0
end DecimalCase37

#guard match eval DecimalCase37.output with
  | .ok result => equalValue result ⟨(-1), 0⟩
  | .error _ => false

namespace DecimalCase38
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.orElse (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(0), 0⟩)) (Predicate.orElse (Predicate.andAlso (Predicate.negate (Predicate.compare .lt (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Predicate.andAlso (Predicate.compare .gte (Expr.binary .div (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(15), 1⟩)) (Predicate.constant true))) (Predicate.constant false))) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩)))
def output : Expr := rule_0
end DecimalCase38

#guard match eval DecimalCase38.output with
  | .ok result => equalValue result ⟨(1), 0⟩
  | .error _ => false

namespace DecimalCase39
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.orElse (Predicate.compare .eq (Expr.lit ⟨(5), 1⟩) (Expr.lit ⟨(0), 0⟩)) (Predicate.orElse (Predicate.andAlso (Predicate.negate (Predicate.compare .lt (Expr.lit ⟨(5), 1⟩) (Expr.lit ⟨(1), 0⟩))) (Predicate.andAlso (Predicate.compare .gte (Expr.binary .div (Expr.lit ⟨(5), 1⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(5), 1⟩))) (Expr.lit ⟨(15), 1⟩)) (Predicate.constant true))) (Predicate.constant false))) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(5), 1⟩)) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .mul (Expr.lit ⟨(5), 1⟩) (Expr.lit ⟨(1), 0⟩)))
def output : Expr := rule_0
end DecimalCase39

#guard match eval DecimalCase39.output with
  | .ok result => equalValue result ⟨(5), 1⟩
  | .error _ => false

namespace DecimalCase40
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.orElse (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(0), 0⟩)) (Predicate.orElse (Predicate.andAlso (Predicate.negate (Predicate.compare .lt (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Predicate.andAlso (Predicate.compare .gte (Expr.binary .div (Expr.lit ⟨(1), 0⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(15), 1⟩)) (Predicate.constant true))) (Predicate.constant false))) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .mul (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)))
def output : Expr := rule_0
end DecimalCase40

#guard match eval DecimalCase40.output with
  | .ok result => equalValue result ⟨(1), 0⟩
  | .error _ => false

namespace DecimalCase41
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.orElse (Predicate.compare .eq (Expr.lit ⟨(15), 1⟩) (Expr.lit ⟨(0), 0⟩)) (Predicate.orElse (Predicate.andAlso (Predicate.negate (Predicate.compare .lt (Expr.lit ⟨(15), 1⟩) (Expr.lit ⟨(1), 0⟩))) (Predicate.andAlso (Predicate.compare .gte (Expr.binary .div (Expr.lit ⟨(15), 1⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(15), 1⟩))) (Expr.lit ⟨(15), 1⟩)) (Predicate.constant true))) (Predicate.constant false))) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(15), 1⟩)) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .mul (Expr.lit ⟨(15), 1⟩) (Expr.lit ⟨(1), 0⟩)))
def output : Expr := rule_0
end DecimalCase41

#guard match eval DecimalCase41.output with
  | .ok result => equalValue result ⟨(25), 1⟩
  | .error _ => false

namespace DecimalCase42
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.orElse (Predicate.compare .eq (Expr.lit ⟨(25), 1⟩) (Expr.lit ⟨(0), 0⟩)) (Predicate.orElse (Predicate.andAlso (Predicate.negate (Predicate.compare .lt (Expr.lit ⟨(25), 1⟩) (Expr.lit ⟨(1), 0⟩))) (Predicate.andAlso (Predicate.compare .gte (Expr.binary .div (Expr.lit ⟨(25), 1⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(25), 1⟩))) (Expr.lit ⟨(15), 1⟩)) (Predicate.constant true))) (Predicate.constant false))) (Expr.binary .add (Expr.binary .add (Expr.lit ⟨0, 0⟩) (Expr.lit ⟨(25), 1⟩)) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .mul (Expr.lit ⟨(25), 1⟩) (Expr.lit ⟨(1), 0⟩)))
def output : Expr := rule_0
end DecimalCase42

#guard match eval DecimalCase42.output with
  | .ok result => equalValue result ⟨(25), 1⟩
  | .error _ => false

namespace DecimalCase43
open RuleSpecLean.DecimalModel

def output : Predicate := (Predicate.orElse (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(0), 0⟩)) (Predicate.orElse (Predicate.andAlso (Predicate.negate (Predicate.compare .lt (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Predicate.andAlso (Predicate.compare .gte (Expr.binary .div (Expr.lit ⟨(0), 0⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(0), 0⟩))) (Expr.lit ⟨(15), 1⟩)) (Predicate.constant true))) (Predicate.constant false)))
end DecimalCase43

#guard match evalPredicate DecimalCase43.output with
  | .ok value => value == true
  | .error _ => false

namespace DecimalCase44
open RuleSpecLean.DecimalModel

def output : Predicate := (Predicate.orElse (Predicate.compare .eq (Expr.lit ⟨(5), 1⟩) (Expr.lit ⟨(0), 0⟩)) (Predicate.orElse (Predicate.andAlso (Predicate.negate (Predicate.compare .lt (Expr.lit ⟨(5), 1⟩) (Expr.lit ⟨(1), 0⟩))) (Predicate.andAlso (Predicate.compare .gte (Expr.binary .div (Expr.lit ⟨(5), 1⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(5), 1⟩))) (Expr.lit ⟨(15), 1⟩)) (Predicate.constant true))) (Predicate.constant false)))
end DecimalCase44

#guard match evalPredicate DecimalCase44.output with
  | .ok value => value == false
  | .error _ => false

namespace DecimalCase45
open RuleSpecLean.DecimalModel

def output : Predicate := (Predicate.orElse (Predicate.compare .eq (Expr.lit ⟨(15), 1⟩) (Expr.lit ⟨(0), 0⟩)) (Predicate.orElse (Predicate.andAlso (Predicate.negate (Predicate.compare .lt (Expr.lit ⟨(15), 1⟩) (Expr.lit ⟨(1), 0⟩))) (Predicate.andAlso (Predicate.compare .gte (Expr.binary .div (Expr.lit ⟨(15), 1⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(15), 1⟩))) (Expr.lit ⟨(15), 1⟩)) (Predicate.constant true))) (Predicate.constant false)))
end DecimalCase45

#guard match evalPredicate DecimalCase45.output with
  | .ok value => value == true
  | .error _ => false

namespace DecimalCase46
open RuleSpecLean.DecimalModel

def output : Predicate := (Predicate.orElse (Predicate.compare .eq (Expr.lit ⟨(25), 1⟩) (Expr.lit ⟨(0), 0⟩)) (Predicate.orElse (Predicate.andAlso (Predicate.negate (Predicate.compare .lt (Expr.lit ⟨(25), 1⟩) (Expr.lit ⟨(1), 0⟩))) (Predicate.andAlso (Predicate.compare .gte (Expr.binary .div (Expr.lit ⟨(25), 1⟩) (Expr.rounded 0 .floor (Expr.lit ⟨(25), 1⟩))) (Expr.lit ⟨(15), 1⟩)) (Predicate.constant true))) (Predicate.constant false)))
end DecimalCase46

#guard match evalPredicate DecimalCase46.output with
  | .ok value => value == false
  | .error _ => false

namespace DecimalCase47
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(0), 28⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase47

#guard match eval DecimalCase47.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace DecimalCase48
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(-4), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase48

#guard match eval DecimalCase48.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace DecimalCase49
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(39614081257132168796771975167), 0⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase49

#guard match eval DecimalCase49.output with
  | .ok result => equalValue result ⟨(79228162514264337593543950334), 0⟩
  | .error _ => false

namespace DecimalCase50
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(39614081257132168796771975168), 0⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase50

#guard match eval DecimalCase50.output with
  | .error fault => fault == .arithmeticOverflow
  | .ok _ => false

namespace DecimalCase51
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(-79228162514264337593543950335), 0⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase51

#guard match eval DecimalCase51.output with
  | .error fault => fault == .arithmeticOverflow
  | .ok _ => false

namespace DecimalCase52
open RuleSpecLean.DecimalModel

def output : Expr := Expr.missingRuleVersion
end DecimalCase52

#guard match eval DecimalCase52.output with
  | .error fault => fault == .missingRuleVersion
  | .ok _ => false

namespace DecimalCase53
open RuleSpecLean.DecimalModel

def output : Predicate := Predicate.missingRuleVersion
end DecimalCase53

#guard match evalPredicate DecimalCase53.output with
  | .error fault => fault == .missingRuleVersion
  | .ok _ => false

namespace DecimalCase54
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.binary .mul (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) Expr.missingRuleVersion)
def output : Expr := rule_0
end DecimalCase54

#guard match eval DecimalCase54.output with
  | .error fault => fault == .missingRuleVersion
  | .ok _ => false

namespace DecimalCase55
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.binary .mul (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩)) Expr.missingRuleVersion)
def output : Expr := rule_0
end DecimalCase55

#guard match eval DecimalCase55.output with
  | .ok result => equalValue result ⟨(0), 0⟩
  | .error _ => false

namespace DecimalCase56
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [((-9223372036854775808), ⟨(125), 2⟩), ((-1), ⟨(250), 2⟩), ((0), ⟨(375), 2⟩), ((9223372036854775807), ⟨(425), 2⟩)] (Expr.binary .div (Expr.lit ⟨(-9223372036854775808), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase56

#guard match eval DecimalCase56.output with
  | .ok result => equalValue result ⟨(125), 2⟩
  | .error _ => false

namespace DecimalCase57
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [((-9223372036854775808), ⟨(125), 2⟩), ((-1), ⟨(250), 2⟩), ((0), ⟨(375), 2⟩), ((9223372036854775807), ⟨(425), 2⟩)] (Expr.binary .div (Expr.lit ⟨(-10), 1⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase57

#guard match eval DecimalCase57.output with
  | .ok result => equalValue result ⟨(25), 1⟩
  | .error _ => false

namespace DecimalCase58
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [((-9223372036854775808), ⟨(125), 2⟩), ((-1), ⟨(250), 2⟩), ((0), ⟨(375), 2⟩), ((9223372036854775807), ⟨(425), 2⟩)] (Expr.binary .div (Expr.lit ⟨(0), 2⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase58

#guard match eval DecimalCase58.output with
  | .ok result => equalValue result ⟨(375), 2⟩
  | .error _ => false

namespace DecimalCase59
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [((-9223372036854775808), ⟨(125), 2⟩), ((-1), ⟨(250), 2⟩), ((0), ⟨(375), 2⟩), ((9223372036854775807), ⟨(425), 2⟩)] (Expr.binary .div (Expr.lit ⟨(9223372036854775807), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase59

#guard match eval DecimalCase59.output with
  | .ok result => equalValue result ⟨(425), 2⟩
  | .error _ => false

namespace DecimalCase60
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(525), 2⟩)] (Expr.binary .div (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase60

#guard match eval DecimalCase60.output with
  | .ok result => equalValue result ⟨(525), 2⟩
  | .error _ => false

namespace DecimalCase61
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [((-9223372036854775808), ⟨(125), 2⟩), ((-1), ⟨(250), 2⟩), ((0), ⟨(375), 2⟩), ((9223372036854775807), ⟨(425), 2⟩)] (Expr.binary .div (Expr.lit ⟨(-15), 1⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase61

#guard match eval DecimalCase61.output with
  | .error fault => fault == .invalidParameterIndex
  | .ok _ => false

namespace DecimalCase62
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [((-9223372036854775808), ⟨(125), 2⟩), ((-1), ⟨(250), 2⟩), ((0), ⟨(375), 2⟩), ((9223372036854775807), ⟨(425), 2⟩)] (Expr.binary .div (Expr.lit ⟨(9223372036854775808), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase62

#guard match eval DecimalCase62.output with
  | .error fault => fault == .invalidParameterIndex
  | .ok _ => false

namespace DecimalCase63
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [((-9223372036854775808), ⟨(125), 2⟩), ((-1), ⟨(250), 2⟩), ((0), ⟨(375), 2⟩), ((9223372036854775807), ⟨(425), 2⟩)] (Expr.binary .div (Expr.lit ⟨(-9223372036854775809), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase63

#guard match eval DecimalCase63.output with
  | .error fault => fault == .invalidParameterIndex
  | .ok _ => false

namespace DecimalCase64
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [] (Expr.binary .div (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase64

#guard match eval DecimalCase64.output with
  | .error fault => fault == .missingParameterValue
  | .ok _ => false

namespace DecimalCase65
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [((-9223372036854775808), ⟨(125), 2⟩), ((-1), ⟨(250), 2⟩), ((0), ⟨(375), 2⟩), ((9223372036854775807), ⟨(425), 2⟩)] (Expr.binary .div (Expr.lit ⟨(2), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase65

#guard match eval DecimalCase65.output with
  | .error fault => fault == .missingParameterValue
  | .ok _ => false

namespace DecimalCase66
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .mul (Expr.lookup [((0), ⟨(525), 2⟩)] (Expr.binary .div (Expr.lit ⟨(-1), 0⟩) (Expr.lit ⟨(1), 0⟩))) (Expr.lit ⟨(1), 0⟩))
def output : Expr := rule_0
end DecimalCase66

#guard match eval DecimalCase66.output with
  | .error fault => fault == .missingParameterValue
  | .ok _ => false

namespace DecimalCase67
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(1005), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase67

#guard match eval DecimalCase67.output with
  | .ok result => equalValue result ⟨(202), 2⟩
  | .error _ => false

namespace DecimalCase68
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp (Expr.lit ⟨(1005), 3⟩))
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase68

#guard match eval DecimalCase68.output with
  | .ok result => equalValue result ⟨(202), 2⟩
  | .error _ => false

namespace DecimalCase69
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.rounded 2 .halfUp Expr.missingInput)
def rule_1 : Expr := (Expr.binary .mul rule_0 (Expr.lit ⟨(2), 0⟩))
def output : Expr := rule_1
end DecimalCase69

#guard match eval DecimalCase69.output with
  | .error fault => fault == .missingInput
  | .ok _ => false

namespace DecimalCase70
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.binary .div Expr.missingInput (Expr.rounded 0 .floor (Expr.lit ⟨(25), 2⟩)))
def output : Expr := rule_0
end DecimalCase70

#guard match eval DecimalCase70.output with
  | .error fault => fault == .divisionByZero
  | .ok _ => false

namespace DecimalCase71
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(1), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.binary .mul (Expr.lit ⟨(125), 2⟩) (Expr.lit ⟨(2), 0⟩)) Expr.missingInput)
def output : Expr := rule_0
end DecimalCase71

#guard match eval DecimalCase71.output with
  | .ok result => equalValue result ⟨(25), 1⟩
  | .error _ => false
