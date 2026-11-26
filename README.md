# RuleSpecLean

RuleSpecLean 是一个研究原型：把受支持的 Axiom RuleSpec Artifact v3 转换为 Lean 4 表达式，并通过独立语义、保持性证明和锁定引擎实验验证转换。输入是由上游编译器产生的 Artifact；示例 `ctc-like` 为合成夹具。项目不提供完整法规执行或独立法律准确性结论。

| 层次 | 位置 |
| --- | --- |
| 规则转换与请求绑定 | [`tools/`](tools/)：Python 转换器、绑定器及对照解释器 |
| 形式化语义 | [`RuleSpecLean/Semantics/`](RuleSpecLean/Semantics/)：scale-6、Decimal 与版本选择 |
| 正确性证明 | [`RuleSpecLean/Proofs/`](RuleSpecLean/Proofs/)：保持性定理、§3403 对应性与公理审计 |
| 实验验证 | [`experiments/`](experiments/)、[`tests/`](tests/)、[`fixtures/`](fixtures/) 和 [`reports/v0.1/`](reports/v0.1/)；保留的生成模块与 Lean 断言位于 `RuleSpecLean/` |

**两条数值路径。** scale-6 将十进制限制为可精确表示的六位定点数，是标量转换与受限保持性证明的主要路径。Decimal 保留系数与 scale，覆盖更宽的十进制数值、舍入和部分请求绑定；其主要证据是差分实验，两条路径的支持域详见[使用说明](docs/usage.md)。

## 快速开始

安装 Python 3.12 与 Lean 4.26.0（由 [`lean-toolchain`](lean-toolchain) 指定），从仓库根目录运行：

```sh
python3 -m tools.compile_ir fixtures/ctc-like.artifact.json \
  --as-of 2025-01-01 --output credit
bash scripts/verify.sh offline
```

完整的锁定引擎实验见[复现指南](docs/reproduction.md)。[路线图](road.md)是当前状态、验收范围与阻塞的唯一入口；报告保存具体运行证据，开发历史见 [`docs/history/`](docs/history/)。
