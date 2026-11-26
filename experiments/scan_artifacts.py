"""Audit supplied compiled JSON artifacts; does not fetch or compile RuleSpec."""
import argparse
from collections import Counter
import json
from pathlib import Path
if not __package__:
    # Also support direct invocation from a source checkout.
    import sys
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from tools.compile_ir import Compiler, Unsupported

def main():
    p=argparse.ArgumentParser()
    p.add_argument("directory",type=Path)
    p.add_argument("--as-of",required=True)
    p.add_argument("--report",type=Path,default=Path("reports/v0.1/corpus/coverage.json"))
    args=p.parse_args()
    if not args.directory.is_dir():
        p.error(f"not a directory: {args.directory}")
    rows=[]; blocked=Counter()
    for path in sorted(args.directory.rglob("*.json")):
        try:
            art=json.loads(path.read_text())
            if not isinstance(art,dict) or art.get("artifact_format_version")!=3:
                continue
            names=[r["name"] for r in art["program"].get("derived",[])]
        except (KeyError,ValueError,TypeError,OSError) as exc:
            rows.append({"file":str(path),"error":str(exc)})
            continue
        for name in names:
            try:
                c=Compiler(art,args.as_of); c.compile([name])
                rows.append({"file":str(path),"rule":name,"status":"lowered",
                             "closure_rules":len(c.normal)})
            except (Unsupported,KeyError,TypeError,ValueError,RecursionError) as exc:
                reason=str(exc)
                blocked[reason]+=1
                rows.append({"file":str(path),"rule":name,"status":"blocked","reason":reason})
    report={"as_of":args.as_of,
            "errors":sum("error" in r for r in rows),
            "meaning":"Static lowering only, not Lean compilation or legal coverage",
            "lowered":sum(r.get("status")=="lowered" for r in rows),
            "blocked":sum(r.get("status")=="blocked" for r in rows),
            "blockers":dict(blocked.most_common()),"results":rows}
    args.report.parent.mkdir(parents=True,exist_ok=True)
    args.report.write_text(json.dumps(report,indent=2,ensure_ascii=False)+"\n")
    print(f'Lowered: {report["lowered"]}; blocked: {report["blocked"]}')
if __name__=="__main__":
    main()
