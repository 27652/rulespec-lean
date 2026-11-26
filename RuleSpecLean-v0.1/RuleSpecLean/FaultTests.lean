import RuleSpecLean.Core

open RuleSpecLean


namespace FaultCase0

def rule_0 : Expr :=
  (Expr.input "income")

def rule_1 : Expr :=
  (Expr.binary .max (Expr.unary .numeric (Expr.lit (Value.decimal (0)))) (Expr.unary .numeric (Expr.binary .sub (Expr.unary .numeric rule_0) (Expr.unary .numeric (Expr.lookup [((0), (Value.integer (1000)))] (Expr.lit (Value.integer (0))))))))

def rule_2 : Expr :=
  (Expr.binary .gte rule_0 (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))))

def rule_3 : Expr :=
  (Expr.choose rule_2 (Expr.lookup [((0), (Value.decimal (200000)))] (Expr.lit (Value.integer (0)))) (Expr.lookup [((0), (Value.decimal (100000)))] (Expr.lit (Value.integer (0)))))

def rule_4 : Expr :=
  (Expr.unary .ceil (Expr.binary .mul (Expr.unary .numeric rule_1) (Expr.unary .numeric rule_3)))

def output_0 : Expr := rule_4

end FaultCase0

#guard sameResult (eval [] FaultCase0.output_0) (.error .missingInput)

namespace FaultCase1

def rule_0 : Expr :=
  (Expr.input "income")

def rule_1 : Expr :=
  (Expr.binary .max (Expr.unary .numeric (Expr.lit (Value.decimal (0)))) (Expr.unary .numeric (Expr.binary .sub (Expr.unary .numeric rule_0) (Expr.unary .numeric (Expr.lookup [((0), (Value.integer (1000)))] (Expr.lit (Value.integer (0))))))))

def rule_2 : Expr :=
  (Expr.binary .gte rule_0 (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))))

def rule_3 : Expr :=
  (Expr.choose rule_2 (Expr.lookup [((0), (Value.decimal (200000)))] (Expr.lit (Value.integer (0)))) (Expr.lookup [((0), (Value.decimal (100000)))] (Expr.lit (Value.integer (0)))))

def rule_4 : Expr :=
  (Expr.unary .ceil (Expr.binary .mul (Expr.unary .numeric rule_1) (Expr.unary .numeric rule_3)))

def output_0 : Expr := rule_4

end FaultCase1

#guard sameResult (eval [("income", (Value.text "bad"))] FaultCase1.output_0) (.error .typeMismatch)

namespace FaultCase2

def rule_0 : Expr :=
  (Expr.binary .div (Expr.unary .numeric (Expr.input "numerator")) (Expr.unary .numeric (Expr.input "denominator")))

def output_0 : Expr := rule_0

end FaultCase2

#guard sameResult (eval [("denominator", (Value.integer (0)))] FaultCase2.output_0) (.error .divisionByZero)

namespace FaultCase3

def rule_0 : Expr :=
  (Expr.binary .div (Expr.unary .numeric (Expr.input "numerator")) (Expr.unary .numeric (Expr.input "denominator")))

def output_0 : Expr := rule_0

end FaultCase3

#guard sameResult (eval [("denominator", (Value.integer (1)))] FaultCase3.output_0) (.error .missingInput)

namespace FaultCase4

def rule_0 : Expr :=
  (Expr.fault .missingVersion)

def output_0 : Expr := rule_0

end FaultCase4

#guard sameResult (eval [] FaultCase4.output_0) (.error .missingVersion)

namespace FaultCase5

def rule_0 : Expr :=
  (Expr.lookup [] (Expr.binary .div (Expr.unary .numeric (Expr.input "numerator")) (Expr.unary .numeric (Expr.lit (Value.integer (1))))))

def output_0 : Expr := rule_0

end FaultCase5

#guard sameResult (eval [("numerator", (Value.integer (0)))] FaultCase5.output_0) (.error .missingParameter)

namespace FaultCase6

def rule_0 : Expr :=
  (Expr.lookup [] (Expr.binary .div (Expr.unary .numeric (Expr.input "numerator")) (Expr.unary .numeric (Expr.lit (Value.integer (1))))))

def output_0 : Expr := rule_0

end FaultCase6

#guard sameResult (eval [] FaultCase6.output_0) (.error .missingInput)

namespace FaultCase7

def rule_0 : Expr :=
  (Expr.lookup [] (Expr.binary .div (Expr.unary .numeric (Expr.input "numerator")) (Expr.unary .numeric (Expr.lit (Value.integer (1))))))

def output_0 : Expr := rule_0

end FaultCase7

#guard sameResult (eval [("numerator", (Value.decimal (500000)))] FaultCase7.output_0) (.error .typeMismatch)
