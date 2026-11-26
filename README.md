# RuleSpecLean

项目依据 [`road.md`](road.md) 展开。原始 ZIP 保留，源码位于
[`RuleSpecLean-v0.1/`](RuleSpecLean-v0.1/README.md)。

```sh
cd RuleSpecLean-v0.1
python -m unittest discover -v
python tools/compile_ir.py fixtures/ctc-like.artifact.json --as-of 2025-01-01 --output credit
python -m tools.scan_artifacts fixtures --as-of 2025-01-01
lake build  # 需要 lean-toolchain 指定的 Lean 版本
```

这是受限标量规则研究原型，不是完整美国法律库，也不能用于实际报税或福利资格判断。
当前进度及验证边界见子目录 README 和 `reports/`。
