# 上游候选筛选

`git ls-remote` 返回的默认分支提交：引擎 [`a4322e45a035ba9fd412d01bebe078aeaa46cd54`](https://github.com/TheAxiomFoundation/axiom-rules-engine/commit/a4322e45a035ba9fd412d01bebe078aeaa46cd54) 与现有锁定一致；语料候选为 [`a5c5716ad45c477cf1587f371cc16f6a6f1a5c67`](https://github.com/TheAxiomFoundation/rulespec-us/commit/a5c5716ad45c477cf1587f371cc16f6a6f1a5c67)。用 GitHub Git Trees API 查询[语料基线](https://api.github.com/repos/TheAxiomFoundation/rulespec-us/git/trees/d8a4c9cb560ed55c6db47ea36214249f67319461)和[候选](https://api.github.com/repos/TheAxiomFoundation/rulespec-us/git/trees/a5c5716ad45c477cf1587f371cc16f6a6f1a5c67)的根树：

| 路径 | 基线树对象 | 候选树对象 |
| --- | --- | --- |
| `us/` | `2a17f6042ff5fc3d8219db01ad71b3acf5170ad8` | `2a17f6042ff5fc3d8219db01ad71b3acf5170ad8` |
| `.axiom/` | `3e48490c26eb767f3cfe1baa0579da41a0880cde` | `e00d86a3afe6c7dde5167c768ba2ffa15c6ab1e4` |

初次源码归档下载与浅检出均超时；以上是树对象比较结果。候选的联邦源码和案例目录与基线相同，直接更新语料锁定不提供三个联邦入口的源码修复。通过 GitHub Contents API 读取两个提交的 `.axiom/workflow-toolchain.toml`，确认二者的 `axiom_rules_engine_ref` 均为 `89571cc2a938707fd60a5489b951135345697296`，`axiom_artifact_rules_engine_ref` 均为 `98af0dcec5a09e1dca12d1458e08ccb02516c1ef`。这两个工作流锁定是额外的引擎候选，本次树比较不验证它们的编译行为，也不计入 39 项期望与跨快照回退验收。
