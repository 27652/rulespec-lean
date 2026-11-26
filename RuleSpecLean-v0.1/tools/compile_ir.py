"""RuleSpec artifact v3 -> Lean source, for a deliberately restricted snapshot.

No external Python packages. The accepted wire subset is based on upstream
src/spec.rs and exercised with retained artifacts from the pinned compiler.
The input must have been validated by the official compiler/loader.
"""
from __future__ import annotations
import argparse
from datetime import date
from fractions import Fraction
import hashlib
import json
from pathlib import Path
import re

SCALE = 10**6
LIMIT = 10**21
I64_MIN, I64_MAX = -(2**63), 2**63 - 1

class Unsupported(ValueError):
    pass

class EvalFault(Exception):
    pass

def require(cond, msg):
    if not cond:
        raise Unsupported(msg)

def named(rows):
    require(isinstance(rows, list), "expected list")
    result = {}
    for row in rows:
        require(isinstance(row, dict) and "name" in row, "expected named object")
        n = row["name"]
        require(isinstance(n, str) and n and n not in result,
                f"invalid or duplicate name {n!r}")
        result[n] = row
    return result

def parse_value(v):
    require(isinstance(v, dict) and set(v) == {"kind", "value"}, "malformed literal")
    k, x = v["kind"], v["value"]
    if k == "integer":
        require(type(x) is int and I64_MIN <= x <= I64_MAX, "invalid integer")
        return (k, x)
    if k == "decimal":
        require(type(x) in (str, int) and re.fullmatch(r"[+-]?\d+(?:\.\d+)?", str(x)) is not None,
                "decimal must use plain exact notation")
        q = Fraction(str(x)) * SCALE
        require(q.denominator == 1 and abs(q.numerator) <= LIMIT, "decimal outside exact subset")
        return (k, q.numerator)
    if k == "bool":
        require(type(x) is bool, "invalid bool")
        return (k, x)
    if k == "text":
        require(isinstance(x, str), "invalid text")
        return (k, x)
    raise Unsupported(f"literal kind {k}")

def parse_date(value):
    require(isinstance(value, str), "expected date in YYYY-MM-DD format")
    try:
        parsed = date.fromisoformat(value)
    except ValueError as exc:
        raise Unsupported("expected valid date in YYYY-MM-DD format") from exc
    require(parsed.isoformat() == value, "expected date in YYYY-MM-DD format")
    return parsed


def version_at(versions, as_of):
    valid = []
    for i, v in enumerate(versions):
        start = parse_date(v["effective_from"])
        effective_to = v.get("effective_to")
        end = parse_date(effective_to) if effective_to is not None else None
        require(end is None or start <= end, "invalid version interval")
        if start <= as_of and (end is None or as_of <= end):
            valid.append((start, i, v))
    return max(valid, key=lambda p: (p[0], p[1]))[2] if valid else None

def expr_fields(e, keys):
    require(isinstance(e, dict) and set(e) == set(keys) | {"kind"},
            f"unknown/missing fields for {e.get('kind') if isinstance(e, dict) else e}")

