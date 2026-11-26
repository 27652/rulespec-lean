import RuleSpecLean.Generated

namespace RuleSpecLean.Tests

def family (income : Int) : Env :=
  [("magi", .integer income), ("children", .integer 2),
   ("other_dependents", .integer 1), ("joint_filing", .boolean true),
   ("id_ok", .boolean true), ("year_ok", .boolean true)]

def creditAt (income : Int) : Result :=
  eval (family income) Generated.output_0

#eval creditAt 401250
#guard sameResult (creditAt 401250) (.ok (.decimal 4800000000))
#guard sameResult (creditAt 400000) (.ok (.decimal 4900000000))
#guard sameResult (creditAt 400001) (.ok (.decimal 4850000000))
#guard sameResult (creditAt 401000) (.ok (.decimal 4850000000))
#guard sameResult (creditAt 401001) (.ok (.decimal 4800000000))
#guard sameResult (creditAt 498000) (.ok (.decimal 0))
#guard sameResult (eval [("id_ok", .boolean false)] Generated.output_0) (.ok (.decimal 0))
#guard sameResult (eval [] Generated.output_0) (.error .missingInput)
#guard sameResult (eval [] (.binary .div (.input "missing") (.lit (.integer 0)))) (.error .divisionByZero)
#guard sameResult (eval [] (.binary .div (.lit (.integer 1)) (.lit (.integer 3)))) (.error .outsideExactDomain)
#guard sameResult (eval [] (.unary .floor (.lit (.decimal (-1200000))))) (.ok (.decimal (-2000000)))
#guard sameResult (eval [] (.unary .ceil (.lit (.decimal (-1200000))))) (.ok (.decimal (-1000000)))
#guard sameResult (eval [] (.choose (.lit (.judgment .undetermined)) (.input "missing") (.lit (.integer 3)))) (.ok (.integer 3))

end RuleSpecLean.Tests
