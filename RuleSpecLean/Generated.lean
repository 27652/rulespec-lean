import RuleSpecLean.Core

namespace RuleSpecLean.Generated

def rule_0 : Expr :=
  (Expr.binary .andAlso (Expr.binary .eq (Expr.input "id_ok") (Expr.lit (Value.boolean true))) (Expr.binary .andAlso (Expr.binary .eq (Expr.input "year_ok") (Expr.lit (Value.boolean true))) (Expr.lit (Value.judgment .holds))))

def rule_1 : Expr :=
  (Expr.binary .add (Expr.binary .add (Expr.lit (Value.decimal (0))) (Expr.unary .numeric (Expr.binary .mul (Expr.unary .numeric (Expr.input "children")) (Expr.unary .numeric (Expr.lookup [((0), (Value.integer (2200)))] (Expr.lit (Value.integer (0)))))))) (Expr.unary .numeric (Expr.binary .mul (Expr.unary .numeric (Expr.input "other_dependents")) (Expr.unary .numeric (Expr.lit (Value.integer (500)))))))

def rule_2 : Expr :=
  (Expr.binary .eq (Expr.input "joint_filing") (Expr.lit (Value.boolean true)))

def rule_3 : Expr :=
  (Expr.choose rule_2 (Expr.lit (Value.integer (400000))) (Expr.lit (Value.integer (200000))))

def rule_4 : Expr :=
  (Expr.binary .max (Expr.unary .numeric (Expr.lit (Value.integer (0)))) (Expr.unary .numeric (Expr.binary .sub (Expr.unary .numeric (Expr.input "magi")) (Expr.unary .numeric rule_3))))

def rule_5 : Expr :=
  (Expr.binary .mul (Expr.unary .numeric (Expr.lit (Value.integer (50)))) (Expr.unary .numeric (Expr.unary .ceil (Expr.binary .div (Expr.unary .numeric rule_4) (Expr.unary .numeric (Expr.lit (Value.integer (1000))))))))

def rule_6 : Expr :=
  (Expr.choose rule_0 (Expr.binary .max (Expr.unary .numeric (Expr.lit (Value.integer (0)))) (Expr.unary .numeric (Expr.binary .sub (Expr.unary .numeric rule_1) (Expr.unary .numeric rule_5)))) (Expr.lit (Value.decimal (0))))

def output_0 : Expr := rule_6

end RuleSpecLean.Generated
