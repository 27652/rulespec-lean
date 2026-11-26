"""Experimental artifact-to-Decimal Expr lowering for a prebound snapshot.

Supports numeric arithmetic, extrema, rounding, predicates and parameter tables.
Input values are embedded for the supplied request; generated terms are not a
general dataset adapter. Rule rounding remains inside dependency definitions.
"""
import argparse
import hashlib
import json
from pathlib import Path

from tools.compile_ir import expr_fields, named, parse_date, require, version_at
from tools.decimal_model import DecimalValue, MODES, boolean_read, judgment_body, parameter_values, snapshot_literal
from tools.request_binding import annual_key, bind, count_key, member_key

LEAN_MODES = dict(zip(MODES, ("halfUp", "halfEven", "floor", "ceil")))
COMPARISONS = frozenset(("eq", "ne", "lt", "lte", "gt", "gte"))


class DecimalCompiler:
    def __init__(self, artifact, as_of, env, *, allow_missing=False, member_scope=False):
        require(type(artifact.get("artifact_format_version")) is int and
                artifact["artifact_format_version"] == 3, "artifact v3 required")
        self.artifact = artifact
        self.member_scope = member_scope
        self.rules = named(artifact["program"]["derived"])
        self.units = named(artifact["program"].get("units", []))
        self.parameters = named(artifact["program"].get("parameters", []))
        self.boolean_inputs = {item["name"] for item in artifact["program"].get("interface", {}).get("inputs", [])
                               if item.get("dtype") == "bool"}
        self.as_of = parse_date(as_of)
        self.env = env
        self.allow_missing = allow_missing
        self.definitions = {}
        self.visiting = set()

    def literal(self, value):
        number = DecimalValue.from_literal(value)
        return f"(Expr.lit ⟨({number.coefficient}), {number.scale}⟩)"

    def rule(self, name):
        require(name in self.rules, f"unknown numeric rule {name}")
        if name in self.definitions:
            return self.definitions[name][0]
        require(name not in self.visiting, "numeric dependency cycle")
        self.visiting.add(name)
        try:
            rule = self.rules[name]
            versions = rule.get("versions", [])
            active = version_at(versions, self.as_of) if versions else rule
            if active is None and self.allow_missing:
                return "Expr.missingRuleVersion"
            require(active is not None, "missing numeric rule version")
            require(active["semantics"] == "scalar", "numeric scalar required")
            body = self.expr(active["expr"])
            if rule.get("rounding") is not None:
                mode = rule["rounding"]
                require(mode in LEAN_MODES, "unsupported rounding mode")
                require(rule.get("unit") in self.units, "unknown rounding unit")
                unit = self.units[rule["unit"]]
                places = unit.get("minor_units")
                require(unit["kind"] == "currency" and type(places) is int and
                        0 <= places <= 28, "invalid currency precision")
                body = f"(Expr.rounded {places} .{LEAN_MODES[mode]} {body})"
            identifier = f"rule_{len(self.definitions)}"
            self.definitions[name] = (identifier, body)
            return identifier
        finally:
            self.visiting.remove(name)

    def expr(self, expr):
        require(isinstance(expr, dict) and "kind" in expr, "expected numeric expression")
        kind = expr["kind"]
        if kind == "literal":
            expr_fields(expr, ["value"])
            return self.literal(expr["value"])
        if kind == "no_match":
            expr_fields(expr, ["subject", "patterns"])
            require(isinstance(expr["patterns"], list), "invalid match patterns")
            return f"(Expr.noMatch {self.expr(expr['subject'])})"
        if kind == "input_or_else":
            expr_fields(expr, ["name", "default"])
            fallback = self.literal(expr["default"])
            if expr["name"] in self.env:
                return self.literal(self.env[expr["name"]])
            return fallback
        if kind in ("count_related", "sum_related"):
            fields = ["relation", "current_slot", "related_slot"]
            if "where" in expr:
                fields.append("where")
            if kind == "sum_related":
                fields.append("value")
            expr_fields(expr, fields)
            require(not self.member_scope, "nested relation aggregation not supported")
            slots = (expr["relation"], expr["current_slot"], expr["related_slot"])
            where = expr.get("where")
            if kind == "sum_related" or where is not None:
                key = member_key(*slots)
                require(key in self.env, "missing bound relation members")
                terms = []
                if kind == "sum_related":
                    value = expr["value"]
                    require(value.get("kind") in {"input", "derived"}, "unsupported related sum value")
                for member in self.env[key]:
                    compiler = DecimalCompiler(self.artifact, self.as_of.isoformat(), member,
                                               allow_missing=True, member_scope=True)
                    condition = compiler.predicate(where) if where is not None else "(Predicate.constant true)"
                    if kind == "sum_related":
                        term = f"({condition}, {compiler.expr(value)})"
                    else:
                        term = condition
                    for identifier, body in reversed(list(compiler.definitions.values())):
                        term = f"(let {identifier} : Expr := {body}; {term})"
                    terms.append(term)
                operator = "sumWhere" if kind == "sum_related" else "countWhere"
                return f"(Expr.{operator} [{', '.join(terms)}])"
            key = count_key(*slots)
            require(key in self.env, "missing bound direct relation count")
            return self.literal(self.env[key])
        if kind in ("input", "input_for_year"):
            if kind == "input":
                expr_fields(expr, ["name"])
                key = expr["name"]
            else:
                require(not self.member_scope, "historical member input not supported")
                expr_fields(expr, ["input", "year"])
                key = annual_key(expr["input"], expr["year"])
            if self.allow_missing and key not in self.env:
                return "Expr.missingInput"
            require(key in self.env, "missing prebound numeric input")
            return self.literal(self.env[key])
        if kind == "derived":
            expr_fields(expr, ["name"])
            return self.rule(expr["name"])
        if kind == "parameter_lookup":
            table = parameter_values(expr, self.parameters, self.as_of)
            entries = ", ".join(f"(({key}), ⟨({value.coefficient}), {value.scale}⟩)"
                                for key, value in sorted(table.items()))
            return f"(Expr.lookup [{entries}] {self.expr(expr['index'])})"
        if kind == "if":
            expr_fields(expr, ["condition", "then_expr", "else_expr"])
            condition = self.predicate(expr["condition"])
            on_true, on_false = (self.expr(expr[key]) for key in ("then_expr", "else_expr"))
            return f"(Expr.choose {condition} {on_true} {on_false})"
        if kind in ("sub", "mul", "div"):
            expr_fields(expr, ["left", "right"])
            return f"(Expr.binary .{kind} {self.expr(expr['left'])} {self.expr(expr['right'])})"
        if kind in ("ceil", "floor"):
            expr_fields(expr, ["value"])
            return f"(Expr.rounded 0 .{kind} {self.expr(expr['value'])})"
        if kind in ("add", "max", "min"):
            expr_fields(expr, ["items"])
            items = expr["items"]
            require(isinstance(items, list), f"{kind} items must be a list")
            if kind == "add":
                body = "(Expr.lit ⟨0, 0⟩)"
                operator = "Expr.binary .add"
            else:
                require(bool(items), f"{kind} requires an operand")
                body = self.expr(items[0])
                items = items[1:]
                operator = "Expr.extreme true" if kind == "max" else "Expr.extreme false"
            for item in items:
                body = f"({operator} {body} {self.expr(item)})"
            return body
        raise ValueError(f"unsupported Decimal compiler node: {kind}")

    def predicate(self, expr):
        require(isinstance(expr, dict), "expected predicate object")
        kind = expr.get("kind")
        if kind == "derived":
            expr_fields(expr, ["name"])
            name = expr["name"]
            body = judgment_body(name, self.rules, self.as_of)
            if body is None and self.allow_missing:
                return "Predicate.missingRuleVersion"
            require(body is not None, "missing numeric judgment version")
            require(name not in self.visiting, "numeric judgment dependency cycle")
            self.visiting.add(name)
            try:
                return self.predicate(body)
            finally:
                self.visiting.remove(name)
        if kind == "comparison":
            expr_fields(expr, ["op", "left", "right"])
            op = expr["op"]
            require(isinstance(op, str) and op in COMPARISONS, "unsupported comparison operator")
            operands = [expr["left"], expr["right"]]
            reads = [boolean_read(operand, self.env, self.boolean_inputs) for operand in operands]
            if any(value is not NotImplemented for value in reads):
                require(op in {"eq", "ne"} and all(value is not NotImplemented for value in reads),
                        "boolean comparison requires two boolean operands and equality or inequality")
                rendered = []
                for operand, value in zip(operands, reads, strict=True):
                    expr_fields(operand, ["name"] if operand["kind"] == "input" else ["value"])
                    if value is None:
                        require(self.allow_missing, "missing prebound boolean input")
                        rendered.append("none")
                    else:
                        boolean = snapshot_literal(value)
                        require(type(boolean) is bool, "expected boolean input")
                        rendered.append(f"(some {str(boolean).lower()})")
                equality = str(op == "eq").lower()
                return f"(Predicate.compareBool {equality} {' '.join(rendered)})"
            return f"(Predicate.compare .{op} {self.expr(expr['left'])} {self.expr(expr['right'])})"
        if kind == "not":
            expr_fields(expr, ["item"])
            return f"(Predicate.negate {self.predicate(expr['item'])})"
        if kind in ("and", "or"):
            expr_fields(expr, ["items"])
            require(isinstance(expr["items"], list), "predicate items must be a list")
            body = "(Predicate.constant true)" if kind == "and" else "(Predicate.constant false)"
            operator = "andAlso" if kind == "and" else "orElse"
            for item in reversed(expr["items"]):
                body = f"(Predicate.{operator} {self.predicate(item)} {body})"
            return body
        raise ValueError(f"unsupported Decimal predicate node: {kind}")

    def emit(self, output, namespace, *, judgment=False):
        require(namespace.isascii() and namespace.isidentifier(), "invalid Lean namespace")
        if judgment:
            body = self.predicate({"kind": "derived", "name": output})
            output_type = "Predicate"
        else:
            body = self.rule(output)
            output_type = "Expr"
        lines = ["import RuleSpecLean.Decimal", "", f"namespace {namespace}",
                 "open RuleSpecLean.DecimalModel", ""]
        lines.extend(f"def {n} : Expr := {body}" for n, body in self.definitions.values())
        lines.extend([f"def output : {output_type} := {body}", f"end {namespace}", ""])
        return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("artifact", type=Path)
    parser.add_argument("--as-of", required=True)
    inputs = parser.add_mutually_exclusive_group(required=True)
    inputs.add_argument("--env", type=Path, help="Use a prebound environment")
    inputs.add_argument("--request", type=Path, help="Bind one official Explain request")
    parser.add_argument("--covering", action="store_true", help="Select the latest covering input spell")
    parser.add_argument("--relation-counts", action="store_true", help="Bind unfiltered direct relation counts")
    parser.add_argument("--filtered-counts", action="store_true", help="Bind direct member facts for count and sum filters")
    parser.add_argument("--output", required=True)
    parser.add_argument("--judgment", action="store_true", help="Generate a numeric judgment output")
    parser.add_argument("--lean", required=True, type=Path)
    args = parser.parse_args()
    raw = args.artifact.read_bytes()
    artifact = json.loads(raw)
    if args.covering and not args.request:
        parser.error("--covering requires --request")
    if (args.relation_counts or args.filtered_counts) and not args.request:
        parser.error("relation count binding requires --request")
    if args.request:
        request_raw = args.request.read_bytes()
        request = json.loads(request_raw)
        env = bind(artifact, request, args.output, validate_value=snapshot_literal,
                   covering=args.covering, read_site_defaults=True, relation_counts=args.relation_counts,
                   filtered_counts=args.filtered_counts)
        require(request["queries"][0]["period"]["start"] == args.as_of,
                "snapshot must equal query period start")
        env_raw = json.dumps(env, sort_keys=True, separators=(",", ":")).encode()
        binding = {"request_sha256": hashlib.sha256(request_raw).hexdigest(),
                   "binding": "latest-covering" if args.covering else "exact-interval",
                   "relation_counts": args.relation_counts, "filtered_counts": args.filtered_counts}
    else:
        env_raw = args.env.read_bytes()
        env = json.loads(env_raw)
        binding = {}
    compiler = DecimalCompiler(artifact, args.as_of, env, allow_missing=args.request is not None)
    source = compiler.emit(args.output, "DecimalGenerated", judgment=args.judgment)
    args.lean.parent.mkdir(parents=True, exist_ok=True)
    args.lean.write_text(source)
    args.lean.with_suffix(".manifest.json").write_text(json.dumps({
        "artifact_sha256": hashlib.sha256(raw).hexdigest(), "as_of": args.as_of,
        "output": args.output, "env_sha256": hashlib.sha256(env_raw).hexdigest(),
        "output_kind": "judgment" if args.judgment else "scalar", **binding,
        "scope": "experimental Decimal snapshot"}, indent=2) + "\n")


if __name__ == "__main__":
    main()
