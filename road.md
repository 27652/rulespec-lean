本轮将项目推进到 RuleSpecLean v0.1：标量规则转换原型，暂不尝试完整覆盖美国法律库。

已经确认上游 `ProgramSpec` 可以通过 JSON 获取规则及表达式，并具备明确的参考解释语义。条件分支、规则引用、数值类型和求值顺序都有可供实现的规范。

![](https://www.google.com/s2/favicons?domain=https://raw.githubusercontent.com\&sz=32)

GitHub+2

当前环境无法直接克隆 GitHub 仓库，也没有安装 Lean 和 Rust 工具链。因此，本阶段采用可实际运行的 Python 转换器生成 Lean AST，配套 Lean 解释器源码及测试工程；本地能运行的测试实际执行，Lean 编译验证则单独标记为待验证。

## 1. 项目源码

RuleSpecLean v0.1

Python 转换器 · Lean 4 运行时 · 测试 · CI16 个文件 · ZIP 源码工程

下载完整项目

README 与构建说明 

## 2. 实际测试结果

Python 单元测试通过

# 18 / 18

随机公式对照测试

# 10,000

全部一致

自动转换示例规则

# 7 / 7

待 Lean Kernel 检查的定理

# 3

随机测试使用独立编写的税额计算公式作为参照，不是与官方 Rust 引擎进行差分测试。输入使用模拟的 RuleSpec IR，而非官方编译器实际生成的产物。

## 3. 已实现的架构

Compiled Artifact v3

JSON intermediate representation

compile_ir.py

Version selection · Dependency analysis · AST lowering

![](data\:image/svg+xml;charset=utf-8,%3Csvg%20font-family%3D%22-apple-system-body%2C%20ui-sans-serif%2C%20-apple-system%2C%20system-ui%2C%20%26quot%3BSegoe%20UI%26quot%3B%2C%20Helvetica%2C%20%26quot%3BApple%20Color%20Emoji%26quot%3B%2C%20Arial%2C%20sans-serif%2C%20%26quot%3BSegoe%20UI%20Emoji%26quot%3B%2C%20%26quot%3BSegoe%20UI%20Symbol%26quot%3B%22%20font-weight%3D%22400%22%20data-d-component%3D%22svg%22%20fill%3D%22currentColor%22%20height%3D%2228%22%20style%3D%22color%3Argb\(13%2C%2013%2C%2013\)%22%20viewBox%3D%220%200%20320%2028%22%20width%3D%22100%25%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Cpath%20d%3D%22M160%200%20V10%20H80%20V25%20M160%2010%20H240%20V25%22%20fill%3D%22none%22%20stroke%3D%22currentColor%22%20stroke-width%3D%221.4%22%2F%3E%3Cpath%20d%3D%22M75%2020%20L80%2025%20L85%2020%20M235%2020%20L240%2025%20L245%2020%22%20fill%3D%22none%22%20stroke%3D%22currentColor%22%2F%3E%3C%2Fsvg%3E)

Python Evaluator

Tests passed

Generated.lean

Lean Interpreter

Build pending

## 4. 项目目录

```
RuleSpecLean-v0.1/
├── RuleSpecLean/
│   ├── Core.lean
│   ├── Generated.lean
│   └── Tests.lean
├── tools/
│   ├── compile_ir.py
│   ├── scan_artifacts.py
│   └── test_prototype.py
├── fixtures/
│   └── ctc-like.artifact.json
├── reports/
│   ├── coverage.json
│   └── python-test.log
├── .github/workflows/ci.yml
├── generated-manifest.json
├── RuleSpecLean.lean
├── lakefile.toml
├── lean-toolchain
└── README.md
```

其中 `scan_artifacts.py` 用于后续扫描 Axiom 的真实法律编译产物，统计转换成功率及不支持的语法节点。

## 5. 当前支持范围

|
功能

|

状态

|
| --- | --- |
|

Artifact v3 子集解析

|

已实现

|
|

AST 到 Lean 代码生成

|

已实现

|
|

基础算术运算

|

已实现

|
|

三值逻辑

|

已实现

|
|

惰性条件求值

|

已实现

|
|

规则依赖分析

|

已实现

|
|

固定日期的法律版本选择

|

已实现

|
|

参数表查询

|

已实现

|
|

精确十进制数子集

|

已实现

|
|

完整 Rust Decimal 语义

|

待实现

|
|

家庭及实体关系

|

待实现

|
|

跨期计算

|

待实现

|
|

编译器语义保持证明

|

待实现

|

## 6. 本地复现

解压后执行：

Bash

```
cd RuleSpecLean-v0.1

python -m unittest -v tools.test_prototype
```

生成 Lean 代码：

Bash

```
python tools/compile_ir.py \
  fixtures/ctc-like.artifact.json \
  --as-of 2025-01-01 \
  --output credit
```

安装 Lean 工具链后：

Bash

```
lake build
```

## 7. 下一阶段开发任务

M0

标量规则转换原型

原型完成

M1

真实 Axiom Artifact 端到端转换

待完成

M2

Rust Decimal 与法定舍入语义

待完成

M3

时间、实体关系及聚合计算

待完成

M4

完整 CTC、EITC、SNAP 案例

待完成

M5

语义保持编译证明

待完成

M6

美国税务福利语料批量验证

待完成

下一项关键任务是 M1：获取真实 Axiom 编译产物，并使 Rust Explain 与 Lean 在同一组输入下产生一致结果。 只有通过这一关，才能开始有依据地评估全语料转换覆盖率。

当前交付物是已经运行 Python 测试的研究原型，不是已经经过 Lean Kernel 验证的正式编译器。
