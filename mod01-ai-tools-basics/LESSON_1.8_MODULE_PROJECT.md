# Lesson 1.8: 模块实战 — AI工具链搭建

## 学习目标
1. 综合运用前面所学，搭建个人AI工作流
2. 从需求分析到产品上线的全流程实践
3. 产出：你的个人AI工作流文档

## 1. 实战项目概述

### 项目要求
选择一个你感兴趣的产品创意，用全套AI工具完成从0到1的开发。

### 推荐选题
- AI写作助手SaaS
- 个人知识库工具
- 电商选品分析工具
- SEO内容生成器
- AI客服机器人

### 我们的选题
**AI独立开发助手** — 帮助独立开发者快速验证创意的工具

## 2. 阶段一：需求分析 (20分钟)

### Prompt for ChatGPT:
`
你是一位资深产品经理。帮我分析"AI独立开发助手"的市场需求：

目标用户：独立开发者、自由职业者
核心痛点：想法多但执行慢、缺技术背景
需要功能：
1. 快速生成MVP原型
2. 自动写技术文档
3. 竞品分析
4. 用户反馈收集

请输出：
- 用户画像(3个)
- 核心需求优先级
- MVP功能清单
- 市场机会评估
`

### 预期输出
`
用户画像:
1. 技术型自由开发者 - 需要快速验证想法
2. 非技术创业者 - 需要低代码方案
3. 学生/转行者 - 需要学习+实践

MVP功能:
P0: 创意评估 + 技术栈推荐
P1: 一键生成项目脚手架
P2: 部署到Vercel/Netlify
`

## 3. 阶段二：原型设计 (30分钟)

### 用AI生成UI设计

**Prompt for Midjourney**:
`
A mobile app UI design for an AI startup assistant tool.
Screen 1: Dashboard with project cards
Screen 2: AI chat interface for brainstorming
Screen 3: Code generation preview
Style: Clean, modern, dark mode
Colors: Dark blue (#1E3A8A), accent cyan (#06B6D4)
Platform: iOS
Resolution: 1170x2532
`

### 用Figma AI生成组件

**Prompt for Figma AI**:
`
Create a design system for a SaaS product:
- Color palette (primary, secondary, neutral)
- Typography scale (H1-H6, body, caption)
- Button variants (primary, secondary, ghost)
- Card components (default, hover, active)
- Form elements (input, select, checkbox)
`

## 4. 阶段三：编码开发 (40分钟)

### 用Cursor生成项目

**Step 1: 初始化项目**
`
Prompt: "用Next.js 14 + TypeScript + Tailwind CSS创建一个
AI助手应用，包含以下页面：
1. Dashboard - 项目列表
2. New Project - 创建表单
3. Chat - AI对话界面
4. Settings - 用户设置

使用Prisma + PostgreSQL作为数据库。"
`

**Step 2: 生成API路由**
`
Prompt: "创建RESTful API:
- POST /api/projects - 创建项目
- GET /api/projects - 获取项目列表
- POST /api/ai/analyze - AI分析创意
- POST /api/ai/generate - AI生成代码

每个API需要JWT认证。"
`

**Step 3: 集成AI模型**
`
Prompt: "集成OpenAI API:
1. 创建AI服务层
2. 实现创意评估函数
3. 实现代码生成功能
4. 添加速率限制和错误处理

使用GPT-4 Turbo，temperature=0.7。"
`

## 5. 阶段四：内容生成 (20分钟)

### 生成产品文案

**Prompt for ChatGPT**:
`
为我的AI助手产品写一套营销文案：

1. Landing Page Hero (100字)
   - 标题: 突出价值主张
   - 副标题: 说明如何解决痛点
   - CTA: 行动号召

2. 功能描述 (每个50字)
   - 创意评估
   - 代码生成
   - 一键部署

3. FAQ (5个问题)
   - 适合什么人?
   - 需要编程基础吗?
   - 支持哪些语言?
   - 价格是多少?
   - 有免费试用吗?
`

### 生成社交媒体内容

**Prompt for Claude**:
`
为产品发布准备一周的社交媒体内容:

Day 1: 预告 - 即将发布
Day 2: 痛点 - 独立开发的挑战
Day 3: 解决方案 - 我们的产品
Day 4: 演示 - 功能展示
Day 5: 社会证明 - 早期用户评价
Day 6: 限时优惠 - 早鸟价
Day 7: 正式发布 - 立即体验

每个平台适配:
- Twitter: 140字以内
- LinkedIn: 300字专业版
- Instagram: 配图+短文案
`

## 6. 阶段五：部署上线 (20分钟)

### Vercel部署

**Step 1: 连接GitHub**
`
1. 推送代码到GitHub
2. Vercel导入项目
3. 自动检测Next.js
4. 配置环境变量
`

**Step 2: 配置自定义域名**
`
1. 在Vercel添加域名
2. 配置DNS CNAME记录
3. 等待SSL证书签发
4. 测试https访问
`

**Step 3: 性能优化**
`
1. 启用ISR (Incremental Static Regeneration)
2. 图片优化 (next/image)
3. 代码分割
4. CDN缓存
`

## 7. 产出物清单

### 必须完成
- [x] 产品需求文档 (PRD)
- [x] UI设计稿 (3个页面)
- [x] 可运行的代码
- [x] 营销文案
- [x] 部署链接

### 可选完成
- [ ] 社交媒体帖子 (7天)
- [ ] 产品演示视频
- [ ] 用户手册
- [ ] 数据分析仪表板

## 8. 项目复盘

### 用时统计
`
需求分析: 20分钟
原型设计: 30分钟
编码开发: 40分钟
内容生成: 20分钟
部署上线: 20分钟
总计: 130分钟 (约2小时)
`

### 工具使用
`
ChatGPT/Claude: 需求、文案、代码审查
Midjourney: UI设计参考
Cursor: 代码生成
n8n: 自动化流程
Vercel: 部署
`

### 关键收获
1. AI可以将产品开发时间从几周缩短到几天
2. 关键是知道如何给AI下正确的指令
3. 不要追求完美，先完成再优化
4. 每个环节都可以用AI加速

## 9. 作业

1. 独立完成一个完整项目（从创意到上线）
2. 记录每个步骤使用的Prompt
3. 计算相比传统开发节省的时间
4. 在下节课分享你的成果

## 关键要点
1. **AI是放大器** — 你的想法和价值判断依然最重要
2. **迭代优于完美** — 先上线再优化
3. **工具链要熟练** — 每个工具发挥最大价值
4. **文档化过程** — 方便复制和优化
