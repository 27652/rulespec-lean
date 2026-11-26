import RuleSpecLean.Core

namespace RuleSpecLean.Generated

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

end RuleSpecLean.Generated
