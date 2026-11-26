# 转换与支持域

以下命令从仓库根目录运行。对于真实输入，先使用上游 RuleSpec 引擎编译及加载 Artifact v3；转换器不替代上游模式校验。`--output` 接受 Artifact 内部规则名。生成文件是固定日期的快照。

## Scale-6 标量路径

```sh
python3 -m tools.compile_ir /path/to/artifact.json \
  --as-of 2025-01-01 --output RULE_NAME \
  --lean RuleSpecLean/Example.lean --manifest .verification/example-manifest.json
lake build RuleSpecLean.Example
```

输入环境为一个实体、一个期间的预绑定槽值。支持无环引用闭包、整数和精确 scale-6 十进制、标量算术、惰性条件、受限判断和参数表。十进制系数的绝对值不得超过 `10^21`，所需中间值也必须可精确表示。输出舍入和关系聚合不属于此路径。

## Decimal 快照路径

```sh
python3 -m tools.compile_decimal /path/to/artifact.json \
  --as-of 2025-01-01 --output RULE_NAME --env /path/to/env.json \
  --lean RuleSpecLean/DecimalExample.lean
lake build RuleSpecLean.DecimalExample
```

可改用 `--request` 绑定受支持的单查询 Explain 请求。模型保留 96 位十进制系数及 0–28 的 scale，覆盖数值算术、四种输出舍入及部分比较判断。期间覆盖、显式年度读取与直接二元关系成员聚合有各自的子集和开关，见 `python3 -m tools.compile_decimal --help` 与 [Decimal 实验说明](../reports/v0.1/decimal/decimal-semantics.md)。通用绑定、任意关系或跨期语义、零符号和逐字节 wire 等价不在当前验证范围内。
