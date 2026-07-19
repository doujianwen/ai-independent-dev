# Lesson 1.6: AI自动化工作流

## 学习目标
1. 掌握n8n/Make/Zapier等自动化工具
2. 学会构建内容生产自动化流水线
3. 实战：搭建"每日AI新闻简报"自动化工具

## 1. 自动化工具对比

### n8n (推荐)
- **价格**: 免费(self-host) / \/月(cloud)
- **优势**: 开源，节点丰富，自托管隐私好
- **适合**: 技术用户，复杂工作流

### Make (原Integromat)
- **价格**: 免费限额 / \/月起
- **优势**: 可视化强，模板多
- **适合**: 非技术人员，快速搭建

### Zapier
- **价格**: \/月起
- **优势**: 集成最多(6000+)
- **适合**: 简单场景，企业级支持

## 2. 自动化工作流设计原则

### 识别可自动化场景
`
高频重复任务 -> 自动化
多步骤流程 -> 自动化
数据搬运 -> 自动化
定时报告 -> 自动化
`

### 设计工作流
`
1. 触发器 (Trigger)
   - 定时 (每天9点)
   - 事件 (新邮件到达)
   - Webhook (API调用)

2. 处理 (Process)
   - 数据清洗
   - AI生成内容
   - 条件判断

3. 输出 (Output)
   - 发送邮件
   - 发布到社交平台
   - 写入数据库
`

## 3. 实战：每日AI新闻简报

### 工作流设计

**触发器**: 每天上午9点

**步骤**:
`
1. 抓取AI行业新闻
   - RSS源: TechCrunch AI, VentureBeat AI
   - Twitter/X: #AI, #MachineLearning
   - Reddit: r/artificial, r/MachineLearning

2. AI整理和摘要
   - 去重
   - 分类(工具/研究/融资/产品)
   - 生成摘要(每篇50字)
   - 评分(相关性1-5)

3. 生成简报
   - 标题: "AI日报 - 2026-07-16"
   - 结构: 头条 + 分类列表 + 工具推荐
   - 格式: Markdown + HTML

4. 分发
   - 邮件发送给订阅者
   - 发布到Twitter
   - 存入Notion数据库
`

### n8n工作流配置

**节点1: Cron Trigger**
`
Schedule: Every day at 9:00 AM
Timezone: Asia/Shanghai
`

**节点2: HTTP Request (RSS)**
`
Method: GET
URL: https://techcrunch.com/category/artificial-intelligence/feed/
Parse: XML to JSON
`

**节点3: AI Summarization (OpenAI)**
`
Prompt: |
  请总结以下AI新闻文章，每篇不超过50字。
  分类为: 工具/研究/融资/产品
  评分重要性(1-5)
  
  文章列表: {{ .articles }}
  
Output: JSON格式
`

**节点4: Filter (Top 10)**
`
Condition: score >= 4
Limit: 10 items
Sort: by score desc
`

**节点5: Email Generator**
`
Template: HTML newsletter
Variables: date, headline, articles, tool_recommendation
`

**节点6: Send Email (SMTP)**
`
To: subscribers@yourdomain.com
Subject: AI日报 - {{ .date }}
Content: {{ .html }}
`

## 4. 自动化内容生产流水线

### 场景：博客文章自动生成

**工作流**:
`
1. 关键词研究 (手动/AI)
   -> 输入: 5个目标关键词

2. 大纲生成 (ChatGPT)
   -> 输入: 关键词
   -> 输出: 文章结构

3. 内容撰写 (Claude/Claude)
   -> 输入: 大纲 + 参考资料
   -> 输出: 初稿

4. SEO优化 (AI)
   -> 检查: 关键词密度, Meta标签, 内部链接
   -> 输出: 优化建议

5. 图片生成 (Midjourney)
   -> 输入: 文章主题
   -> 输出: 配图

6. 发布 (WordPress API)
   -> 输入: 完整文章
   -> 输出: 已发布
`

### Make.com模板

**模块1: Schedule**
- 每天10:00触发

**模块2: AI Writer**
- 使用Claude API
- 输入: 关键词列表
- 输出: 500字段落

**模块3: Image Generator**
- 使用DALL-E API
- 输入: 段落摘要
- 输出: 封面图URL

**模块4: Publish**
- WordPress REST API
- 创建草稿
- 设置特色图片

## 5. 自动化营销漏斗

### 场景：潜在客户 nurturing

**工作流**:
`
1. 捕获线索
   - 着陆表单 -> 邮件订阅
   - 社交媒体 -> DM自动回复

2. 初步培育
   - Day 1: 欢迎邮件 + 免费资源
   - Day 3: 案例研究
   - Day 7: 产品演示邀请

3. 资格评估
   - 点击行为分析
   - 参与度评分

4. 销售跟进
   - 高分线索 -> 人工联系
   - 低分线索 -> 自动化培育
`

## 6. 实战练习

### 练习1：社交媒体自动发布
`
目标: 每天自动发布3条AI相关内容
工具: n8n + Twitter API + ChatGPT
复杂度: 中等
`

### 练习2：客户反馈自动分析
`
目标: 收集邮件/评论，AI分析情感，生成报告
工具: Make.com + OpenAI + Google Sheets
复杂度: 简单
`

### 练习3：电商订单自动化
`
目标: 新订单 -> 发货通知 -> 评价请求
工具: Zapier + Shopify + Gmail
复杂度: 简单
`

## 7. 关键要点

1. **从简单开始** — 先自动化一个流程，再扩展
2. **保留人工审核** — 自动化不等于无人化
3. **监控和告警** — 设置失败通知
4. **文档化工作流** — 方便维护和交接

## 8. 推荐资源
- [n8n官方模板库](https://n8n.io/workflows/)
- [Make.com场景库](https://www.make.com/en/scenarios.html)
- [Zapier Templates](https://zapier.com/apps/zapier/get-template)
