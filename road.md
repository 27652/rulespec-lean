# RuleSpecLean 项目规划

更新日期：2026-11-26

## 1. 项目目标

将 Axiom RuleSpec 编译产物转换为 Lean 4 表达式，在明确的支持范围内保持规则求值语义，并逐步建立编译正确性证明和法律语料验证体系。

近期目标是完成真实编译产物的标量规则验证；中长期目标包括十进制与舍入、实体关系、跨期计算、典型税务福利案例和语义保持证明。完整覆盖美国法律库不属于 v0.1 的交付范围。

## 2. 当前基线

| 项目 | 状态 | 验证依据 |
| --- | --- | --- |
| Artifact v3 子集转换 | 已实现 | Python 转换器、生成代码及清单 |
| 标量运算、三值逻辑、惰性分支 | 已实现 | Python 测试、Lean 断言 |
| 依赖分析、固定日期版本选择、参数表 | 已实现 | 示例转换及单元测试 |
| 精确 scale-6 数值子集 | 已实现 | 超出精度或范围时明确拒绝 |
| Python 测试基线 | 87 项通过 | 含固定种子公式对照、artifact 回归、绑定及 Decimal 编译检查 |
| Lean 4.26.0 基础构建 | 已通过 | 13 条断言、3 个定理 |
| 官方 Rust 编译与加载 | 已通过 | 上游模拟 flat-tax 示例的真实 v3 artifact |
| Rust / Python / Lean 对照 | 107 组通过 | 边界及固定种子随机输入 |
| 固定语料静态扫描 | 800 个模块编译成功，2,342 条规则实例正常转换 | 另有 734 条含缺失版本错误节点；分母和诊断见 `reports/corpus-static.json` |

上游引擎锁定提交：`a4322e45a035ba9fd412d01bebe078aeaa46cd54`。
flat-tax 为上游模拟规则，CTC-like 为本项目手工构造规则，均不构成完整法律案例。
Lean 已证明独立 scale-6 算术片段的降低保持值与求值错误；证明不涵盖 Python 转换器或 Rust 引擎。

## 3. 技术架构

```text
RuleSpec 源码
    │ 官方 Rust 编译器与 loader
    ▼
Compiled Artifact v3 + 官方 Explain 请求
    │ 固定日期版本选择、依赖分析、AST 降低
    ├── Python 解释器 ─────────┐
    └── Lean Expr → Lean 解释器 ├── 值、标签、错误优先级对照
        Rust Explain ────────┘
```

Decimal 编译器支持预绑定环境或单查询 Explain 请求，可读取最新覆盖记录、指定年度、数值读取点默认值及直接二元关系成员事实。通用实体与期间绑定仍待扩展。
Decimal 路径支持四种规则输出舍入；完整 Rust Decimal 表示、关系聚合及一般跨期计算尚未验收。

## 4. 里程碑与验收标准

| 阶段 | 目标 | 状态 | 验收标准 |
| --- | --- | --- | --- |
| M0 | 标量转换原型 | 已完成 | 转换器、解释器、确定性生成、Python 与 Lean 基础测试通过 |
| M1 | 真实 Artifact 端到端验证 | 本地通过，远端受阻 | 锁定源码和工具链；官方编译与加载；同输入 Rust/Python/Lean 对照；真实美国法律标量模块验证；错误优先级测试；CI 可复现 |
| M2 | Rust Decimal 与法定舍入 | 进行中 | 系数与精度、范围、溢出及舍入策略明确；随机与对抗输入对照通过 |
| M3 | 时间、实体及聚合 | 进行中 | 实体与期间绑定、默认值、跨期读取、关系过滤与聚合对照通过 |
| M4 | CTC、EITC、SNAP 案例 | 进行中 | 锁定法规版本、维护输入案例及预期结果、保留来源引用、完成三方验证 |
| M5 | 编译语义保持证明 | 进行中 | 独立源语义和目标语义、支持域定义、转换证明或证书检查、不含未证明占位 |
| M6 | 美国税务福利语料验证 | 本地测量已完成 | 固定语料快照；分别报告编译、转换、运行、对照覆盖率及明确分母；保留阻塞清单 |

M2–M4 可按依赖逐步扩展；M5 的源语义建模可提前开展。M6 的覆盖率结论依赖前置验证，不以静态转换成功率替代语义一致性。

## 5. 近期任务

### P0：巩固 M1 可复现基线

