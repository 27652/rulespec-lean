import RuleSpecLean.Core

namespace RuleSpecLean.Generated

def rule_0 : Expr :=
  (Expr.binary .max (Expr.unary .numeric (Expr.lit (Value.decimal (0)))) (Expr.unary .numeric (Expr.input "tax_required_to_be_deducted_and_withheld_under_this_chapter")))

def output_0 : Expr := rule_0

end RuleSpecLean.Generated
