# 上游候选筛选

`git ls-remote` 返回的默认分支提交：引擎 [`a4322e45a035ba9fd412d01bebe078aeaa46cd54`](https://github.com/TheAxiomFoundation/axiom-rules-engine/commit/a4322e45a035ba9fd412d01bebe078aeaa46cd54) 与现有锁定一致；语料候选为 [`a5c5716ad45c477cf1587f371cc16f6a6f1a5c67`](https://github.com/TheAxiomFoundation/rulespec-us/commit/a5c5716ad45c477cf1587f371cc16f6a6f1a5c67)。用 GitHub Git Trees API 查询[语料基线](https://api.github.com/repos/TheAxiomFoundation/rulespec-us/git/trees/d8a4c9cb560ed55c6db47ea36214249f67319461)和[候选](https://api.github.com/repos/TheAxiomFoundation/rulespec-us/git/trees/a5c5716ad45c477cf1587f371cc16f6a6f1a5c67)的根树：

| 路径 | 基线树对象 | 候选树对象 |
| --- | --- | --- |
| `us/` | `2a17f6042ff5fc3d8219db01ad71b3acf5170ad8` | `2a17f6042ff5fc3d8219db01ad71b3acf5170ad8` |
| `.axiom/` | `3e48490c26eb767f3cfe1baa0579da41a0880cde` | `e00d86a3afe6c7dde5167c768ba2ffa15c6ab1e4` |

两个语料提交的 `axiom_rules_engine_ref` 均为 `89571cc2a938707fd60a5489b951135345697296`，`axiom_artifact_rules_engine_ref` 均为 `98af0dcec5a09e1dca12d1458e08ccb02516c1ef`。候选语料从 GitHub 按提交下载的源码归档解压，归档 SHA-256 为 `06a38b62d8c2fef927d5e1db08490a906d96295933f9095368d9cf713af6aed8`。

## 无补丁编译实测

| 引擎与语料 | CTC §24(d) | EITC §32 | SNAP §273.10 |
| --- | --- | --- | --- |
| 现有引擎 `a4322e4` + 候选语料 `a5c5716` | 退出 1：`corpus_citation_paths` | 退出 1：`corpus_citation_paths` | 退出 1：`module.source_verification: unknown field values` |
| 工作流引擎 `89571cc`（0.2.2）+ 固定语料 `d8a4c9c` | 退出 1：`corpus_citation_paths` | 退出 1：`corpus_citation_paths` | 退出 1：`module.source_verification: unknown field values` |
| 产物工作流引擎 `98af0dc`（0.1.2）+ 固定语料 `d8a4c9c` | 退出 0：v2，71 个派生输出 | 退出 0：v2，61 个派生输出 | 退出 0：v2，17 个派生输出 |

两种工作流引擎均从 GitHub 提交源码归档用 `cargo build --locked --bin axiom-rules-engine` 构建。0.2.2 和现有引擎使用 `compile --program "$CORPUS/$entry" --rulespec-root "$CORPUS" --output "$output"`。0.1.2 使用 `AXIOM_RULESPEC_REPO_ROOTS="$CORPUS" "$ENGINE" compile --program "$CORPUS/$entry" --output "$output"`；其 CLI 不接受 `--rulespec-root`，也不提供 `capabilities` 或 `explain`。

0.1.2 的 v2 产物 SHA-256：CTC `b103ef7e7d5f1b2760c819dba2434ac39085a4d9941267f6d8be6748e1b43589`；EITC `2e809a0e4974e543a3041c0c8637bc0e77e62d6db03e134bd7cd2a7e2c1b769f`；SNAP `bba7aed3827ac985116c5282f177dc54b1266131215b56b1c20eab49ecd82173`。已实测两条转换路径均拒绝全部三个 v2 产物（`only artifact format 3` / `artifact v3 required`）。本轮没有用旧引擎执行 39 项公开期望或全语料回退验证，因此不更新锁定版本。
