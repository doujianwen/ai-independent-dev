# Lesson 3.5: Headless CMS 内容管理（完整版）

## 学习目标
1. 理解 Headless CMS 与传统 CMS 的本质区别
2. 掌握 Sanity、Contentful、Strapi 三大平台的选型方法
3. 学会用 AI 批量生成和管理结构化内容
4. 构建内容驱动型应用的完整数据管道

---

## 1. 为什么需要 Headless CMS？

### 传统 CMS vs Headless CMS

```
传统 CMS (WordPress)          Headless CMS (Sanity/Contentful)
┌─────────────────┐           ┌─────────────────┐
│  Content        │           │  Content        │
│  + Presentation │           │  + API Layer    │
│  (耦合在一起)    │           │  (解耦)         │
└────────┬────────┘           └────────┬────────┘
         │                             │
    只能输出 Web                    任何端（Web/App/IoT）
    修改内容需懂前端                内容生产与展示分离
    性能受限                       无限可扩展
```

### 何时需要 Headless CMS？

| 场景 | 需要 Headless？ | 原因 |
|------|---------------|------|
| 单一博客 | 否 | WordPress 足够 |
| 多端内容分发 | 是 | Web + App + 小程序 |
| 复杂内容结构 | 是 | 自定义 Schema |
| 团队协作 | 是 | 版本控制 + 审批流 |
| 实时内容更新 | 是 | Live Preview + CDN |
| 高并发 API | 是 | 专用 API 层 |

### 市场数据
- Headless CMS 市场 2024 年增长 **32%**（Gartner）
- 73% 的企业计划在未来 2 年迁移到 Headless 架构
- Sanity 日均 API 调用超过 **50 亿次**
- Contentful 托管内容超过 **100 PB**

---

## 2. 三大 Headless CMS 深度对比

### 2.1 Sanity.io — 开发者最爱

**核心优势**：
- 实时协作编辑（类似 Google Docs）
- 自定义 Schema 完全灵活
- GROQ 查询语言强大且高效
- 免费额度慷慨（100 万条文档/月）

```javascript
// sanity.config/schema.ts — 定义内容结构

// 文章 Schema
export const blogPost = {
  name: 'blogPost',
  title: '博客文章',
  type: 'document',
  fields: [
    {
      name: 'title',
      title: '标题',
      type: 'string',
      validation: Rule => Rule.required().min(5).max(200),
    },
    {
      name: 'slug',
      title: '链接',
      type: 'slug',
      options: { source: 'title', maxLength: 200 },
      validation: Rule => Rule.required(),
    },
    {
      name: 'body',
      title: '正文',
      type: 'array',
      of: [
        { type: 'block' },                    // 富文本块
        { type: 'codeBlock' },                 // 代码块
        { type: 'callout' },                   // 自定义组件
        { type: 'imageGallery' },              // 图片画廊
      ],
    },
    {
      name: 'tags',
      title: '标签',
      type: 'array',
      of: [{ type: 'reference', to: [{ type: 'tag' }] }],
    },
    {
      name: 'author',
      title: '作者',
      type: 'reference',
      to: { type: 'author' },
    },
    {
      name: 'publishedAt',
      title: '发布时间',
      type: 'datetime',
    },
    {
      name: 'featuredImage',
      title: '封面图',
      type: 'image',
      options: { hotspot: true },
    },
    {
      name: 'seo',
      title: 'SEO 设置',
      type: 'object',
      fields: [
        { name: 'metaTitle', title: '标题', type: 'string' },
        { name: 'metaDescription', title: '描述', type: 'string' },
        { name: 'socialImage', title: '社交图片', type: 'image' },
      ],
    },
  ],
};

// 标签 Schema
export const tag = {
  name: 'tag',
  title: '标签',
  type: 'document',
  fields: [
    { name: 'name', title: '名称', type: 'string' },
    { name: 'slug', title: '链接', type: 'slug', options: { source: 'name' } },
    { name: 'color', title: '颜色', type: 'string' },
  ],
};
```

```groq
// GROQ 查询 — 获取最新文章
*[_type == "blogPost" && defined(publishedAt)] | order(publishedAt desc) [0...10] {
  title,
  slug,
  "date": publishedAt,
  "author": author-> { name, avatar },
  "tags": tags[]-> { name, slug },
  featuredImage.asset-> {
    "url": asset->url,
    "alt": alt
  },
  seo { metaTitle, metaDescription }
}
```

### 2.2 Contentful — 企业级选择

**核心优势**：
- 内容模型可视化编辑器
- 强大的团队协作和审批流
- 多语言原生支持（100+ 种语言）
- 与企业系统集成（Salesforce、HubSpot）

