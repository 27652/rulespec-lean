# 固定语料验证

语料锁定至 `d8a4c9cb560ed55c6db47ea36214249f67319461`，引擎锁定至 `a4322e45a035ba9fd412d01bebe078aeaa46cd54`。静态快照日期为 2025-01-01。

| 阶段 | 分母 | 结果 |
| --- | ---: | --- |
| 文件盘点 | 2,304 个 YAML | 排除 1,152 个 `.test.yaml` 执行案例文件 |
| 官方编译 | 1,152 个候选模块 | 800 成功（69.44%）；352 失败 |
| scale-6 静态转换 | 3,099 个已编译规则实例（跨产物可能重复） | 2,342 正常转换（75.57%）；734 含缺失版本错误节点；23 不支持 |
| 官方 Explain 回放 | 1,152 个案例文件的 33,954 项输出期望 | 发起 6,375 次行级请求，6,369 次返回符合预期结构的响应 |
| Lean 执行与三方差分 | 6,369 项有效 Explain 响应 | 6,337 条行级断言通过，归入 6,164 项输出期望；32 项超出 scale-6 精确域 |

`corpus-static.json` 保留文件哈希、官方编译诊断、输出转换状态与原因。根目录必须为名为 `rulespec-us` 的真实目录。扫描器检查锁定引擎身份和 §3403 哈希，逐文件记录哈希；调用方负责提供锁定语料快照。

352 个编译失败模块中，249 个失败于普通编译，103 个失败于组合编译。按引擎首条失败诊断统计，335 个涉及 `corpus_citation_paths`，14 个涉及未知字段 `values`，2 个涉及关系元组缺少实体类型，1 个涉及文件名无法映射为规范模块名。支持 `no_match` 后，官方编译统计不变，静态转换阻塞从 55 个减少至 23 个：16 个 `count_related`、4 个 `sum_related` 和 3 个超出 scale-6 精确域的十进制字面量。解除阻塞的 32 个实例中，29 个正常转换、3 个仍含缺失版本节点。独立 Decimal 路径已另行验证部分关系聚合。

| 法律组件 | 官方 Rust Explain / Python / Lean | 完整入口状态 |
| --- | --- | --- |
| CTC §24 MAGI、递减额和预付款后金额 | 5、7、7 组，`ctc-magi.json`、`ctc-phaseout.json`、`ctc-after-advance.json` | §24 编译成功；验证范围包括指定的基础及 §24(h) 金额路径，未覆盖可退还抵免全链路 |
| CTC §24(h)(5) 可退还上限 | 4 组，`ctc-refundable-cap.json` | 覆盖空成员集、版本起始年、合格与不合格成员混合、纳税人缺少 SSN；完整 §24(d) 入口因传递依赖的 `corpus_citation_paths` 被锁定引擎拒绝 |
| EITC §32(c)(2) 劳动所得 | §112 选择前 3 组、选择分支 2 组，`eitc-earned-income.json`、`eitc-section112-election.json` | §32 的 IRS 参数依赖含锁定引擎已移除的 `corpus_citation_paths` |
| SNAP FY 2024 指定净收入限额 | 5 组，`snap-net-income-limit.json` | 7 CFR 273.10 的 USDA FY 2026 扣除额依赖含锁定引擎不接受的 `module.source_verification.values` |
| 26 USC §1211(b)(1) 资本损失限额 | 4 组，`capital-loss-match.json`；Decimal 与 scale-6 分别对照 | 覆盖两个匹配结果、无匹配分支及缺失输入；该条的公开用例另见 `corpus-replay-1211.json` |

组件用例验证固定源码及依赖下的输出，不估算全语料运行覆盖率，也不构成法律准确性审计。