- [x] 锁定上游引擎提交并保存示例来源、许可和哈希。
- [x] 官方编译、加载模拟标量模块并完成 107 组三方结果对照。
- [x] 完成 Lean 基础构建及生成断言检查。
- [x] 将真实 artifact、案例、报告和生成 Lean 代码纳入离线回归，检查文件一致性。
- [x] 在 CI 中增加锁定 Rust 版本的真实编译与对照任务，保留日志（配置已完成，远端执行待验证）。
- [ ] 完善错误诊断、失败报告及非法请求测试。

对照脚本已检查空案例、重复名称、CLI 失败、非 Explain 回退、多余结果及输出键不匹配。
已完成 8 组 Rust/Python/Lean 错误对照，覆盖缺失输入、类型错误、除法错误优先级、公式版本缺失，以及缺失参数表版本时的索引求值和校验顺序。
错误诊断采用锁定引擎的完整文本模式，不将任意 CLI 失败映射为求值错误。更多错误类型、版本边界与请求绑定仍待扩展。

### P1：真实法律标量模块

- [x] 获取并锁定 `rulespec-us` 语料提交。
- [x] 选择依赖闭包最小、无实体关系和跨期计算的真实法律输出。
- [x] 记录法条、版本日期、输入绑定及不支持节点。
- [x] 完成至少 100 组边界与随机输入对照，单独报告真实法律案例结果。

P1 进展：已锁定 `rulespec-us` 提交 `d8a4c9cb560ed55c6db47ea36214249f67319461`，
选定 `us/statutes/26/3403.yaml`，完成 105 组官方 Rust/Python/Lean 对照。
源码、许可、哈希、案例及报告已保留；转换一致性不等于独立法律准确性审计。

M1 远端验收阻塞：GitHub SSH 认证返回 `Permission denied (publickey)`，环境未提供 GitHub CLI。
远端工作流需要具备仓库写权限的身份提交并触发；本地测试不能替代该验收项。

### P2：语义扩展准备

- [x] 建立 Decimal 与输出舍入行为矩阵（数值库级别 3,520 组三方检查；完整引擎集成待完成）。
- [ ] 整理默认值、版本边界、缺失输入与错误优先级规范。
- [ ] 定义 M2/M3 支持域及对应差分测试集。

M2 当前交付：独立 Python/Lean 系数-scale 模型、96 位范围和 0..28 位精度校验、四种输出舍入。Lean 定理验证成功舍入的结果 scale 为输入 scale 与目标位数的较小值，目标精度不低于有效输入的 scale 时保留原值。
数值 oracle 锁定 rust_decimal 1.41.0；边界和随机矩阵 3,520 组通过。
原规则解释器仍使用 scale-6 保守子集。独立 Decimal 路径完成 852 组算术三方对照及 17,200 组 Rust/Python 扩展对照，比较系数、scale 与错误。
官方 artifact 自动生成 Decimal Expr，完成 24 组四种规则舍入及依赖读取对照、7 组 `min`、`max`、`ceil`、`floor` 对照。
完成 6 组数值比较条件及 107 组上游模拟 flat-tax 的 Decimal 路径三方对照；后者涉及比较判断引用及版本化无索引参数。
另完成 11 组索引参数表对照，覆盖版本切换、i64 边界及索引错误。
确定型数值判断支持短路 `and`、`or`、`not` 和独立判断输出；Decimal 专用规则样例共 72 组三方对照通过，包含缺失公式版本、惰性求值和 96 位溢出边界。
零符号与 wire 表示逐字节等价不在当前支持域内。通用三值判断和全域语义证明仍未覆盖。
参考矩阵与待办见 `RuleSpecLean-v0.1/reports/decimal-semantics.md`。

M3 当前交付：请求可选择起始日期最新且覆盖整个目标期间的记录，并接受同一起始日的相同输入值。显式 `input_for_year` 已通过 6 组三方对照，包括目标年度缺失和冗余记录；冲突记录另经 Rust 与 Python 入口拒绝验证。数值 `input_or_else` 通过 3 组原始 ProgramSpec 对照。直接二元关系支持去重、期间过滤和成员本地谓词；无筛选计数通过 4 组、带筛选求和通过 5 组三方对照，含所选成员缺失输入及加法溢出。带筛选计数在 CTC 金额案例中验证。多查询执行、派生关系、嵌套聚合及一般跨期运行仍待开发。

