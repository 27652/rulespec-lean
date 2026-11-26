# 研究基线复现

从仓库根目录执行。运行结果与固定证据分开存放；验证脚本在临时项目副本中重生成上游夹具和 Lean 断言。

## 离线复验

使用 Python 3.12 与 Lean 4.26.0（`lean-toolchain`）。无需安装 Rust 引擎或下载语料。

```sh
bash scripts/verify.sh offline
```

入口运行 Python 单元及离线回归测试、核对确定性生成、构建 Lean 验证模块并检查公理审计。离线回放与 mock 不计作新的真实引擎执行。

## 锁定引擎实验

引擎与语料的仓库及提交见 [`upstream-pin.json`](../fixtures/upstream-pin.json) 与 [`legal-pin.json`](../fixtures/legal-pin.json)。语料检出目录命名为 `rulespec-us`。安装 Rust 1.98.1，使用各自的 `Cargo.lock` 构建引擎与数值 oracle。镜像下载的 Lean 工具链应核对官方 SHA-256。

```sh
export ENGINE_SOURCE=/path/to/axiom-rules-engine
export CORPUS=/path/to/rulespec-us
export ENGINE="$ENGINE_SOURCE/target/debug/axiom-rules-engine"
export ORACLE="$PWD/experiments/decimal_oracle/target/debug/rulespec-decimal-oracle"
export RUSTC="$(rustup which --toolchain 1.98.1 rustc)"
(cd "$ENGINE_SOURCE" && cargo +1.98.1 build --locked --bin axiom-rules-engine)
cargo +1.98.1 build --locked --manifest-path experiments/decimal_oracle/Cargo.toml
python3 -m pip install -r experiments/requirements.txt
bash scripts/verify.sh upstream
```

`PYTHON` 和 `LAKE` 可指定可执行文件。`EVIDENCE` 可指定结果目录，默认 `.verification/upstream/`；建议每次实验使用独立目录。该入口运行真实三方差分、锁定 Rust 源码差分、公理审计、固定语料静态扫描和回放，以及单列的兼容补丁实验。CI 使用相同入口并上传结果。[保留证据索引](../reports/v0.1/README.md)说明各类结果及其边界。
