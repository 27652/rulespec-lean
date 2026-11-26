"""Experimental Decimal runtime; separate from the v0.1 exact subset.

Supports literals, inputs, derived refs, arithmetic, extrema and ceil/floor. Rule
rounding is applied before returning a dependency's value. Unsupported nodes
are refused; this is not the complete artifact interpreter.
"""
from operator import eq, ge, gt, le, lt, ne

from tools.compile_ir import Unsupported, named, parse_date, require, version_at
from tools.decimal_model import DecimalFault, DecimalValue, boolean_read, judgment_body, parameter_values, snapshot_literal
from tools.request_binding import annual_key, count_key, member_key

COMPARISONS = {"eq": eq, "ne": ne, "lt": lt, "lte": le, "gt": gt, "gte": ge}


class NumericRuntime:
    def __init__(self, artifact, as_of, *, member_scope=False):
        self.artifact = artifact
        self.member_scope = member_scope
        self.program = artifact["program"]
        self.rules = {r["name"]: r for r in self.program["derived"]}
        self.as_of = parse_date(as_of)
        self.units = {u["name"]: u for u in self.program.get("units", [])}
        self.parameters = named(self.program.get("parameters", []))
        self.boolean_inputs = {item["name"] for item in self.program.get("interface", {}).get("inputs", [])
                               if item.get("dtype") == "bool"}

    def judgment(self, name, env):
        return self.predicate({"kind": "derived", "name": name}, env, ())

    def rule(self, name, env, visiting=()):
        require(name not in visiting, "numeric dependency cycle")
        rule = self.rules[name]
        versions = rule.get("versions", [])
        active = version_at(versions, self.as_of) if versions else rule
        if active is None:
            raise DecimalFault("missingRuleVersion")
        require(active["semantics"] == "scalar", "numeric scalar required")
        value = self.expr(active["expr"], env, (*visiting, name))
        if rule.get("rounding") is not None:
            unit = self.units[rule["unit"]]
            require(unit["kind"] == "currency", "rounding needs currency")
            value = value.round(unit["minor_units"], rule["rounding"])
        return value

    def expr(self, expr, env, visiting):
        kind = expr["kind"]
        if kind == "derived":
            return self.rule(expr["name"], env, visiting)
        if kind == "input_or_else":
            return self.literal(env.get(expr["name"], expr["default"]))
        if kind in ("count_related", "sum_related"):
            require(not self.member_scope, "nested relation aggregation not supported")
            slots = (expr["relation"], expr["current_slot"], expr["related_slot"])
            where = expr.get("where")
            if kind == "sum_related" or where is not None:
                key = member_key(*slots)
                require(key in env, "missing bound relation members")
                runtime = NumericRuntime(self.artifact, self.as_of.isoformat(), member_scope=True)
                selected = (facts for facts in env[key] if where is None or runtime.predicate(where, facts, ()))
                if kind == "count_related":
                    return DecimalValue(sum(1 for _ in selected), 0)
                value = expr["value"]
                require(value.get("kind") in {"input", "derived"}, "unsupported related sum value")
                total = DecimalValue(0, 0)
                for facts in selected:
                    total = total.arithmetic("add", runtime.expr(value, facts, ()))
                return total
            key = count_key(*slots)
            require(key in env, "missing bound direct relation count")
            return self.literal(env[key])
        if kind in ("input", "input_for_year"):
            require(kind != "input_for_year" or not self.member_scope, "historical member input not supported")
            name = expr["name"] if kind == "input" else annual_key(expr["input"], expr["year"])
            if name not in env:
                raise DecimalFault("missingInput")
            return self.literal(env[name])
        if kind == "literal":
            return self.literal(expr["value"])
        if kind == "no_match":
            self.expr(expr["subject"], env, visiting)
            raise DecimalFault("noMatchingArm")
        if kind == "parameter_lookup":
            key = self.expr(expr["index"], env, visiting).as_index()
            table = parameter_values(expr, self.parameters, self.as_of)
            if key not in table:
                raise DecimalFault("missingParameterValue")
            return table[key]
        if kind == "if":
            matches = self.predicate(expr["condition"], env, visiting)
            return self.expr(expr["then_expr"] if matches else expr["else_expr"], env, visiting)
        if kind in ("sub", "mul", "div"):
            if kind == "div":
                b = self.expr(expr["right"], env, visiting)
                if b.coefficient == 0:
                    raise DecimalFault("divisionByZero")
                a = self.expr(expr["left"], env, visiting)
            else:
                a = self.expr(expr["left"], env, visiting)
                b = self.expr(expr["right"], env, visiting)
            return a.arithmetic(kind, b)
        if kind == "add":
            value = DecimalValue(0, 0)
            for item in expr["items"]:
                value = value.arithmetic("add", self.expr(item, env, visiting))
            return value
        if kind in ("ceil", "floor"):
            return self.expr(expr["value"], env, visiting).round(0, kind)
        if kind in ("max", "min"):
            require(bool(expr["items"]), f"{kind} requires an operand")
            items = iter(expr["items"])
            best = self.expr(next(items), env, visiting)
            for item in items:
                candidate = self.expr(item, env, visiting)
                left = candidate.coefficient * 10**best.scale
                right = best.coefficient * 10**candidate.scale
                if (left > right if kind == "max" else left < right):
                    best = candidate
            return best
        raise Unsupported(f"unsupported numeric runtime node: {kind}")

    def predicate(self, expr, env, visiting):
        kind = expr["kind"]
        if kind == "derived":
            name = expr["name"]
            require(name not in visiting, "numeric judgment dependency cycle")
            body = judgment_body(name, self.rules, self.as_of)
            if body is None:
                raise DecimalFault("missingRuleVersion")
            return self.predicate(body, env, (*visiting, name))
        if kind == "comparison":
            op = expr.get("op")
            require(isinstance(op, str) and op in COMPARISONS, "unsupported comparison operator")
            reads = [boolean_read(expr[key], env, self.boolean_inputs) for key in ("left", "right")]
            if any(value is not NotImplemented for value in reads):
                require(op in {"eq", "ne"} and all(value is not NotImplemented for value in reads),
                        "boolean comparison requires two boolean operands and equality or inequality")
                values = []
                for value in reads:
                    if value is None:
                        raise DecimalFault("missingInput")
                    boolean = snapshot_literal(value)
                    require(type(boolean) is bool, "expected boolean input")
                    values.append(boolean)
                return COMPARISONS[op](*values)
            left = self.expr(expr["left"], env, visiting)
            right = self.expr(expr["right"], env, visiting)
            return COMPARISONS[op](left.coefficient * 10**right.scale,
                                   right.coefficient * 10**left.scale)
        if kind == "not":
            return not self.predicate(expr["item"], env, visiting)
        if kind in ("and", "or"):
            items = (self.predicate(item, env, visiting) for item in expr["items"])
            return all(items) if kind == "and" else any(items)
        raise Unsupported(f"unsupported Decimal predicate node: {kind}")

    @staticmethod
    def literal(value):
        return DecimalValue.from_literal(value)