M4 当前交付：CTC MAGI、递减额、预付款后金额及 §24(h)(5) 可退还上限分别完成 5、7、7、4 组三方对照；预付款后金额测试覆盖指定的基础及 §24(h) 路径。EITC 劳动所得在 §112 选择前完成 3 组，选择分支完成 2 组；SNAP 2024 财年净收入限额表完成 5 组。锁定引擎拒绝固定语料中完整 CTC §24(d)、EITC、SNAP 入口的传递依赖。临时副本中，移除旧版来源验证元数据后 CTC 与 EITC 可编译。SNAP §273.10 采用保留来源引用的兼容处理：将不受支持的旧版 `values` 字段原样存入报告，补齐 `member_of_household` 的 `Person`、`Household` 关系槽。编译成功后核验 4 个闭包模块及 32 条编译规则的引用；33 项 §273.10 公开输出期望及两项家庭成员判断通过三方对照。临时副本结果不计入固定语料验收。具体诊断见语料报告。

M5 当前交付：`ScalarPreservation.lean` 对 scale-6 字面量、预绑定数值输入、数值转换、四则运算、最大值、无匹配分支、十进制值参数表及带小于比较的惰性条件证明降低保持结果。参数表证明覆盖空表、索引错误、缺失键及数值边界。经证明的识别器校验 §3403 产物生成的 Lean 表达式与独立源项相符，对所有预绑定十进制环境保持值和错误。`VersionSelection.lean` 证明独立日期模型选出的版本有效且起始日最新，并刻画无可用版本的条件。`versioned_lowering_preserves_result` 证明降低前后按日期选中的公式求值一致，涵盖任意版本列表、公式求值错误及缺失版本。Artifact 日期解析、实际绑定及 Decimal 编译的端到端证明仍待完成。

M6 当前交付：固定语料扫描发现 2,304 个 YAML 文件，其中 1,152 个为案例文件。在 1,152 个编译候选中，800 个成功、352 个失败；3,099 条已编译规则实例中，2,342 条按快照正常转换、734 条转换后含缺失版本错误节点、23 条无法转换。33,954 项公开输出期望中，6,168 项通过三方对照（18.17%）；最新参数表版本支持新增 4 项，原有 6,164 项无一退回。各阶段分母及阻塞原因见 [语料验证报告](RuleSpecLean-v0.1/reports/corpus-validation.md)。

## 6. 验证与交付规范

外部项目参考：[Catala](https://github.com/CatalaLang/catala) 及其 [案例库](https://github.com/CatalaLang/catala-examples) 提供法规规则和可执行案例的组织范例；[PolicyEngine US](https://github.com/PolicyEngine/policyengine-us) 可用于设计独立税务福利案例，比较前需对齐法定年度、实体及输入定义；[Aeneas](https://github.com/AeneasVerif/aeneas) 可供评估将受限 Rust 函数连接至 Lean 规格的方案。当前验收仍以锁定 RuleSpec 引擎、语料和项目证明为准。

- Python 单元测试、独立公式测试、真实 Rust 差分、Lean 断言和定理证明分别报告。
- 使用 mock 的测试不计入真实引擎对照数量。
- 每个 artifact 保留源码提交、输入 SHA-256、快照日期、输出名称与规则来源。
- 下载镜像仅用于传输，工具链须与官方发布校验值一致；不提交工具链二进制。
- 不支持的节点或数值语义显式拒绝，不静默改写。
- 未经 CI 实际执行，不标记 CI 已通过；未完成真实法律案例，不声明法律准确率。

主要交付物位于 `RuleSpecLean-v0.1/`：`tools/`、`RuleSpecLean/`、`fixtures/`、`reports/`。
仓库级 CI 位于 `.github/workflows/ci.yml`。

## 7. 本地验证

```sh
cd RuleSpecLean-v0.1
python -m unittest discover -v
python tools/compile_ir.py fixtures/ctc-like.artifact.json --as-of 2025-01-01 --output credit
python -m tools.scan_artifacts fixtures --as-of 2025-01-01
lake build
lake build RuleSpecLean.ReferenceTests
```

重新运行真实上游对照：

```sh
python -m tools.prepare_reference --engine /path/to/axiom-rules-engine
python -m tools.check_reference fixtures/upstream-flat-tax.artifact.json \
  fixtures/upstream-flat-tax.cases.json --engine /path/to/axiom-rules-engine \
  --lake /path/to/lake
```

详细执行记录见 `RuleSpecLean-v0.1/reports/progress.md`；测试和对照结果以 `reports/` 中的最新文件为准。
