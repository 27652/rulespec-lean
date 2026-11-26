# v0.1 研究基线证据

原始布局及当时的报告由 `archive/pre-research-layout` 标签保存。这里按实验类型归档固定证据，执行方法见[复现指南](../../docs/reproduction.md)，当前验收状态见[路线图](../../road.md)。

| 目录 | 内容 |
| --- | --- |
| [`interop/`](interop/) | flat-tax 模拟规则、真实 §3403 标量输出和求值错误的三方对照 |
| [`decimal/`](decimal/) | [比较口径](decimal/decimal-semantics.md)、舍入、算术及规则级 Decimal 差分 |
| [`binding/`](binding/) | 年度读取、默认值和直接关系聚合实验 |
| [`legal/`](legal/) | 选定法律组件及兼容产物的公开案例和诊断 |
| [`corpus/`](corpus/) | [固定语料静态扫描与回放](corpus/corpus-validation.md)、兼容补丁验证及[上游候选筛选](corpus/upstream-candidates.md) |
| [`proofs/`](proofs/) | 公理审计、§3403 生效边界及提取 Rust 函数差分 |
| [`logs/`](logs/) | 历史运行日志，保留生成时的路径与输出 |

编译、静态转换、公开输出回放和兼容补丁均使用各自的分母。三方结果一致及公理审计分别用于验证执行结果与 Lean 定理；两者均不构成独立法律审计。
