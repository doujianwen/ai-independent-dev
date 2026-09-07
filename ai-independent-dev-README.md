# AI 独立开发实战课

> 从 AI 工具到上线变现 —— 一个人的 AI 独立开发完整路径

本仓库是「AI 独立开发实战课」的完整课程资料库 + 配套的**纠错智能体（Correction Agent）系统**。覆盖从工具上手、AI 辅助开发、建站部署、SEO 增长到商业变现的完整链路，并通过纯纠错型智能体在关键节点上对方案进行一票否决式审查，确保项目决策质量。

## ✨ 这个仓库包含什么

1. **六大模块课程内容**（48 课时，约 36 小时）—— 每课均为可直接阅读/教学的 Markdown 讲义
2. **纠错智能体系统**（`correction-agent/`）—— 纯挑刺、不写方案的审查体系，含 Prompt 模板、各阶段审查清单与日志归档
3. **运营与规划文档** —— 课程开发报告、执行计划、营销方案、支付风险分析等一手文档

## 🎯 适合谁

- 想用 AI 独立做出产品并变现的 **Solo Founder**
- 希望提升 AI 工作效率的**自由职业者**
- 想转型 AI 方向的**职场人 / 转行者**

## 📚 课程模块总览

| 模块 | 主题 | 课时 | 学习目标 |
|------|------|------|----------|
| Mod 01 | AI 工具基础 | 8 | 掌握主流 AI 工具，建立 AI 工作流思维 |
| Mod 02 | AI 辅助开发 | 8 | 用 AI 做出 Web 应用、小程序、浏览器插件 |
| Mod 03 | 网站搭建 | 8 | 从零搭建 SEO 友好站点并部署上线 |
| Mod 04 | SEO 营销 | 8 | 内容策略 + 技术 SEO，获取自然流量 |
| Mod 05 | 变现策略 | 8 | 课程/模板/SaaS/联盟营销多种收入路径 |
| Mod 06 | 案例拆解 | 8 | 完整项目复盘：从想法到上线 |

## 🗂️ 目录结构

```
ai-independent-dev/
├── mod01-ai-tools-basics/       # 模块1：AI 工具基础（工具地图、提示词、AI 编程/设计/自动化…）
├── mod02-ai-development/        # 模块2：AI 辅助开发
├── mod03-website-build/         # 模块3：网站搭建与部署
├── mod04-seo-marketing/         # 模块4：SEO 营销
├── mod05-monetization/          # 模块5：变现策略
├── mod06-case-studies/          # 模块6：案例拆解
├── correction-agent/            # 纠错智能体系统（见下文）
│   ├── templates/               #   纠察组 Prompt 模板 + 审查日志模板
│   ├── checklists/              #   Phase 0~3 各阶段审查清单
│   └── logs/                    #   审查日志归档（按日期命名）
├── templates/                   # 通用模板
├── COURSE_OVERVIEW.md           # 课程总览（模块/课时/目标一览）
├── LEARNING_PATHS.md            # 学习路径建议（按人群定制）
├── COURSE_DEVELOPMENT_REPORT.md # 课程开发报告
├── COURSE_IMPROVEMENT_PLAN.md   # 课程迭代计划
├── EXECUTION_PLAN_V5.md         # 执行计划 V5
├── OPERATIONS_AND_MARKETING_PLAN*.md  # 运营与营销方案
├── AFFILIATE_RESEARCH_CHECKLIST.md    # 联盟营销调研清单
├── PLATFORM_SETUP_PLAN.md       # 平台搭建方案
├── CHEAP_PLATFORM_PLAN.md       # 低成本平台方案
├── PAYMENT_RISK_ANALYSIS.md     # 支付风险分析
├── MARKETING_POSTER.md          # 营销海报文案
└── FINAL_REPORT.md              # 项目总结报告
```

每个模块目录内含：`MOD0X_OVERVIEW.md`（模块总览）+ `LESSON_X.Y_*.md`（单课讲义）+ `LESSON_X.Y_MODULE_PROJECT.md`（模块实战项目）。

## 🛡️ 纠错智能体系统（Correction Agent）

课程项目配套的**纯纠错型智能体**体系，核心设计：

| 原则 | 说明 |
|------|------|
| **角色固化** | 纠察组只负责"找出所有漏洞"，不参与方案构建 |
| **信息隔离** | 纠察组不知道哪个方案最被看好，避免立场污染 |
| **攻击权 > 产出** | 质疑一旦成立，方案作废、路径标记「堵死」——一票否决 |

**使用流程**：在 Phase 0（需求验证）→ Phase 1（MVP）→ Phase 2（营销转化）→ Phase 3（规模化）每个节点结束时，由 2~3 名独立纠察组成员（COR-01~03）各自独立填写审查清单，汇总为 ✓通过 / ⚠️有条件通过 / ✗堵死 三种结论，并归档到 `logs/`。

**人工兜底（HITL）**：纠察组结论仅作参考，最终决策权在人。结论不一致、标记"堵死"但想冒险、漏洞无法量化时，触发人工介入。

详见 [`correction-agent/README.md`](./correction-agent/README.md)。

## 🚀 如何使用本仓库

1. **按模块顺序学习**：从 `mod01-ai-tools-basics/MOD01_OVERVIEW.md` 开始，每模块先看总览，再逐课阅读，最后完成模块实战项目
2. **不确定学什么**：先看 [`LEARNING_PATHS.md`](./LEARNING_PATHS.md)，按自己的人群画像选路径
3. **做自己的项目时**：在关键决策节点套用 `correction-agent/` 的模板做纠错审查
4. **想复刻这套课**：参考 `COURSE_DEVELOPMENT_REPORT.md` 与 `EXECUTION_PLAN_V5.md` 的完整开发过程

## 📄 许可与说明

本仓库内容仅用于学习交流。转载请注明出处。

---

*最后更新：2026-07-19*
