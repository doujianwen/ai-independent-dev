# Lesson 3.3: 静态站点生成器（完整版）

## 学习目标
1. 理解静态站点生成器（SSG）的工作原理和优势
2. 掌握 Next.js、Astro、Hugo 三大主流 SSG 的选择标准
3. 学会使用 AI 辅助生成站点结构和页面内容
4. 独立完成一个高性能博客站的搭建和部署

---

## 1. 为什么静态站点生成器是独立开发者的利器？

### SSG vs WordPress 对比

| 维度 | WordPress | 静态站点生成器 |
|------|----------|--------------|
| 首次加载速度 | 500ms - 2s | 50ms - 200ms |
| 安全性 | 需持续打补丁 | 几乎零风险 |
| 维护成本 | 高（插件/主题更新） | 极低（只需更新依赖） |
| 可扩展性 | 受限于主机配置 | CDN 边缘节点，无限扩展 |
| 内容管理 | 可视化后台 | Git + Markdown / Headless CMS |
| 适合场景 | 动态内容、会员系统 | 博客、文档、落地页、作品集 |

### 市场数据
- 2024 年新站中，45% 使用某种形式的静态站点架构
- Vercel 平台月均部署次数超过 **5000 万次**
- Astro 项目 GitHub Star 数超过 **54,000+**
- Hugo 生成的站点数量超过 **10 亿个**

### SSG 的核心优势
`
1. 性能极致
   - 预渲染 HTML，无需客户端执行
   - 可部署到 CDN 边缘节点
   - 全球延迟 < 50ms

2. 安全无忧
   - 无数据库 = 无 SQL 注入风险
   - 无服务器端代码 = 无远程代码执行
   - 静态文件 = 无 XSS 攻击面

3. 成本极低
   - Vercel/Netlify 免费额度足够个人项目
   - GitHub Pages 完全免费
   - 无服务器费用

4. 开发体验好
   - Markdown 写作
   - Git 版本控制
   - AI 生成内容无缝集成
`

---

## 2. 三大 SSG 深度对比

### 2.1 Next.js（React 生态）

**定位**：全功能 React 框架，支持 SSR/SSG/ISR

`javascript
// app/blog/[slug]/page.tsx — Next.js 14 App Router
import { getAllBlogPosts, getBlogPostBySlug } from '@/lib/posts';
import { MDXRemote } from 'next-mdx-remote/rsc';
import { highlight } from 'highlight.js';

// 静态生成：构建时预渲染所有文章
export async function generateStaticParams() {
  const posts = getAllBlogPosts();
  return posts.map(post => ({ slug: post.slug }));
}

export async function generateMetadata({ params }) {
  const post = getBlogPostBySlug(params.slug);
  return {
    title: post.frontmatter.title,
    description: post.frontmatter.excerpt,
    openGraph: {
      title: post.frontmatter.title,
      images: [post.frontmatter.coverImage],
    },
  };
}

export default async function BlogPost({ params }) {
  const post = getBlogPostBySlug(params.slug);
  
  return (
    <article className=\"prose prose-lg max-w-3xl mx-auto\">
      <h1>{post.frontmatter.title}</h1>
      <time>{post.frontmatter.date}</time>
      <MDXRemote source={post.content} />
    </article>
  );
}
`

**适用场景**：
- 需要服务端渲染的动态功能（搜索、评论）
- 与 React 生态深度集成
- 未来可能扩展为全功能应用

**缺点**：
- 学习曲线陡峭（需要掌握 React + Next.js 概念）
- 包体积较大（React 运行时 ~140KB gzipped）
- 过度工程化（纯博客场景大材小用）

### 2.2 Astro（内容优先，组件自由）

**定位**：内容驱动的网站框架，支持多框架组件

`javascript
// src/pages/blog/[slug].astro — Astro 内容页面
---
// 前端代码块（构建时执行）
import { getAllBlogPosts } from '../../content/config';
import PostCard from '../../components/PostCard.astro';
import type { CollectionEntry } from 'astro:content';

interface Props {
  entry: CollectionEntry<'blog'>;
}

const { entry } = Astro.props;
const { title, description, date, tags } = entry.data;
---

<article class=\"post\">
  <h1>{title}</h1>
  <time datetime={date.toISOString()}>{date.toLocaleDateString()}</time>
  <div class=\"tags\">
    {tags.map(tag => <span class=\"tag\">{tag}</span>)}
  </div>
  
  <!-- Astro 组件直接渲染，零 JS 发送到客户端 -->
  <div set:html={entry.body} class=\"content\" />
  
  <!-- 按需加载交互组件 -->
  <ClientOnly>
    <CommentSystem />
    <ReadingProgress />
  </ClientOnly>
</article>

<style>
  .post { max-width: 720px; margin: 0 auto; padding: 2rem; }
  .tag { 
    background: #f0f0f0; 
    padding: 2px 8px; 
    border-radius: 4px;
    font-size: 0.875rem;
  }
</style>
`

