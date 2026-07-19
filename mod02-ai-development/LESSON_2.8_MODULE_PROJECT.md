# Lesson 2.8: 模块实战 — 从0到1构建产品

## 学习目标
1. 综合运用所学，完成一个完整项目
2. 体验从构思到上线的全流程
3. 产出：可运行的产品 + 部署链接

## 1. 项目选题

### 推荐选题
- AI写作助手SaaS
- 个人知识库工具
- 电商选品分析器
- SEO内容生成器

### 本次选题
**AI写作助手** — 帮助用户快速生成博客文章的工具

## 2. 开发计划

### Week 1: MVP开发
- Day 1-2: 需求分析和原型设计
- Day 3-5: 核心功能开发
- Day 6-7: 测试和优化

### Week 2: 完善和上线
- Day 1-2: 用户反馈收集
- Day 3-4: 功能迭代
- Day 5-7: 营销准备

## 3. 技术栈

`
前端: Next.js + Tailwind CSS
后端: Node.js + Express
数据库: PostgreSQL + Prisma
AI: OpenAI API
部署: Vercel + Railway
认证: NextAuth.js
`

## 4. 核心功能

### P0 (必须完成)
1. 用户注册/登录
2. 文章生成(输入主题+关键词)
3. 文章编辑(富文本)
4. 导出(PDF/Markdown)

### P1 (应该完成)
1. 模板库
2. 历史记录
3. 批量生成

### P2 (有时间完成)
1. 协作功能
2. API集成
3. 移动端适配

## 5. 开发步骤

### Step 1: 初始化项目
`ash
npx create-next-app@latest ai-writer --typescript
cd ai-writer
npm install prisma @prisma/client
npx prisma init
`

### Step 2: 设计数据库
`prisma
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  password  String
  articles  Article[]
}

model Article {
  id          String   @id @default(uuid())
  title       String
  content     String
  userId      String
  user        User     @relation(fields: [userId], references: [id])
  createdAt   DateTime @default(now())
}
`

### Step 3: 实现AI生成
`	ypescript
// lib/openai.ts
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY
});

export async function generateArticle(topic: string, keywords: string[]) {
  const response = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: [
      { role: 'system', content: '你是一个专业的博客写手...' },
      { role: 'user', content: \写一篇关于\的博客文章，包含关键词:\\ }
    ],
    temperature: 0.7
  });
  
  return response.choices[0].message.content;
}
`

### Step 4: 部署上线
`ash
# 推送到GitHub
git add .
git commit -m 'Initial commit'
git push origin main

# Vercel部署
vercel --prod
`

## 6. 练习作业

1. 完成你的MVP开发
2. 部署到Vercel
3. 邀请5个朋友测试
4. 收集反馈并迭代

## 7. 关键要点
1. MVP要小但要能用
2. 用户反馈比自我判断重要
3. 快速迭代胜过完美发布
4. 记录开发过程本身就是学习
