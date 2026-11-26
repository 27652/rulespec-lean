# §3403 Rust 源码验证：工具与范围

本轮为源码路径与工具的初步评估。锁定引擎为 `a4322e45a035ba9fd412d01bebe078aeaa46cd54`；源码位置及哈希见[已执行的差分报告](legal-3403-rust-source.json)。本机未找到 Charon、Aeneas、Kani 或 Verus 可执行文件，因此尚无这些工具的翻译或证明结果。

| 源码入口 | 应验证的行为与依赖 |
| --- | --- |
| `model.rs` 的 `Derived::semantics_at`、`Derived::version_at` | 空版本表使用默认语义；非空表按查询 `period.start` 选择适用版本。一般情形还须证明迭代器选择最大起始日、同日起始的最后项优先。优先尝试单版本子集，保留实际函数体；对 `chrono::NaiveDate` 的顺序如需规格替代，应列为显式假设。 |
| `engine.rs` 的 `Engine::lookup_input` | `(槽名, 实体名)` 索引、期间覆盖、同日起始冲突、结果或错误。单记录情形可先以索引构造正确为前提，之后证明前提来自 `Engine::new`；一般情形还依赖 `HashMap`、迭代器、值比较和 `ScalarValue` 克隆。 |

[Charon + Aeneas](https://github.com/AeneasVerif/aeneas) 将 Rust MIR 翻译为 Lean 可用的定义，可作为连接既有保持性定理的首选试验。需锁定 Aeneas、其 `charon-pin` 与工具链，并记录生成物和依赖模型；若仅能翻译替换日期或容器的提取版本，应区分对提取版本的证明与对生产类型行为的假设。[Kani](https://github.com/model-checking/kani) 可作为原 Rust 的有界性质检查候选，须单列输入及展开边界；有界检查不直接产生 Lean 对应性定理。

首个验收目标是：从锁定源码机械提取或翻译实际版本选择函数，在单版本、已解码日期的前提下证明其结果对应 `versionBody`，再让公理审计覆盖该定理。现有 36 项查找与 9 项版本选择差分可作回归检查；当前的 Lean 定理覆盖手工转写。正式验收状态见[路线图](../../../road.md)。
