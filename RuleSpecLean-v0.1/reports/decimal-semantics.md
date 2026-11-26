# M2 Decimal 参考语义与验收矩阵

## 参考版本

- Axiom engine: `a4322e45a035ba9fd412d01bebe078aeaa46cd54`。
- engine Cargo.lock: rust_decimal `1.41.0`。
- 独立数值 oracle 使用精确依赖版本并提交 Cargo.lock。
- 上游 `src/model.rs::RoundingMode::round_decimal` 调用 `round_dp_with_strategy`。

## 已实现范围

Python `tools/decimal_model.py` 与 Lean `RuleSpecLean/Decimal.lean` 独立实现：

- 系数绝对值不超过 `2^96 - 1`，scale 为 0..28。
- 精确普通十进制文本解析（Python）；超出支持范围拒绝。
- 舍入位数 0..28；不增加原有小数位数。
- 不依赖二进制浮点数完成舍入。

| RuleSpec 模式 | Rust 策略 | 中点/方向 | 负数示例（2 位） |
| --- | --- | --- | --- |
| half_up | MidpointAwayFromZero | 中点远离零 | -1.225 → -1.23 |
| half_even | MidpointNearestEven | 中点取偶数 | -1.225 → -1.22 |
| floor | ToNegativeInfinity | 向负无穷 | -1.221 → -1.23 |
| ceil | ToPositiveInfinity | 向正无穷 | -1.229 → -1.22 |

差分矩阵包含正负中点、零、保留小数位、28 位精度、96 位系数边界及固定种子随机系数。
对照比较系数与 scale，而非仅比较格式化文本。

## 算术与规则验证

Python/Lean 新增加减乘除实验性数值模型：对齐 scale、有限精度除法、
精度收缩时的 midpoint-to-even、除零及溢出。除法按至多九位一组扩展商，
并按锁定库的规则移除尾零；加减及乘法保留相应的零值快速路径。
852 组 Rust/Python/Lean 逐项比较有符号系数、scale 与错误，见 `decimal-arithmetic.json`。
另有 17,200 组 Rust/Python 全范围采样与边界对照通过，见 `decimal-arithmetic-extended.log`。
两套矩阵均不比较零的符号，也不构成全域等价证明。

独立数值规则解释器与 Lean Decimal Expr 验证了规则依赖舍入：
1.005 先舍入为 1.01，再乘 2 得 2.02。见 `decimal-dependency.json`。
依赖测试现由 `tools.compile_decimal.DecimalCompiler` 从官方 artifact 自动生成，
覆盖 half_up、half_even、floor、ceil 四种规则舍入，共 24 组官方 Rust/Python/Lean 对照通过。
生成顺序为依赖优先，舍入节点保留在依赖定义内部；预绑定输入经请求绑定校验后嵌入 Expr。
支持数值字面量、输入、引用、加减乘除及 `min`、`max`、`ceil`、`floor`。
7 组官方引擎内置函数对照包含负数、截断边界和 28 位小数输入。极值平局保留第一个值；
请求绑定复用原有的实体与期间检查，数值验证由对应运行时提供。其他节点显式拒绝。
6 组数值比较条件官方对照覆盖 28 位精度阈值、不同 scale 的相等值及未选分支的除零跳过。
Decimal 路径支持比较判断引用及版本化数值参数表。上游模拟 flat-tax 的 107 组官方引擎、
Python 和自动生成 Lean 对照通过，见 `decimal-flat-tax.json`。规则层成功结果比较数值。
11 组索引参数表对照覆盖带小数位但数值为整数的键、i64 两端、版本切换、缺失版本或键、
非整数及越界键。错误用锁定 CLI 的完整诊断匹配，见 `decimal-dependency.json`。
确定型数值判断支持短路 `and`、`or`、`not`；另验证 6 组复合条件和 4 组判断输出。
直接布尔输入及字面量支持相等和不相等比较；CTC 递减额及预付款后金额对照覆盖此路径。缺失布尔输入在实际读取时产生错误。
缺失输入测试覆盖直接读取、除零优先和跳过未选分支。2 组覆盖记录对照验证输入顺序无关。
新增编译器回归覆盖循环、缺失版本/输入、货币精度、生成顺序和生成文件一致性。
请求模式把缺失公式版本降低为求值错误。4 组官方对照覆盖标量、判断、依赖和惰性分支。
5 组新增数值边界对照覆盖 28 位负零输入、负数舍入到零和乘法的 96 位上界。
26 USC §1211 的数值 `match` 另有 4 组案例，分别在 Decimal 和 scale-6 路径完成三方对照：两个命中结果、无匹配分支、读取主体时的缺失输入。后两组核对完整 CLI 诊断及求值错误优先级，见 `capital-loss-match.json`。Lean 定理 `RuleSpecLean.eval_noMatch` 证明 scale-6 节点保留主体求值错误；`lowering_preserves_result` 将该结论扩展到独立源语义的数值主体片段。

## 比较契约

- 输入支持普通十进制字符串以及精确整数；拒绝 JSON 浮点数、科学计数法、超出 96 位系数或 28 位 scale 的值。
- 库级差分比较系数、scale 和错误；规则级差分比较数值或确定型判断，指定失败比较完整 CLI 诊断及 Python/Lean 错误标签。
- Python/Lean 将负零和正零视为同一数值。报告保留 Rust 原始标量文本作为观察值，不要求保留零符号、尾零或 wire 格式。

## 待完成范围

- 继续检查算术边界并证明已支持语义。
- 扩展至可返回 `undetermined` 的判断；原 scale-6 路径仍可独立使用。
- 完整数值支持域与语义保持证明。

M2 尚未完成；数值库差分不是完整编译正确性证明。
