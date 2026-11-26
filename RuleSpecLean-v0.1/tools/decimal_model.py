"""M2 decimal arithmetic and rounding, independent of the scale-6 interpreter.

Values carry a signed 96-bit magnitude and scale 0..28, without signed zero.
"""
from dataclasses import dataclass
import re

MAX_COEFFICIENT = 2**96 - 1
MODES = ("half_up", "half_even", "floor", "ceil")


def judgment_body(name, rules, as_of):
    """Select the active body of a referenced numeric judgment."""
    from tools.compile_ir import require, version_at

    require(isinstance(name, str) and name in rules, "unknown numeric judgment")
    rule = rules[name]
    versions = rule.get("versions", [])
    active = version_at(versions, as_of) if versions else rule
    if active is None:
        return None
    require(active["semantics"] == "judgment" and rule.get("rounding") is None,
            "active numeric judgment required")
    return active["expr"]


def parameter_values(expr, parameters, as_of):
    """Select and validate a numeric parameter table for the snapshot."""
    from tools.compile_ir import expr_fields, require, version_at

    expr_fields(expr, ["parameter", "index"])
    param = parameters.get(expr["parameter"])
    require(param is not None, "unknown numeric parameter")
    active = version_at(param.get("versions", []), as_of)
    if active is None:
        return {}
    table = {}
    for raw_key, value in active["values"].items():
        key = int(raw_key)
        require(str(key) == raw_key and -(2**63) <= key < 2**63, "invalid numeric parameter key")
        table[key] = DecimalValue.from_literal(value)
    return table


class DecimalFault(ValueError):
    pass


def snapshot_literal(value):
    from tools.compile_ir import parse_value

    if isinstance(value, dict) and value.get("kind") == "bool":
        return parse_value(value)[1]
    return DecimalValue.from_literal(value)


def boolean_read(expr, env, boolean_inputs):
    """Identify boolean literals and direct boolean input reads."""
    if expr["kind"] == "literal" and expr["value"].get("kind") == "bool":
        return expr["value"]
    if expr["kind"] == "input":
        name = expr["name"]
        value = env.get(name)
        if name in boolean_inputs or (value is not None and value.get("kind") == "bool"):
            return value
    return NotImplemented


def round_ratio(numerator, denominator):
    """Round a nonnegative rational to integer, midpoint to even."""
    q, r = divmod(numerator, denominator)
    return q + int(2 * r > denominator or (2 * r == denominator and q % 2 == 1))


def fit_ratio(numerator, denominator, preferred_scale):
    """Fit a rational to the preferred scale, reducing precision as needed."""
    negative = numerator < 0
    numerator = abs(numerator)
    for scale in range(min(28, preferred_scale), -1, -1):
        coefficient = round_ratio(numerator * 10**scale, denominator)
        if coefficient <= MAX_COEFFICIENT:
            return DecimalValue(-coefficient if negative else coefficient, scale)
    raise DecimalFault("arithmeticOverflow")


def divide(left, right):
    """Build the quotient in chunks of up to nine decimal digits."""
    divisor = abs(right.coefficient)
    if not divisor:
        raise DecimalFault("divisionByZero")
    if not left.coefficient:
        return DecimalValue(0, 0)
    coefficient, remainder = divmod(abs(left.coefficient), divisor)
    scale = left.scale - right.scale
    unscale = bool(remainder)
    while remainder or scale < 0:
        power = min(9, 28 - scale) if remainder else min(9, -scale)
        while power and coefficient * 10**power > MAX_COEFFICIENT:
            power -= 1
        if remainder and scale < 0 and scale + power < 0 and power != 9:
            raise DecimalFault("arithmeticOverflow")
        if not power:
            if scale < 0:
                raise DecimalFault("arithmeticOverflow")
            coefficient = round_ratio(coefficient * divisor + remainder, divisor)
            if coefficient > MAX_COEFFICIENT:
                if not scale:
                    raise DecimalFault("arithmeticOverflow")
                coefficient = round_ratio(coefficient, 10)
                scale -= 1
            break
        coefficient, remainder = divmod((coefficient * divisor + remainder) * 10**power, divisor)
        scale += power
        if coefficient > MAX_COEFFICIENT:
            if scale <= 0:
                raise DecimalFault("arithmeticOverflow")
            coefficient = round_ratio(coefficient * divisor + remainder, divisor * 10)
            scale -= 1
            break
    if unscale:
        # Match the locked library's chunked removal, including its low-word gate.
        while scale >= 8 and coefficient % 2**32 == 0 and coefficient % 10**8 == 0:
            coefficient //= 10**8
            scale -= 8
        for power in (4, 2, 1):
            if scale >= power and coefficient % 10**power == 0:
                coefficient //= 10**power
                scale -= power
    negative = (left.coefficient < 0) != (right.coefficient < 0)
    return DecimalValue(-coefficient if negative else coefficient, scale)


