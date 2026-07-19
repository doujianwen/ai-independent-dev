# Lesson 3.3: 静态站点生成器

## 学习目标
1. 掌握Next.js/Nuxt.js/Astro
2. 学会用AI生成站点结构
3. 实战：搭建一个博客站

## 1. Next.js博客

### 初始化
`ash
npx create-next-app@latest my-blog --typescript
cd my-blog
npm install gray-matter remark remark-html
`

### 博客文章结构
`
posts/
├── first-post.md
├── second-post.md
└── ai-tools-guide.md
`

### MarkdownFrontmatter
`yaml
---
title: AI工具入门指南
date: 2026-07-16
tags: [AI, 教程]
excerpt: 全面了解2026年主流AI工具
---

正文内容...
`

## 2. AI生成页面

### Prompt:
`
用Next.js创建一个博客首页，包含：
- 文章列表(卡片布局)
- 分类筛选
- 搜索功能
- 分页
- 暗色模式切换
`

## 3. 部署

### Vercel部署
`ash
vercel --prod
`

## 4. 关键要点
1. SSG速度快，SEO友好
2. Markdown写作体验好
3. 静态站点成本低
4. CDN全球分发
