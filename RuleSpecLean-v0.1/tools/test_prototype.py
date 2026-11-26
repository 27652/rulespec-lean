import copy
from fractions import Fraction
import json
import math
import random
from pathlib import Path
import unittest

from tools.compile_ir import Compiler, Unsupported, EvalFault, run, emit, SCALE

ROOT = Path(__file__).resolve().parents[1]
FIXTURE = json.loads((ROOT/"fixtures/ctc-like.artifact.json").read_text())

def env(magi=401250, children=2, other=1, joint=True, eligible=True):
    return {k:{"kind":"bool" if type(v) is bool else "integer","value":v}
            for k,v in dict(magi=magi, children=children, other_dependents=other,
                            joint_filing=joint,id_ok=eligible,year_ok=True).items()}

def oracle(magi,children,other,joint,eligible,year):
    if not eligible:
        return 0
    base=children*(2200 if year>=2025 else 2000)+other*500
    step=math.ceil(Fraction(max(0,magi-(400000 if joint else 200000)),1000))
    return max(0,base-50*step)

class PrototypeTests(unittest.TestCase):
    def compiler(self, date="2025-01-01"):
        c=Compiler(copy.deepcopy(FIXTURE),date)
        c.compile(["credit"])
        return c
    def evaluate(self,c,e):
        return run(c.normal["credit"],e,c.normal)
    def test_example(self):
        self.assertEqual(self.evaluate(self.compiler(),env()),("decimal",4800*SCALE))
    def test_history(self):
        self.assertEqual(self.evaluate(self.compiler("2024-12-31"),env()),("decimal",4400*SCALE))
    def test_boundary(self):
        c=self.compiler()
        for x,y in [(399999,4900),(400000,4900),(400001,4850),(401000,4850),
                    (401001,4800),(498000,0),(999999,0)]:
            self.assertEqual(self.evaluate(c,env(magi=x)),("decimal",y*SCALE))
    def test_randomized_oracle(self):
        rng=random.Random(20261126)
        for yr in (2024,2025):
            c=self.compiler(f"{yr}-01-01")
            for _ in range(5000):
                data=(rng.randrange(0,900001),rng.randrange(0,9),rng.randrange(0,9),
                      bool(rng.randrange(2)),bool(rng.randrange(2)))
                self.assertEqual(self.evaluate(c,env(*data)),("decimal",oracle(*data,yr)*SCALE))
    def test_lazy_branch(self):
        c=self.compiler()
        self.assertEqual(self.evaluate(c,{"id_ok":{"kind":"bool","value":False}}),("decimal",0))
    def test_missing_input(self):
        with self.assertRaisesRegex(EvalFault,"missingInput"):
            self.evaluate(self.compiler(),{})
    def test_divisor_first(self):
        t=("binary","div",("input","missing"),("lit",("integer",0)))
        with self.assertRaisesRegex(EvalFault,"divisionByZero"):
            run(t,{}, {})
    def test_exact_domain(self):
        t=("binary","div",("lit",("integer",1)),("lit",("integer",3)))
        with self.assertRaisesRegex(EvalFault,"outsideExactDomain"):
            run(t,{}, {})
    def test_negative_rounding(self):
        a=("lit",("decimal",-1200000))
        self.assertEqual(run(("unary","floor",a),{},{}),("decimal",-2000000))
        self.assertEqual(run(("unary","ceil",a),{},{}),("decimal",-1000000))
    def test_unknown_condition(self):
        t=("choose",("lit",("judgment","undetermined")),("input","missing"),("lit",("integer",3)))
        self.assertEqual(run(t,{},{}),("integer",3))
    def test_three_valued(self):
        vals=["holds","notHolds","undetermined"]
        for op in ("andAlso","orElse"):
            for x in vals:
                for y in vals:
                    t=("binary",op,("lit",("judgment",x)),("lit",("judgment",y)))
                    order={"notHolds":0,"undetermined":1,"holds":2}
                    expected=(min if op=="andAlso" else max)((x,y),key=order.get)
                    self.assertEqual(run(t,{},{}),("judgment",expected))
    def test_wrong_type(self):
        t=("unary","numeric",("lit",("bool",True)))
        with self.assertRaisesRegex(EvalFault,"typeMismatch"):
            run(t,{}, {})
    def test_unsupported_node(self):
        a=copy.deepcopy(FIXTURE)
        a["program"]["derived"][-1]["versions"][0]["expr"]={"kind":"count_related"}
        with self.assertRaisesRegex(Unsupported,"count_related"):
            Compiler(a,"2025-01-01").compile(["credit"])
    def test_cycle(self):
        a=copy.deepcopy(FIXTURE)
        a["program"]["derived"][-1]["versions"][0]["expr"]={"kind":"derived","name":"credit"}
        with self.assertRaisesRegex(Unsupported,"cycle"):
            Compiler(a,"2025-01-01").compile(["credit"])
    def test_wire_gate(self):
        a=copy.deepcopy(FIXTURE)
        a["artifact_format_version"]=2
        with self.assertRaises(Unsupported):
            Compiler(a,"2025-01-01")
    def test_unsupported_rounding(self):
        a=copy.deepcopy(FIXTURE)
        a["program"]["derived"][-1]["rounding"]="half_up"
        with self.assertRaisesRegex(Unsupported,"rounding"):
            Compiler(a,"2025-01-01").compile(["credit"])
    def test_missing_version(self):
        c=self.compiler("2017-01-01")
        with self.assertRaisesRegex(EvalFault,"missingVersion"):
            self.evaluate(c,{})
    def test_deterministic_codegen(self):
        c1,c2=self.compiler(),self.compiler()
        self.assertEqual(emit(c1,["credit"]),emit(c2,["credit"]))
        self.assertIn("def output_0 : Expr",emit(c1,["credit"])[0])

if __name__=="__main__":
    unittest.main()
