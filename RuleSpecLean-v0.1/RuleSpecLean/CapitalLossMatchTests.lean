import RuleSpecLean.Core
import RuleSpecLean.Decimal

open RuleSpecLean.DecimalModel


namespace CapitalLossMatchTestsCase0
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(2), 0⟩)) (Expr.lookup [((0), ⟨(1500), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(3), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(0), 0⟩) (Expr.lit ⟨(4), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.noMatch (Expr.lit ⟨(0), 0⟩)))))))
def output : Expr := rule_0
end CapitalLossMatchTestsCase0

#guard match eval CapitalLossMatchTestsCase0.output with
  | .ok result => equalValue result ⟨(3000), 0⟩
  | .error _ => false

namespace RuleSpecLean.Scale6CapitalLossCase0

def rule_0 : Expr :=
  (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (2)))) (Expr.lookup [((0), (Value.integer (1500)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (0)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (1)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (3)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (4)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.noMatch (Expr.input "filing_status")))))))

def output_0 : Expr := rule_0

end RuleSpecLean.Scale6CapitalLossCase0

open RuleSpecLean in
#guard sameResult (RuleSpecLean.eval [("filing_status", (Value.integer (0)))] RuleSpecLean.Scale6CapitalLossCase0.output_0) (.ok (Value.integer (3000)))

namespace CapitalLossMatchTestsCase1
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(2), 0⟩) (Expr.lit ⟨(2), 0⟩)) (Expr.lookup [((0), ⟨(1500), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(2), 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(2), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(2), 0⟩) (Expr.lit ⟨(3), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(2), 0⟩) (Expr.lit ⟨(4), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.noMatch (Expr.lit ⟨(2), 0⟩)))))))
def output : Expr := rule_0
end CapitalLossMatchTestsCase1

#guard match eval CapitalLossMatchTestsCase1.output with
  | .ok result => equalValue result ⟨(1500), 0⟩
  | .error _ => false

namespace RuleSpecLean.Scale6CapitalLossCase1

def rule_0 : Expr :=
  (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (2)))) (Expr.lookup [((0), (Value.integer (1500)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (0)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (1)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (3)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (4)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.noMatch (Expr.input "filing_status")))))))

def output_0 : Expr := rule_0

end RuleSpecLean.Scale6CapitalLossCase1

open RuleSpecLean in
#guard sameResult (RuleSpecLean.eval [("filing_status", (Value.integer (2)))] RuleSpecLean.Scale6CapitalLossCase1.output_0) (.ok (Value.integer (1500)))

namespace CapitalLossMatchTestsCase2
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(9), 0⟩) (Expr.lit ⟨(2), 0⟩)) (Expr.lookup [((0), ⟨(1500), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(9), 0⟩) (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(9), 0⟩) (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(9), 0⟩) (Expr.lit ⟨(3), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq (Expr.lit ⟨(9), 0⟩) (Expr.lit ⟨(4), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.noMatch (Expr.lit ⟨(9), 0⟩)))))))
def output : Expr := rule_0
end CapitalLossMatchTestsCase2

#guard match eval CapitalLossMatchTestsCase2.output with
  | .error fault => fault == .noMatchingArm
  | .ok _ => false

namespace RuleSpecLean.Scale6CapitalLossCase2

def rule_0 : Expr :=
  (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (2)))) (Expr.lookup [((0), (Value.integer (1500)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (0)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (1)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (3)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (4)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.noMatch (Expr.input "filing_status")))))))

def output_0 : Expr := rule_0

end RuleSpecLean.Scale6CapitalLossCase2

open RuleSpecLean in
#guard sameResult (RuleSpecLean.eval [("filing_status", (Value.integer (9)))] RuleSpecLean.Scale6CapitalLossCase2.output_0) (.error .noMatchingArm)

namespace CapitalLossMatchTestsCase3
open RuleSpecLean.DecimalModel

def rule_0 : Expr := (Expr.choose (Predicate.compare .eq Expr.missingInput (Expr.lit ⟨(2), 0⟩)) (Expr.lookup [((0), ⟨(1500), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq Expr.missingInput (Expr.lit ⟨(0), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq Expr.missingInput (Expr.lit ⟨(1), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq Expr.missingInput (Expr.lit ⟨(3), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.choose (Predicate.compare .eq Expr.missingInput (Expr.lit ⟨(4), 0⟩)) (Expr.lookup [((0), ⟨(3000), 0⟩)] (Expr.lit ⟨(0), 0⟩)) (Expr.noMatch Expr.missingInput))))))
def output : Expr := rule_0
end CapitalLossMatchTestsCase3

#guard match eval CapitalLossMatchTestsCase3.output with
  | .error fault => fault == .missingInput
  | .ok _ => false

namespace RuleSpecLean.Scale6CapitalLossCase3

def rule_0 : Expr :=
  (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (2)))) (Expr.lookup [((0), (Value.integer (1500)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (0)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (1)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (3)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.choose (Expr.binary .eq (Expr.input "filing_status") (Expr.lit (Value.integer (4)))) (Expr.lookup [((0), (Value.integer (3000)))] (Expr.lit (Value.integer (0)))) (Expr.noMatch (Expr.input "filing_status")))))))

def output_0 : Expr := rule_0

end RuleSpecLean.Scale6CapitalLossCase3

open RuleSpecLean in
#guard sameResult (RuleSpecLean.eval [] RuleSpecLean.Scale6CapitalLossCase3.output_0) (.error .missingInput)