class Compiler:
    def __init__(self, artifact, as_of):
        require(isinstance(artifact, dict), "expected artifact object")
        require(type(artifact.get("artifact_format_version")) is int and
                artifact["artifact_format_version"] == 3, "only artifact format 3")
        self.artifact = artifact
        self.as_of = parse_date(as_of)
        self.program = p = artifact["program"]
        require(isinstance(p, dict), "expected program object")
        self.rules = named(p.get("derived", []))
        self.parameters = named(p.get("parameters", []))
        self.normal = {}
        self.selected = {}
        self.visiting = set()

    def rule(self, name, expected=None):
        require(name in self.rules, f"unknown derived rule {name}")
        r = self.rules[name]
        require(r.get("rounding") is None, f"{name}: output rounding not supported")
        versions = r.get("versions", [])
        active = version_at(versions, self.as_of) if versions else r
        sem = (active or r)["semantics"]
        require(sem in ("scalar", "judgment"), f"{name}: unsupported semantics")
        require(expected is None or sem == expected, f"{name}: scalar/judgment mismatch")
        if name not in self.normal:
            require(name not in self.visiting, f"dependency cycle at {name}")
            self.visiting.add(name)
            try:
                tree = ("fault", "missingVersion") if active is None else self.lower(active["expr"], sem)
                self.normal[name] = tree
                self.selected[name] = {
                    "semantics": sem,
                    "effective_from": (active or {}).get("effective_from"),
                    "effective_to": (active or {}).get("effective_to"),
                    "missing_version": active is None,
                    "source": r.get("source"),
                    "source_url": r.get("source_url"),
                    "corpus_citation_path": r.get("corpus_citation_path"),
                    "public_id": r.get("id"),
                }
            finally:
                self.visiting.remove(name)
        return ("ref", name)

    def lower(self, e, sem):
        require(isinstance(e, dict) and isinstance(e.get("kind"), str),
                "expected expression object with kind")
        k = e["kind"]
        def scalar(x): return self.lower(x, "scalar")
        def judgment(x): return self.lower(x, "judgment")
        if k == "derived":
            expr_fields(e, ["name"])
            return self.rule(e["name"], sem)
        if sem == "judgment":
            if k == "comparison":
                expr_fields(e, ["left", "op", "right"])
                require(e["op"] in {"eq", "ne", "lt", "lte", "gt", "gte"}, "comparison op")
                return ("binary", e["op"], scalar(e["left"]), scalar(e["right"]))
            if k == "not":
                expr_fields(e, ["item"])
                return ("unary", "negateJudgment", judgment(e["item"]))
            if k in ("and", "or"):
                expr_fields(e, ["items"])
                require(isinstance(e["items"], list), f"{k}: expected items list")
                op = "andAlso" if k == "and" else "orElse"
                tree = ("lit", ("judgment", "holds" if k == "and" else "notHolds"))
                for x in reversed(e["items"]):
                    tree = ("binary", op, judgment(x), tree)
                return tree
            raise Unsupported(f"unsupported judgment node {k}")
        if k == "literal":
            expr_fields(e, ["value"])
            return ("lit", parse_value(e["value"]))
        if k == "input":
            expr_fields(e, ["name"])
            require(isinstance(e["name"], str), "invalid input slot")
            return ("input", e["name"])
        if k == "no_match":
            expr_fields(e, ["subject", "patterns"])
            require(isinstance(e["patterns"], list), "invalid match patterns")
            return ("noMatch", scalar(e["subject"]))
        if k == "if":
            expr_fields(e, ["condition", "then_expr", "else_expr"])
            return ("choose", judgment(e["condition"]), scalar(e["then_expr"]), scalar(e["else_expr"]))
        if k in ("sub", "mul", "div"):
            expr_fields(e, ["left", "right"])
            return ("binary", k, ("unary", "numeric", scalar(e["left"])),
                    ("unary", "numeric", scalar(e["right"])))
        if k in ("ceil", "floor"):
            expr_fields(e, ["value"])
            return ("unary", k, scalar(e["value"]))
        if k in ("add", "min", "max"):
            expr_fields(e, ["items"])
            a = e["items"]
            require(isinstance(a, list) and (k == "add" or len(a) >= 1), f"{k}: invalid arity")
            # Left fold mirrors sequential numeric conversion and accumulation.
            items = [("unary", "numeric", scalar(x)) for x in a]
            tree = ("lit", ("decimal", 0)) if k == "add" else items.pop(0)
            for item in items:
                tree = ("binary", k, tree, item)
            return tree
        if k == "parameter_lookup":
            expr_fields(e, ["parameter", "index"])
            require(e["parameter"] in self.parameters, "unknown parameter")
            p = self.parameters[e["parameter"]]
            v = version_at(p.get("versions", []), self.as_of)
            # The engine evaluates and validates the index before looking up
            # either the version or the key. Both absent cases share a fault.
            if v is None:
                return ("lookup", [], scalar(e["index"]))
            entries = []
            for key, val in v["values"].items():
                i = int(key)
                require(str(i) == key and I64_MIN <= i <= I64_MAX, "invalid parameter key")
                entries.append((i, parse_value(val)))
            return ("lookup", sorted(entries), scalar(e["index"]))
        raise Unsupported(f"unsupported scalar node {k}")

    def compile(self, outputs):
        for name in outputs:
            self.rule(name)
        return self.normal