```javascript
// Contentful 内容模型设计

// Entry: Blog Post
{
  sys: {
    contentType: "blogPost",
    space: "my-space",
    environment: "master"
  },
  fields: {
    title: {
      "zh-CN": "AI 编程工具评测",
      "en-US": "AI Coding Tool Review"
    },
    slug: "ai-coding-review",
    content: {
      "zh-CN": [
        {
          "nodeType": "paragraph",
          content: [...]
        }
      ],
      "en-US": [...]
    },
    coverImage: {
      "sys": {
        "type": "Link",
        "linkType": "Asset",
        "id": "cover-image-id"
      }
    },
    author: {
      "sys": {
        "type": "Link",
        "linkType": "Entry",
        "id": "author-id"
      }
    },
    tags: ["AI", "编程", "评测"],
    seoMeta: {
      title: "2025 最佳 AI 编程工具完整评测",
      description: "深度对比 Claude Code、Cursor、GitHub Copilot...",
      ogImage: "og-image-id"
    }
  }
}
```

```javascript
// 使用 Contentful SDK 查询
import { createClient } from 'contentful';

const client = createClient({
  space: process.env.CONTENTFUL_SPACE_ID,
  accessToken: process.env.CONTENTFUL_ACCESS_TOKEN,
});

// 查询带分页的文章列表
const articles = await client.getEntries({
  content_type: 'blogPost',
  order: '-fields.publishedAt',
  limit: 10,
  'fields.tags[in]': ['AI'],
  locale: 'zh-CN',
});

// 查询单篇文章及其关联数据
const article = await client.getEntries({
  content_type: 'blogPost',
  'fields.slug': 'ai-coding-review',
  'locale': 'zh-CN',
  include: 3, // 深度嵌套关联
});
```

### 2.3 Strapi — 自托管开源方案

**核心优势**：
- 完全自托管，数据可控
- 开源免费，无用量限制
- 插件生态丰富
- 支持自定义中间件

```javascript
// src/api/article/content-types/article/schema.json
{
  "kind": "collectionType",
  "collectionName": "articles",
  "info": {
    "singularName": "article",
    "pluralName": "articles",
    "displayName": "文章"
  },
  "attributes": {
    "title": {
      "type": "string",
      "required": true,
      "maxLength": 200
    },
    "slug": {
      "type": "uid",
      "targetField": "title",
      "required": true
    },
    "content": {
      "type": "richtext",
      "required": true
    },
    "coverImage": {
      "type": "media",
      "multiple": false,
      "allowedTypes": ["images"]
    },
    "author": {
      "type": "relation",
      "relation": "manyToOne",
      "target": "api::author.author",
      "inversedBy": "articles"
    },
    "tags": {
      "type": "relation",
      "relation": "manyToMany",
      "target": "api::tag.tag",
      "inversedBy": "articles"
    },
    "publishedAt": {
      "type": "datetime"
    },
    "seoTitle": {
      "type": "string"
    },
    "seoDescription": {
      "type": "text"
    }
  }
}
```

---

## 3. AI 辅助内容管理

### 3.1 批量生成结构化内容

```javascript
// 使用 AI 批量生成 Sanity 内容
// 将 AI 生成的内容自动转换为 Schema 格式

async function generateBlogPostsFromAI(topics) {
  const posts = [];

  for (const topic of topics) {
    // 调用 AI 生成结构化内容
    const aiResponse = await generateStructuredContent(topic);

    posts.push({
      _type: 'blogPost',
      title: aiResponse.title,
      slug: { _type: 'slug', current: slugify(aiResponse.title) },
      body: parseMarkdownToBlocks(aiResponse.content),
      tags: aiResponse.tags.map(tag => ({
        _type: 'reference',
        _ref: findOrCreateTag(tag).id
      })),
      publishedAt: new Date().toISOString(),
      seo: {
        metaTitle: aiResponse.seo?.title || aiResponse.title,
        metaDescription: aiResponse.seo?.description || '',
      }
    });
  }

  return posts;
}

// AI 提示词模板
const CONTENT_GENERATION_PROMPT = `
你是一个专业的内容创作者。请为以下主题生成一篇结构化的博客文章：

主题: {topic}
目标关键词: {keyword}
目标字数: 2000-3000
语言: 中文

请返回 JSON 格式：
{
  "title": "吸引人的标题",
  "content": "Markdown 格式的正文",
  "tags": ["标签1", "标签2"],
  "seo": {
    "title": "SEO 标题 (≤60字符)",
    "description": "Meta 描述 (≤160字符)"
  },
  "estimatedReadTime": 10
}
`;
```

### 3.2 AI 内容审核和优化

```javascript
// 内容质量评分脚本
async function scoreContentQuality(content) {
  const prompt = `
请对以下内容进行质量评分（1-10分）：

"${content.substring(0, 2000)}..."

