import json
import unittest

from tools.decimal_model import DecimalFault, DecimalValue, MAX_COEFFICIENT
from fractions import Fraction
from tests.test_prototype import ROOT


class DecimalTests(unittest.TestCase):
    def test_dependency_rounding_before_read(self):
        from tools.decimal_runtime import NumericRuntime
        artifact = json.loads((ROOT / "fixtures/decimal-dependency.artifact.json").read_text())
        runtime = NumericRuntime(artifact, "2025-01-01")
        value = runtime.rule("doubled", {"amount": {"kind": "decimal", "value": "1.005"}})
        self.assertEqual(Fraction(value.coefficient, 10**value.scale), Fraction(202, 100))

    def test_arithmetic_faults(self):
        with self.assertRaisesRegex(DecimalFault, "divisionByZero"):
            DecimalValue(1, 0).arithmetic("div", DecimalValue(0, 0))
        with self.assertRaisesRegex(DecimalFault, "arithmeticOverflow"):
            DecimalValue(MAX_COEFFICIENT, 0).arithmetic("add", DecimalValue(1, 0))

    def test_retained_arithmetic(self):
        report = json.loads((ROOT / "reports/v0.1/decimal/decimal-arithmetic.json").read_text())
        self.assertEqual(report["cases"], len(report["results"]))
        for row in report["results"]:
            case = row["case"]
            a, b = DecimalValue.parse(case["left"]), DecimalValue.parse(case["right"])
            with self.subTest(case=case):
                if "fault" in row:
                    with self.assertRaisesRegex(DecimalFault, row["fault"]):
                        a.arithmetic(case["op"], b)
                else:
                    v = a.arithmetic(case["op"], b)
                    self.assertEqual(v, DecimalValue(int(row["coefficient"]), row["scale"]))

    def test_midpoints(self):
        for text, mode, expected in [("1.225", "half_even", "1.22"),
                                      ("1.225", "half_up", "1.23"),
                                      ("-1.225", "half_up", "-1.23"),
                                      ("-1.221", "floor", "-1.23"),
                                      ("-1.229", "ceil", "-1.22")]:
            self.assertEqual(str(DecimalValue.parse(text).round(2, mode)), expected)

    def test_invalid_domain(self):
        for coefficient, scale in [(MAX_COEFFICIENT + 1, 0), (0, 29), (0, -1), (True, 0)]:
            with self.assertRaises(ValueError):
                DecimalValue(coefficient, scale)

    def test_invalid_notation(self):
        for value in ("1e3", "nan", " 1", "1.", ".1", "١", 1):
            with self.assertRaises(ValueError):
                DecimalValue.parse(value)

    def test_precision_not_padded(self):
        self.assertEqual(DecimalValue.parse("1.2").round(28, "floor"), DecimalValue(12, 1))

    def test_retained_rust_matrix(self):
        report = json.loads((ROOT / "reports/v0.1/decimal/decimal-rounding.json").read_text())
        self.assertEqual(report["cases"], len(report["results"]))
        for row in report["results"]:
            with self.subTest(row=row):
                actual = DecimalValue.parse(row["input"]).round(row["places"], row["mode"])
                self.assertEqual(actual, DecimalValue(int(row["coefficient"]), row["scale"]))