def number(v):
    if v[0] == "integer":
        return v[1] * SCALE
    if v[0] == "decimal":
        return v[1]
    raise EvalFault("typeMismatch")

def judgment(v):
    if v[0] != "judgment":
        raise EvalFault("typeMismatch")
    return v[1]

def checked(n):
    if abs(n) > LIMIT:
        raise EvalFault("outsideExactDomain")
    return ("decimal", n)

def quot(n, d):
    if not d:
        raise EvalFault("divisionByZero")
    q, r = divmod(n, d)
    if r:
        raise EvalFault("outsideExactDomain")
    return checked(q)

def run(tree, env, rules):
    k, *args = tree
    if k == "lit":
        return args[0]
    if k == "fault":
        raise EvalFault(args[0])
    if k == "noMatch":
        run(args[0], env, rules)
        raise EvalFault("noMatchingArm")
    if k == "input":
        if args[0] not in env:
            raise EvalFault("missingInput")
        return parse_value(env[args[0]])
    if k == "ref":
        return run(rules[args[0]], env, rules)
    if k == "choose":
        c, a, b = args
        return run(a if judgment(run(c, env, rules)) == "holds" else b, env, rules)
    if k == "lookup":
        entries, idx = args
        n = number(run(idx, env, rules))
        if n % SCALE or not I64_MIN <= n//SCALE <= I64_MAX:
            raise EvalFault("typeMismatch")
        if n//SCALE not in dict(entries):
            raise EvalFault("missingParameter")
        return dict(entries)[n//SCALE]
    if k == "unary":
        op, a = args
        v = run(a, env, rules)
        if op == "negateJudgment":
            return ("judgment", {"holds":"notHolds", "notHolds":"holds",
                                  "undetermined":"undetermined"}[judgment(v)])
        n = number(v)
        return checked((n//SCALE)*SCALE if op == "floor" else
                       -((-n)//SCALE)*SCALE if op == "ceil" else n)
    op, a, b = args
    if op == "div":
        bv = run(b, env, rules)
        y = number(bv)
        if y == 0:
            raise EvalFault("divisionByZero")
        return quot(number(run(a, env, rules))*SCALE, y)
    av = run(a, env, rules)
    if op in ("andAlso", "orElse"):
        x = judgment(av)
        stop = "notHolds" if op == "andAlso" else "holds"
        if x == stop:
            return ("judgment", stop)
        y = judgment(run(b, env, rules))
        return ("judgment", stop if y == stop else "undetermined" if
                "undetermined" in (x,y) else x)
    bv = run(b, env, rules)
    if op in ("eq", "ne", "lt", "lte", "gt", "gte"):
        if av[0] == bv[0] and av[0] in ("bool","text"):
            if op not in ("eq", "ne"):
                raise EvalFault("typeMismatch")
            x,y = av[1],bv[1]
        else:
            x,y = number(av),number(bv)
        ok = {"eq":lambda:x==y,"ne":lambda:x!=y,"lt":lambda:x<y,
              "lte":lambda:x<=y,"gt":lambda:x>y,"gte":lambda:x>=y}[op]()
        return ("judgment", "holds" if ok else "notHolds")
    x,y = number(av),number(bv)
    if op == "mul":
        return quot(x*y,SCALE)
    return checked({"add":lambda:x+y,"sub":lambda:x-y,
                    "max":lambda:max(x,y),"min":lambda:min(x,y)}[op]())

def lean_str(s):
    require(all(ord(c) >= 32 and ord(c) != 127 for c in s), "control character in Lean string")
    return json.dumps(s, ensure_ascii=False)

def lean_value(v):
    k,x = v
    if k in ("decimal","integer"):
        return f"(Value.{k} ({x}))"
    if k == "bool":
        return "(Value.boolean " + str(x).lower() + ")"
    if k == "text":
        return f"(Value.text {lean_str(x)})"
    return f"(Value.judgment .{x})"

def lean_expr(tree, names):
    k, *a = tree
    if k == "ref":
        return names[a[0]]
    if k == "lit":
        return f"(Expr.lit {lean_value(a[0])})"
    if k == "input":
        return f"(Expr.input {lean_str(a[0])})"
    if k == "fault":
        return f"(Expr.fault .{a[0]})"
    if k == "noMatch":
        return f"(Expr.noMatch {lean_expr(a[0],names)})"
    if k == "unary":
        return f"(Expr.unary .{a[0]} {lean_expr(a[1],names)})"
    if k == "binary":
        return f"(Expr.binary .{a[0]} {lean_expr(a[1],names)} {lean_expr(a[2],names)})"
    if k == "choose":
        return "(Expr.choose " + " ".join(lean_expr(x,names) for x in a) + ")"
    if k == "lookup":
        entries = ", ".join(f"(({i}), {lean_value(v)})" for i,v in a[0])
        return f"(Expr.lookup [{entries}] {lean_expr(a[1],names)})"
    raise AssertionError(k)

def emit(compiler, outputs):
    names = {n:f"rule_{i}" for i,n in enumerate(compiler.normal)}
    lines = ["import RuleSpecLean.Core", "", "namespace RuleSpecLean.Generated", ""]
    for n,t in compiler.normal.items():
        lines.append(f"def {names[n]} : Expr :=\n  {lean_expr(t,names)}\n")
    for i,n in enumerate(outputs):
        lines.append(f"def output_{i} : Expr := {names[n]}")
    lines += ["", "end RuleSpecLean.Generated", ""]
    return "\n".join(lines), names

def main():
    p=argparse.ArgumentParser()
    p.add_argument("artifact", type=Path)
    p.add_argument("--as-of", required=True)
    p.add_argument("--output", action="append", required=True, help="Internal IR rule name")
    p.add_argument("--lean", type=Path, default=Path("RuleSpecLean/Generated.lean"))
    p.add_argument("--manifest", type=Path, default=Path("generated-manifest.json"))
    args=p.parse_args()
    raw=args.artifact.read_bytes()
    c=Compiler(json.loads(raw),args.as_of)
    c.compile(args.output)
    lean,names=emit(c,args.output)
    manifest={
        "prototype":"0.1.0",
        "artifact_sha256":hashlib.sha256(raw).hexdigest(),
        "engine_version":c.artifact.get("engine_version"),
        "engine_build":c.artifact.get("engine_build"),
        "source_closure":c.artifact.get("source_closure"),
        "as_of":args.as_of,
        "outputs":{n:f"output_{i}" for i,n in enumerate(args.output)},
        "rules":{n:{"lean":names[n],**m} for n,m in c.selected.items()},
        "limits":"Single prebound entity/period, no pins, exact scale-6 numeric subset",
    }
    args.lean.parent.mkdir(parents=True,exist_ok=True)
    args.manifest.parent.mkdir(parents=True,exist_ok=True)
    args.lean.write_text(lean,encoding="utf-8")
    args.manifest.write_text(json.dumps(manifest,indent=2,ensure_ascii=False)+"\n",encoding="utf-8")
    print(f"Generated {len(names)} rules -> {args.lean}")

if __name__=="__main__":
    main()