**适用场景**：
- 博客、文档站、营销落地页
- 需要混合多种前端框架（React + Vue + Svelte）
- 追求极致性能（默认零 JS）

**优点**：
- 默认零 JavaScript 发送到客户端
- 支持 Islands Architecture（孤岛架构）
- 学习曲线平缓（HTML + CSS + 可选组件）
- 内容集合系统开箱即用

### 2.3 Hugo（Go 语言，极速构建）

`ash
# Hugo 项目结构
myblog/
├── content/
│   ├── _index.md          # 首页内容
│   ├── blog/
│   │   ├── _index.md
│   │   ├── post-1.md
│   │   └── post-2.md
│   └── about.md
├── layouts/               # 自定义模板
├── static/                # 静态资源
├── themes/                # 主题
└── hugo.toml              # 配置文件
`

`markdown
---
title: "我的第一篇博客"
date: 2025-01-15
tags: ["AI", "编程"]
description: "这是文章摘要"
---

# 这是我的文章标题

正文内容使用 Markdown 编写。

## 二级标题

段落内容...
`

**适用场景**：
- 超大型站点（10 万+页面）
- 不需要 JavaScript 的纯内容站
- 喜欢简单配置的开发者

**优点**：
- 构建速度极快（10 万页面 < 1 秒）
- 单二进制文件，无需 Node.js
- 主题生态丰富（100+ 主题）

---

## 3. 实战：用 Astro 搭建 AI 工具评测博客

### 3.1 项目初始化

`ash
# 1. 创建 Astro 项目
npm create astro@latest ai-tool-review
cd ai-tool-review

# 2. 选择配置
# ✓ Empty (empty project)
# ✓ Yes (TypeScript)
# ✓ Yes (Prettier)

# 3. 安装依赖
npm install

# 4. 启动开发服务器
npm run dev
# 访问 http://localhost:4321
`

### 3.2 配置内容集合

`	ypescript
// src/content/config.ts
import { defineCollection, z } from 'astro:content';

const blog = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    date: z.coerce.date(),
    tags: z.array(z.string()).default([]),
    coverImage: z.string().optional(),
    author: z.string().default('AI Developer'),
    toolUrl: z.string().url().optional(),       // 工具链接
    pricing: z.enum(['free', 'freemium', 'paid']).default('free'),
    rating: z.number().min(1).max(5).optional(), // AI 工具评分
  }),
});

export const collections = { blog };
`

### 3.3 用 AI 生成评测内容

`markdown
<!-- content/blog/claude-code-review.md -->
---
title: "Claude Code — AI 编程助手的终极形态？"
description: "深度评测 Anthropic 的 Claude Code CLI 工具，对比 GitHub Copilot 和 Cursor"
date: 2025-06-15
tags: ["AI工具", "编程", "评测", "Claude"]
coverImage: "/images/claude-code-hero.jpg"
pricing: "paid"
rating: 4.8
toolUrl: "https://www.anthropic.com/claude-code"
---

# Claude Code 深度评测

## 快速结论
**评分：4.8/5** — Claude Code 是目前最强的 AI 编程助手之一，特别适合需要大规模代码重构的项目。

## 核心功能测试

### 1. 代码理解能力
在测试中，Claude Code 成功：
- 理解了 50,000 行 React 项目的整体架构
- 准确识别了 12 个潜在的内存泄漏问题
- 生成了完整的单元测试覆盖

### 2. 代码修改能力
`ash
# 让 Claude Code 批量修改代码
$ claude "将所有 useState 改为 useReducer 模式"
✓ 分析了 234 个文件
✓ 修改了 89 个文件
✓ 保留了所有测试用例通过
`

## 与竞品对比

| 功能 | Claude Code | GitHub Copilot | Cursor |
|------|------------|---------------|--------|
| 项目级理解 | ✅ 完整项目 | ❌ 单文件 | ✅ 部分 |
| 批量修改 | ✅ | ❌ | ✅ |
| 终端集成 | ✅ | ❌ | ✅ |
| 价格 | \/月 | \/月 | \/月 |
| 上手难度 | 中等 | 低 | 低 |

## 适合谁？
- 需要重构大型代码库的开发者
- 希望提高代码质量的团队
- 喜欢终端操作的工程师

## 不适合谁？
- 初学者（需要一定的编程基础）
- 只需要代码补全的用户（Copilot 更合适）