@dataclass(frozen=True)
class DecimalValue:
    coefficient: int
    scale: int

    def __post_init__(self):
        if type(self.coefficient) is not int or abs(self.coefficient) > MAX_COEFFICIENT:
            raise ValueError("decimal coefficient outside 96-bit domain")
        if type(self.scale) is not int or not 0 <= self.scale <= 28:
            raise ValueError("decimal scale outside 0..28")

    @classmethod
    def from_literal(cls, value):
        if not isinstance(value, dict) or set(value) != {"kind", "value"}:
            raise ValueError("malformed numeric literal")
        kind, raw = value["kind"], value["value"]
        if kind == "integer":
            if type(raw) is not int or not -(2**63) <= raw < 2**63:
                raise ValueError("invalid integer literal")
            return cls(raw, 0)
        if kind == "decimal" and type(raw) in (str, int):
            return cls.parse(str(raw))
        raise ValueError("exact numeric literal required")

    @classmethod
    def parse(cls, text):
        if not isinstance(text, str) or not re.fullmatch(r"[+-]?[0-9]+(?:\.[0-9]+)?", text):
            raise ValueError("plain decimal notation required")
        sign = -1 if text.startswith("-") else 1
        whole, dot, fraction = text.lstrip("+-").partition(".")
        return cls(sign * int(whole + fraction), len(fraction))

    def round(self, places, mode):
        if type(places) is not int or not 0 <= places <= 28:
            raise ValueError("rounding places outside 0..28")
        if mode not in MODES:
            raise ValueError("unknown rounding mode")
        if places >= self.scale:
            return self
        divisor = 10 ** (self.scale - places)
        magnitude, remainder = divmod(abs(self.coefficient), divisor)
        negative = self.coefficient < 0
        increment = {
            "half_up": 2 * remainder >= divisor,
            "half_even": 2 * remainder > divisor or
                         (2 * remainder == divisor and magnitude % 2 == 1),
            "floor": negative and remainder != 0,
            "ceil": not negative and remainder != 0,
        }[mode]
        return DecimalValue((-1 if negative else 1) * (magnitude + int(increment)), places)

    def arithmetic(self, op, other):
        if op in ("add", "sub"):
            if self.coefficient == 0:
                return other if op == "add" else DecimalValue(-other.coefficient, other.scale)
            if other.coefficient == 0:
                return self
            scale = max(self.scale, other.scale)
            n = self.coefficient * 10**(scale - self.scale)
            m = other.coefficient * 10**(scale - other.scale)
            return fit_ratio(n + (m if op == "add" else -m), 10**scale, scale)
        if op == "mul":
            scale = self.scale + other.scale
            if self.coefficient == 0 or other.coefficient == 0:
                return DecimalValue(0, 0)
            # The library's 32-bit operand fast path returns canonical zero here.
            if scale > 47 and max(abs(self.coefficient), abs(other.coefficient)) < 2**32:
                return DecimalValue(0, 0)
            return fit_ratio(self.coefficient * other.coefficient, 10**scale, scale)
        if op == "div":
            return divide(self, other)
        raise ValueError("unknown arithmetic op")

    def as_index(self):
        key, remainder = divmod(self.coefficient, 10**self.scale)
        if remainder or not -(2**63) <= key < 2**63:
            raise DecimalFault("invalidParameterIndex")
        return key

    def __str__(self):
        digits = str(abs(self.coefficient)).zfill(self.scale + 1)
        body = digits if self.scale == 0 else digits[:-self.scale] + "." + digits[-self.scale:]
        return ("-" if self.coefficient < 0 else "") + body
