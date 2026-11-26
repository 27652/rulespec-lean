# 固定语料验证

语料锁定至 `d8a4c9cb560ed55c6db47ea36214249f67319461`，引擎锁定至 `a4322e45a035ba9fd412d01bebe078aeaa46cd54`。静态快照日期为 2025-01-01。

| 阶段 | 分母 | 结果 |
| --- | ---: | --- |
| 文件盘点 | 2,304 个 YAML | 排除 1,152 个 `.test.yaml` 执行案例文件 |
| 官方编译 | 1,152 个候选模块 | 800 成功（69.44%）；352 失败 |
| scale-6 静态转换 | 3,099 个已编译规则实例（跨产物可能重复） | 2,342 正常转换（75.57%）；734 含缺失版本错误节点；23 不支持 |
| 官方 Explain 回放 | 1,152 个案例文件的 33,954 项输出期望 | 发起 6,379 次行级请求，6,373 次返回符合预期结构的响应 |
| Lean 执行与三方差分 | 6,373 项有效 Explain 响应 | 6,341 条行级断言通过，归入 6,168 项输出期望；32 项超出 scale-6 精确域 |

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

未发起请求的输出期望中，26,951 项所属模块不可编译，324 项超出回放适配范围，473 项未对应派生输出。已发起的请求中，6 项因缺失公式版本被引擎拒绝。通过三方对照的 6,168 项占 33,954 项公开输出期望的 18.17%。单行表格适配新增 626 项，同一实体类型的多行表格适配新增 68 项，支持缺失参数表版本后新增 4 项。`corpus-replay.json` 和 `corpus-replay.log` 分别保留逐项结果与运行摘要。

CI 使用 `--baseline reports/corpus-replay.json --report reports/corpus-replay-ci.json`，按案例文件、案例序号和输出名检查已通过项是否退回。新增通过项不能抵消旧项丢失；基线与新报告必须使用相同语料、引擎身份及路径范围。最新回放保留既有的全部 6,164 项；当前基线为 6,168 项。

回放校验 Explain 返回的实体、期间和输出标识。缺失公式版本仅在锁定引擎返回约定退出码和完整诊断时计为已知拒绝；其他非零退出和响应格式异常会使回放失败。§3131(h)、§1396a(xx) 和 §1396b(v) 的专项重跑复现了基线中的全部 6 项缺失版本拒绝。

强化 Explain 校验后的全量重跑曾逐字节复现 6,096 项单行表格基线。最新数字来自另一次全量回放，包含 §3121(v) 的多行结果。

scale-6 现可转换在快照日期没有有效版本的参数表读取，并保留索引错误优先级。26 USC §25D 专项回放通过 19 项公开输出期望，较修改前的全量报告在该模块新增 4 项，见 `corpus-replay-25D.json`。可用 `--prefix us/statutes/26/25D.yaml` 复现专项回放。26 USC §85 专项回放仍通过 3 项，其余 10 项需要 `sum_related`。

### 上游兼容性探针

#### 可审查语料补丁与固定基线

[`corpus-compat.patch`](corpus-compat.patch) 可在锁定语料根目录使用 `git apply --check` 审查。补丁仅涉及四份 YAML：CTC/EITC 共用参数模块采用刊载金额的 IRS 原文第 15 页作为编译引用；两个 SNAP 参数模块保留来源路径并移出旧 `values` 字段；`member_of_household` 按现有 composition 声明补齐 `[Person, Household]`。分离的来源信息仍见下文对应的探针报告。补丁不修改公式、可执行参数表和公开案例。

| 完整入口 | 未修改语料的首条编译错误 | 补丁后派生输出 | 补丁后核验的闭包模块 | 补丁后三方回放通过的公开期望 |
| --- | --- | ---: | ---: | ---: |
| CTC §24(d) | 不支持复数 `corpus_citation_paths` | 71 | 11 | 4 |
| EITC §32 | 不支持复数 `corpus_citation_paths` | 61 | 10 | 2 |
| SNAP §273.10 | 不支持 `source_verification.values` | 17 | 4 | 33 |