评分维度：
1. 结构完整性（是否有清晰的 H2/H3 层级）
2. SEO 友好度（关键词密度、标题优化）
3. 可读性（段落长度、句子复杂度）
4. 信息价值（是否有独特见解或数据）
5. 语法和拼写

请返回 JSON：
{
  "totalScore": 8,
  "dimensions": {
    "structure": 9,
    "seo": 7,
    "readability": 8,
    "value": 8,
    "grammar": 9
  },
  "suggestions": ["建议添加更多数据支撑", "第一段可以更吸引人"]
}
`;

  return callAI(prompt);
}
```

---

## 4. 前端集成实战

### 4.1 Next.js + Sanity 全栈方案

```typescript
// lib/sanity.ts
import { createClient } from 'next-sanity';

export const sanityClient = createClient({
  projectId: process.env.NEXT_PUBLIC_SANITY_PROJECT_ID,
  dataset: 'production',
  apiVersion: '2025-01-15',
  useCdn: true, // ISR 模式下使用 CDN
  token: process.env.SANITY_API_READ_TOKEN,
});

// lib/sanity-queries.ts
import { defineQuery } from 'next-sanity';

export const GET_ALL_POSTS = defineQuery(`
  *[_type == "blogPost" && defined(publishedAt)] | order(publishedAt desc) {
    title,
    slug,
    publishedAt,
    "excerpt": coalesce(
      body[]->text(),
      ""
    )[0...500],
    "author": author->{name, avatar},
    "tags": tags[]->{name, slug},
    "imageUrl": featuredImage.asset->url,
    seo { metaTitle, metaDescription }
  }
`);

export const GET_POST_BY_SLUG = defineQuery(`
  *[_type == "blogPost" && slug.current == $slug][0] {
    title,
    body,
    publishedAt,
    "author": author->{name, bio, avatar},
    "tags": tags[]->{name, slug},
    "prevPost": *[_type == "blogPost" && publishedAt < ^.publishedAt] | order(publishedAt desc) [0] {
      title, slug
    },
    "nextPost": *[_type == "blogPost" && publishedAt > ^.publishedAt] | order(publishedAt asc) [0] {
      title, slug
    },
    seo { metaTitle, metaDescription }
  }
`);
```

```typescript
// app/blog/page.tsx — 博客列表页
import { sanityClient } from '@/lib/sanity';
import { GET_ALL_POSTS } from '@/lib/sanity-queries';
import BlogCard from '@/components/BlogCard';

export const revalidate = 3600; // 每小时重新验证（ISR）

export default async function BlogPage({ searchParams }) {
  const page = (await searchParams).page || 1;
  const perPage = 10;

  const posts = await sanityClient.fetch(GET_ALL_POSTS);
  const totalPages = Math.ceil(posts.length / perPage);
  const paginatedPosts = posts.slice((page - 1) * perPage, page * perPage);

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-8">最新文章</h1>

      <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-3">
        {paginatedPosts.map(post => (
          <BlogCard key={post._id} post={post} />
        ))}
      </div>

      {/* 分页组件 */}
      <Pagination currentPage={page} totalPages={totalPages} />
    </div>
  );
}
```

---

## 5. 常见错误和解决方案

| 错误 | 后果 | 解决方案 |
|------|------|---------|
| Schema 设计不合理 | 后期难以修改 | 先用纸笔画 ER 图，再实现 |
| 忘记配置 CORS | 前端无法访问 API | 在 CMS 后台配置允许的域名 |
| 未使用 CDN | 全球访问慢 | 启用 CDN 缓存，配置 TTL |
| 查询未优化 | API 响应慢 | 只请求需要的字段，使用索引 |
| 未处理网络错误 | 页面崩溃 | 添加 try-catch 和降级方案 |
| 多语言未同步 | 部分内容缺失 | 建立翻译工作流，设置默认回退 |

---

## 6. 实战练习

### 练习：构建多语言博客

**任务**：
1. 选择 Sanity 或 Contentful 创建内容模型
2. 设计中英文双语 Schema
3. 用 AI 生成 10 篇双语文章
4. 使用 Next.js 构建多语言前端
5. 实现语言切换和国际化路由

---

## 7. 关键要点总结

> **核心记忆点：**
> 1. Headless CMS 的核心价值是内容与应用解耦
> 2. Sanity 最适合开发者（灵活 + GROQ），Contentful 适合企业，Strapi 适合自托管
> 3. Schema 设计要面向未来，预留扩展空间
> 4. AI 可以批量生成结构化内容，但需要人工审核
> 5. 前端集成时使用 ISR/SSG 保证性能
> 6. 多语言内容要注意翻译一致性和回退策略
> 7. 查询优化是关键：只取需要的字段，善用缓存
> 8. 内容审核自动化可以大幅提升生产效率
