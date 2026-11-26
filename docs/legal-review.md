# 独立法律审阅材料

审阅范围为 CTC §24(d)、EITC §32 和 SNAP 7 CFR §273.10 的保留公开案例，另列 7 USC §2012(j) 的两项成员判断。请先按案例的 `request` 确认纳税年度或福利月份及实体，再依据该期间适用的原文独立计算，最后与公开期望及 `official_response`（Rust Explain）比较。已通过的三方差分是待审阅的执行证据。

| 路径 | 原文及版本核对 | 案例与执行证据 |
| --- | --- | --- |
| CTC | [26 USC §24](https://uscode.house.gov/view.xhtml?req=granuleid:USC-prelim-title26-section24&num=0&edition=prelim)；核对 §24(d) 与适用年度的 §24(h)，以及 §112、§911 对可退还部分的影响 | [两个子女的收入递增](../reports/v0.1/legal/ctc-refundable-credit.json)、[社保税差额](../reports/v0.1/legal/ctc-social-security-excess.json)、[§112](../reports/v0.1/legal/ctc-section112-refundable-credit.json)、[§911](../reports/v0.1/legal/ctc-section911-refundable-credit.json) |
| EITC | [26 USC §32](https://uscode.house.gov/view.xhtml?req=granuleid:USC-prelim-title26-section32&num=0&edition=prelim)；[IRS Rev. Proc. 2025-32](https://www.irs.gov/pub/irs-drop/rp-25-32.pdf) 第 14–15 页，核对适用年度、子女人数、申报身份、递增与递减参数及投资收入上限 | [一个子女的递增计算](../reports/v0.1/legal/eitc-final-credit.json)、[投资收入超限](../reports/v0.1/legal/eitc-investment-income-denial.json)、[七个参数的来源对应记录](../reports/v0.1/legal/eitc-citation-probe.json) |
| SNAP | [7 CFR §273.10](https://www.ecfr.gov/current/title-7/subtitle-B/chapter-II/subchapter-C/part-273/section-273.10)、[7 USC §2012](https://uscode.house.gov/view.xhtml?req=granuleid:USC-prelim-title7-section2012&num=0&edition=prelim)；核对适用月份、地区、[USDA 财年 COLA](https://www.fns.usda.gov/snap/allotment/cola)、扣除与舍入的应用顺序 | [5 项发放额](../reports/v0.1/legal/snap-allotment.json)、[28 项其他 §273.10 输出](../reports/v0.1/legal/snap-other-outputs.json)、[2 项家庭成员判断](../reports/v0.1/legal/snap-membership.json) |

链接可用于定位原文；审阅记录应注明实际采用的历史版本、生效区间和参数表页码。原始语料与引擎身份见[语料锁定清单](../fixtures/legal-pin.json)和[引擎锁定清单](../fixtures/upstream-pin.json)。三个完整入口的实验使用[临时兼容补丁](../reports/v0.1/corpus/corpus-compat.patch)，[补丁验证报告](../reports/v0.1/corpus/corpus-patch-validation.json)给出未打补丁时的诊断、修改文件的哈希和编译依赖闭包。审阅时请单独核对 EITC 引文迁移后第 14 页的上下文、SNAP 两份移出的旧版 `values` 证据，以及成员关系槽的 `Person` → `Household` 方向。

按案例与输出记录：原文版本和条款、输入及舍入过程、独立预期、保留输出、差异原因、审阅者与日期。CTC 社保税差额案还应核对报告中投影前后的请求，区分公式使用的事实与为适配当前绑定器而省略的闭包外输入。未获得足够事实或无可比输出的案例单列；审阅结论由独立审阅者给出。当前验收状态见[路线图](../road.md)。