[`corpus-patch-validation.json`](corpus-patch-validation.json) 保存原始编译诊断、补丁与文件哈希、实际补丁产物的闭包及八份回放报告的哈希。验证器只在临时副本应用补丁，随后直接回放该副本编译出的产物；三份 Artifact、八份回放报告和八份 Lean 源文件均与已提交证据逐字节一致。CTC 四项回放仅移除下文所述的两条闭包外输入。固定语料全量基线为 **6,168 / 33,954（18.17%）**，补丁上的 39 项期望单独统计。

CI 使用当次固定语料静态审计报告运行该验证器，逐字节核对并上传补丁验证报告。临时副本不包含 `.git`，以便 Git 检出目录与无版本控制元数据的源码导出目录使用相同的验证流程。

```sh
python -m tools.check_corpus_patch --engine "$ENGINE" --corpus "$CORPUS" \
  --lake "$(command -v lake)" --report /tmp/opencode/corpus-patch-validation.json
cmp /tmp/opencode/corpus-patch-validation.json reports/corpus-patch-validation.json
```

#### 单入口诊断与回放

CTC §24(d) 与 EITC §32 共用的 FY 2026 参数模块原有第 14、15 页两条来源路径。核对 [IRS Rev. Proc. 2025-32 原件](https://www.irs.gov/pub/irs-drop/rp-25-32.pdf) §3.06：第 14 页说明表格的适用口径，第 15 页刊载六组金额表和投资收入上限。临时迁移用第 15 页作为七个参数的单一编译引用，并逐项与固定语料中 `page-15.yaml` 的金额、起始日及证明引用对照。第 14 页上下文引用及包含旧值表的原始验证块随报告存档。两个入口在原始副本上均复现复数引用错误；迁移后分别生成 71 和 61 个派生输出，核验 11 和 10 个闭包模块及其闭包摘要，并逐项确认两份产物中的七个参数值与第 15 页引用。此项为来源迁移和编译验证，不是整条规则的执行或独立法律审计。

复现：`python -m tools.probe_corpus_compat --engine "$ENGINE" --corpus "$CORPUS" --eitc-report /tmp/opencode/eitc-citation-probe.json`。证据见 [`eitc-citation-probe.json`](eitc-citation-probe.json)。原件的下载 SHA-256 为 `e9ada115fb43a4af5ea326ca91edd40ab0bf29b9be01d2c13d7b8fa96214635b`；可用 `pdftotext -f 14 -l 15 -layout` 核对页码及内容。

在临时语料副本中，仅移除三个依赖的旧版 `module.source_verification` 块，保留公式、参数表和依赖边。锁定引擎随后成功编译 §24(d) 与 §32，分别生成含 71 和 61 个派生输出的 Artifact v3；7 CFR §273.10 则继续因 `member_of_household` 未声明关系槽实体类型而失败。探针会核对修改前后的文件哈希及成功编译产物的依赖闭包。该实验改变了来源验证元数据，只用于定位阻塞，不计入固定语料基线或法律验收。

EITC §32 公开案例 `one_child_phase_in_and_allowed` 在保留来源引用的兼容产物上查询最终抵免额 `eitc`。公开期望、Rust Explain、Python 与 Lean 均为 3,400 美元。案例包含一名子女，按编译后的 `[TaxUnit, Person]` 槽顺序绑定；所经求值路径未遇到不支持的节点。完整请求、Explain 响应与轨迹、绑定环境和产物来源闭包见 [`eitc-final-credit.json`](eitc-final-credit.json)。该结果仅覆盖此公开案例，不计入固定语料回放基线。

```sh
python -m tools.check_eitc_final --engine "$ENGINE" --corpus "$CORPUS" \
  --lake "$(command -v lake)" --report /tmp/opencode/eitc-final-credit.json \
  --lean /tmp/opencode/EITCFinalCreditTests.lean
```

同一保留引用的 §32 产物也用于 `investment_income_denies_credit`：公开期望、Rust Explain、Python 和 Lean 的最终抵免额均为 0 美元。Explain 轨迹确认 13,000 美元投资收入超过 12,200 美元上限，`eitc_investment_income_eligible` 和 `eitc_allowed` 均为 `not_holds`。本案例的绑定、求值和 Lean 转换未遇到不支持的节点。请求、响应和绑定环境见 [`eitc-investment-income-denial.json`](eitc-investment-income-denial.json)。

```sh
python -m tools.check_eitc_final --case investment_income_denies_credit \
  --engine "$ENGINE" --corpus "$CORPUS" --lake "$(command -v lake)" \
  --report /tmp/opencode/eitc-investment-income-denial.json \
  --lean /tmp/opencode/EITCInvestmentIncomeDenialTests.lean
```

CTC §24(d) 公开案例 `two_children_earned_income_phase_in_refundable_amount` 在保留来源引用的临时产物上回放最终输出 `refundable_ctc`。原始请求在 Rust 输入校验时被拒绝：§164(f) 的 `taxpayer_is_individual` 与 §1401 的 `filing_status` 均不在 §24(d) 产物的来源闭包和输入目录中。回放仅移除这两项（不重命名、不改变其他输入），随后 Rust Explain、Python、Lean 和公开期望均为 2,550 美元。通过的请求未遇到不支持的求值节点。[回放报告](ctc-refundable-credit.json)保留原始请求与拒绝诊断、移除的输入、实际请求与响应、绑定环境及 11 个闭包模块。

```sh
python -m tools.check_eitc_final --case two_children_earned_income_phase_in_refundable_amount \
  --engine "$ENGINE" --corpus "$CORPUS" --lake "$(command -v lake)" \
  --report /tmp/opencode/ctc-refundable-credit.json \
  --lean /tmp/opencode/CTCRefundableCreditTests.lean
```

三名子女案例 `three_children_social_security_excess_is_greater_than_earned_income_phase_in` 在同一兼容产物上得到 3,000 美元，符合公开期望，Rust Explain、Python 和 Lean 三方一致。Explain 轨迹与公开期望逐项核对：劳动收入递增额为 0，社会保障税超额为 3,000 美元，可退还限额增量取两者中的较大值 3,000 美元。原始请求的首个输入校验错误仍是 §164(f) 的 `taxpayer_is_individual`；仅移除上述两项闭包外输入后，未出现绑定或求值差异。完整证据见 [`ctc-social-security-excess.json`](ctc-social-security-excess.json)。

```sh
python -m tools.check_eitc_final \
  --case three_children_social_security_excess_is_greater_than_earned_income_phase_in \
  --engine "$ENGINE" --corpus "$CORPUS" --lake "$(command -v lake)" \
  --report /tmp/opencode/ctc-social-security-excess.json \
  --lean /tmp/opencode/CTCSocialSecurityExcessTests.lean
```

§24(d) 公开案例文件中的其余两个最终可退还抵免额期望也通过三方回放。§112 案例的 Explain 轨迹显示劳动收入基数为 5,000 美元、递增额为 300 美元，最终可退还抵免为 [300 美元](ctc-section112-refundable-credit.json)。§911 案例的境外收入资格判定为 `not_holds`，最终可退还抵免为 [0 美元](ctc-section911-refundable-credit.json)。至此，该文件的四项 `refundable_ctc` 期望均已回放；其他公开输出不计入该项覆盖率。

SNAP 的第二阶段探针以固定语料中 `state-plan-composition.yaml` 的声明为依据，在临时副本的 `us/statutes/7/2012/j.yaml` 中补入 `data_relation.arguments: [Person, Household]`。仅移除旧元数据时，锁定引擎以退出码 1 报告 `[untyped_relation]`；补入声明后，§273.10 以退出码 0 生成 Artifact v3，包含 17 个派生输出。产物中的 `slot_entities` 与语料声明顺序一致，4 个闭包模块均已按审计基线或临时修改后的 SHA-256 核对。这一结果仅验证编译准入，尚未验证完整 SNAP 执行。

复现：在项目子目录中安装 `PyYAML==6.0.3` 后运行 `python -m tools.probe_corpus_compat --engine "$ENGINE" --corpus "$CORPUS"`。实测见 [`corpus-compat-probe.log`](corpus-compat-probe.log)。同一命令附加 `--snap-report /tmp/opencode/snap-compat-probe.json` 可运行 SNAP 两阶段探针；诊断、声明出处、文件哈希与依赖闭包见 [`snap-compat-probe.json`](snap-compat-probe.json) 和 [`snap-compat-probe.log`](snap-compat-probe.log)。

保留来源验证的 SNAP 探针使用 `--retain-source-verification`：仅从两份 FY 2026 依赖中分离锁定引擎不接受的 `module.source_verification.values` 字段，在报告中逐字节保存原始 YAML 及其 SHA-256。模块的 `corpus_citation_path`、来源声明、规则证明元数据与可执行参数表均保留。补齐关系槽后，锁定引擎生成 17 个派生输出；探针核验 4 个闭包模块的 SHA-256，并逐项检查两个依赖的 32 条编译规则携带对应的原始来源路径。分离的旧版字段由报告保留，锁定引擎不读取它；该检查不替代对来源文本或法律含义的审计。

使用保留来源验证的 §273.10 Artifact，对其中导入的 7 USC §2012(j) 家庭成员判断回放了两项 2026 年 1 月公开案例。Rust Explain、Python 与 Lean 均得到相同结果：含一名符合条件的成员为 `holds`，无成员记录为 `not_holds`。Python 按 Household 槽 1 绑定 Person 槽 0 的成员，Lean 对生成的 Decimal 快照执行带筛选计数和比较。完整请求、Explain 响应及绑定环境见 [`snap-membership.json`](snap-membership.json)。此证据限于导入的成员判断，不计入固定语料回放基线。

```sh
python -m tools.check_snap_membership --retain-source-verification --engine "$ENGINE" --corpus "$CORPUS" \
  --lake "$(command -v lake)" --report /tmp/opencode/snap-membership.json \
  --lean /tmp/opencode/SNAPMembershipTests.lean
```

同一临时 Artifact 上，§273.10 公开案例文件中的 5 项 `snap_monthly_allotment` 均通过 Rust Explain、Python、Lean 与原始期望的数值对照，按原文顺序为 182、270、90、24、0 美元。请求、完整 Explain 响应和绑定环境见 [`snap-allotment.json`](snap-allotment.json)。

```sh
python -m tools.check_snap_membership --retain-source-verification --allotment --engine "$ENGINE" --corpus "$CORPUS" \
  --lake "$(command -v lake)" --report /tmp/opencode/snap-allotment.json \
  --lean /tmp/opencode/SNAPAllotmentTests.lean
```

其余 28 项公开输出期望也全部通过同一对照，其中 21 项为派生输出（包括净收入、扣除额和最低补助额），7 项为无索引参数（包括扣除率和起发金额）。回放适配器将这 7 项转换为所选月份的键 0 参数查找，直接复用 Python 和 Lean 的参数求值；期望中的十进制小数不经过浮点转换。未发现其他不支持的依赖或求值节点。逐项证据见 [`snap-other-outputs.json`](snap-other-outputs.json)。合计通过该文件全部 33 项输出期望；固定语料准入和独立法律审计仍是单独的验收项。

```sh
python -m tools.check_snap_membership --retain-source-verification --other-outputs --engine "$ENGINE" --corpus "$CORPUS" \
  --lake "$(command -v lake)" --report /tmp/opencode/snap-other-outputs.json \
  --lean /tmp/opencode/SNAPPublishedOutputsTests.lean
```

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