锁定语料自身的 [引擎加载失败基线](https://github.com/TheAxiomFoundation/rulespec-us/blob/d8a4c9cb560ed55c6db47ea36214249f67319461/tools/known-engine-load-failures.txt) 也记录了 §24(d)、§32 和 7 CFR 273.10 的上述失败类别。该语料的 [工作流工具链](https://github.com/TheAxiomFoundation/rulespec-us/blob/d8a4c9cb560ed55c6db47ea36214249f67319461/.axiom/workflow-toolchain.toml) 使用另一引擎提交 `89571cc2a938707fd60a5489b951135345697296`。这三项已有上游记录，不能假定单独切换到语料工作流的引擎即可解决。

回放接收可绑定为单实体请求的公开标量与判断样例，包括实体类型匹配、无额外平铺输入的表格。表格按行独立发起请求，只有各行均通过才将该输出列表计为通过。26 USC §3121(a)(1) 的单行表格专项回放通过 20 项，见 `corpus-replay-3121-a1.json`；§3121(v) 的专项回放通过 32 项输出期望、40 条行级断言，见 `corpus-replay-3121-v.json`。多实体表格及未绑定的 oracle 上下文仍不纳入。对 YAML 中的数值期望比较数值，Rust、Python 与 Lean 之间仍比较类型标签和载荷。编译失败、非派生规则输出、超出支持域和对照不一致分开记账；覆盖率仅以公开案例的输出期望为分母。

未发起请求的输出期望中，26,951 项所属模块不可编译，328 项超出回放适配范围，473 项未对应派生输出。已发起的请求中，6 项因缺失公式版本被引擎拒绝。通过三方对照的 6,164 项占 33,954 项公开输出期望的 18.15%。单行表格适配新增 626 项，随后同一实体类型的多行表格适配新增 68 项，涉及 241 条行级断言。`corpus-replay.json` 和 `corpus-replay.log` 分别保留逐项结果与运行摘要。

CI 使用 `--baseline reports/corpus-replay.json --report reports/corpus-replay-ci.json`，按案例文件、案例序号和输出名检查已通过项是否退回。新增通过项不能抵消旧项丢失；基线与新报告必须使用相同语料、引擎身份及路径范围。单行表格回放保留此前的全部 5,470 项，多行表格回放保留全部 6,096 项；当前基线为 6,164 项。

回放校验 Explain 返回的实体、期间和输出标识。缺失公式版本仅在锁定引擎返回约定退出码和完整诊断时计为已知拒绝；其他非零退出和响应格式异常会使回放失败。§3131(h)、§1396a(xx) 和 §1396b(v) 的专项重跑复现了基线中的全部 6 项缺失版本拒绝。

强化 Explain 校验后的全量重跑曾逐字节复现 6,096 项单行表格基线。最新数字来自另一次全量回放，包含 §3121(v) 的多行结果。

scale-6 现可转换在快照日期没有有效版本的参数表读取，并保留索引错误优先级。26 USC §25D 专项回放通过 19 项公开输出期望，较修改前的全量报告在该模块新增 4 项，见 `corpus-replay-25D.json`。可用 `--prefix us/statutes/26/25D.yaml` 复现专项回放。26 USC §85 专项回放仍通过 3 项，其余 10 项需要 `sum_related`。

### 上游兼容性探针

在临时语料副本中，仅移除三个依赖的旧版 `module.source_verification` 块，保留公式、参数表和依赖边。锁定引擎随后成功编译 §24(d) 与 §32，分别生成含 71 和 61 个派生输出的 Artifact v3；7 CFR §273.10 则继续因 `member_of_household` 未声明关系槽实体类型而失败。探针会核对修改前后的文件哈希及成功编译产物的依赖闭包。该实验改变了来源验证元数据，只用于定位阻塞，不计入固定语料基线或法律验收。

复现：在项目子目录中安装 `PyYAML==6.0.3` 后运行 `python -m tools.probe_corpus_compat --engine "$ENGINE" --corpus "$CORPUS"`。实测见 [`corpus-compat-probe.log`](corpus-compat-probe.log)。

在项目子目录复现：

```sh
python -m tools.audit_corpus --engine /path/to/axiom-rules-engine \
  --corpus /path/to/rulespec-us --as-of 2025-01-01 --jobs 8 \
  --report /tmp/opencode/rulespec-static-recheck.json
python -m tools.check_legal_components --engine /path/to/axiom-rules-engine \
  --corpus /path/to/rulespec-us --lake /path/to/lake \
  --audit /tmp/opencode/rulespec-static-recheck.json
python -m pip install PyYAML==6.0.3
lake build RuleSpecLean.Core
python -m tools.replay_corpus --engine /path/to/axiom-rules-engine \
  --corpus /path/to/rulespec-us --lake /path/to/lake \
  --audit /tmp/opencode/rulespec-static-recheck.json \
  --baseline reports/corpus-replay.json --report /tmp/opencode/rulespec-replay-recheck.json
```
