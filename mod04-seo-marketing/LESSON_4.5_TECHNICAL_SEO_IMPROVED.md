# Lesson 4.5: 技术 SEO（完整版）

## 学习目标
1. 理解技术 SEO 的核心要素和优化方法
2. 掌握站点结构、爬取效率、索引控制的技术实现
3. 学会使用技术 SEO 工具进行诊断和优化
4. 能够独立解决常见的技术 SEO 问题

---

## 1. 技术 SEO 全景图

```
技术 SEO 优化领域：
├── 爬取控制（Crawlability）
│   ├── robots.txt
│   ├── Sitemap
│   └── 站点结构
├── 索引控制（Indexability）
│   ├── Canonical 标签
│   ├── Noindex/No-follow
│   └── URL 规范化
├── 页面性能（Performance）
│   ├── Core Web Vitals
│   ├── 加载优化
│   └── 渲染方式
├── 移动端优化（Mobile）
│   ├── 响应式设计
│   └── Mobile-First
├── 结构化数据（Structured Data）
│   ├── Schema Markup
│   └── Rich Results
└── 安全与协议（Security）
    ├── HTTPS
    └── HSTS
```

---

## 2. 爬取效率优化

### 2.1 robots.txt 配置

```
# 正确的 robots.txt
User-agent: *
Allow: /
Disallow: /admin/
Disallow: /wp-admin/
Disallow: /wp-includes/
Disallow: /cgi-bin/
Disallow: /?s=*
Disallow: /feed/
Disallow: /trackback/

# 指定 Googlebot
User-agent: Googlebot
Allow: /

# Sitemap 位置
Sitemap: https://yourdomain.com/sitemap.xml

# 常见错误：
# ❌ Disallow: /  → 禁止所有爬取
# ❌ 没有 Sitemap 声明
# ❌ 阻止了 CSS/JS 文件（Google 需要它们来渲染页面）
```

### 2.2 XML Sitemap

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
        xmlns:video="http://www.google.com/schemas/sitemap-video/1.1">

  <url>
    <loc>https://yourdomain.com/</loc>
    <lastmod>2025-01-15</lastmod>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>

  <url>
    <loc>https://yourdomain.com/blog/ai-writing-tools</loc>
    <lastmod>2025-01-20</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
    <image:image>
      <image:loc>https://yourdomain.com/images/ai-tools.jpg</image:loc>
      <image:title>AI 写作工具对比</image:title>
    </image:image>
  </url>

</urlset>
```

```
Sitemap 最佳实践：
- 单个文件不超过 50,000 个 URL 或 50MB
- 超过限制则使用 sitemap index
- 只包含可索引的页面
- 不包含重定向链中的 URL
- 包含 canonical URL
- 定期更新 lastmod 日期
```

### 2.3 站点结构优化

```
理想的站点结构：
├── 首页（深度 0）
│   ├── 类别 A（深度 1）
│   │   ├── 文章 A1（深度 2）
│   │   ├── 文章 A2（深度 2）
│   │   └── 文章 A3（深度 2）
│   ├── 类别 B（深度 1）
│   │   ├── 文章 B1（深度 2）
│   │   └── 文章 B2（深度 2）
│   └── 类别 C（深度 1）
│       └── 文章 C1（深度 2）

规则：
- 任何页面应在 3 次点击内到达
- 扁平化结构优于深层嵌套
- 重要页面应该靠近首页
```

---

## 3. 索引控制

### 3.1 Canonical 标签

```html
<!-- 正确的 canonical -->
<link rel="canonical" href="https://yourdomain.com/blog/article/" />

<!-- 常见场景 -->
<!-- 场景 1：URL 参数导致重复 -->
<!-- ?sort=price 和 ?sort=date 指向同一内容 → canonical 到主页 -->

<!-- 场景 2：HTTP vs HTTPS -->
<!-- http:// 和 https:// → canonical 到 https:// -->

<!-- 场景 3：www vs non-www -->
<!-- www.example.com 和 example.com → 统一 canonical -->

<!-- 场景 4：打印版本/移动端 -->
<!-- 打印版 canonical 到原文 -->
```

### 3.2 Noindex 和 Nofollow

```html
<!-- 不索引的页面 -->
<meta name="robots" content="noindex, follow" />

<!-- 不跟随的链接 -->
<a href="/link" rel="nofollow">链接</a>

<!-- 哪些页面需要 noindex？ -->
□ 搜索结果页面
□ 感谢/确认页面
□ 管理员页面
□ 重复/薄内容页面
□ 临时促销页面
□ 标签归档页（如果有 pillar page）
```

---

## 4. 渲染方式对 SEO 的影响

### 4.1 三种渲染方式对比

```
┌──────────────┬────────────┬────────────┬─────────────┐
│   维度       │  SSR       │  SSG       │  CSR        │
│              │ (服务端渲染)│(静态生成)  │(客户端渲染)  │
├──────────────┼────────────┼────────────┼─────────────┤
│ SEO 友好度    │ ⭐⭐⭐⭐⭐  │ ⭐⭐⭐⭐⭐  │ ⭐⭐         │
│ 首屏速度      │ ⭐⭐⭐⭐    │ ⭐⭐⭐⭐⭐  │ ⭐⭐         │
│ 开发复杂度    │ ⭐⭐⭐      │ ⭐⭐⭐⭐⭐   │ ⭐⭐⭐⭐⭐    │
│ 适用场景      │ 动态内容    │ 内容站      │ Web App     │
└──────────────┴────────────┴────────────┴─────────────┘
```

### 4.2 Next.js SEO 最佳实践

```typescript
// 使用 Metadata API（Next.js 13+）
export const metadata = {
  title: 'AI 工具评测 | 独立开发者指南',
  description: '2025 年最佳 AI 工具完整评测和对比',
  keywords: ['AI 工具', 'AI 评测', '独立开发'],
  openGraph: {
    title: 'AI 工具评测 | 独立开发者指南',
    description: '2025 年最佳 AI 工具完整评测和对比',
    images: ['/og-image.jpg'],
    type: 'article',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'AI 工具评测',
    description: '2025 年最佳 AI 工具完整评测',
    image: '/og-image.jpg',
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
};

// 动态 metadata（每个页面不同）
export async function generateMetadata({ params }) {
  const post = await getPost(params.slug);
  return {
    title: post.title,
    description: post.excerpt,
    openGraph: {
      type: 'article',
      publishedTime: post.date,
      authors: [post.author],
    },
  };
}
```

---

## 5. 国际化 SEO（hreflang）

```html
<!-- 多语言站点 hreflang 标签 -->
<link rel="alternate" hreflang="zh-CN" href="https://example.com/zh-cn/" />
<link rel="alternate" hreflang="en-US" href="https://example.com/en-us/" />
<link rel="alternate" hreflang="x-default" href="https://example.com/" />

<!-- 注意：hreflang 必须双向链接 -->
<!-- zh-CN 页面链接到 en-US 页面，反之亦然 -->
```

---

## 6. 技术 SEO 诊断工具

```
必备工具：
├── Google Search Console
│   ├── 覆盖率报告（索引状态）
│   ├── 核心 Web Vitals 报告
│   ├── 手动操作报告
│   └── 增强功能报告（Rich Results）
├── Screaming Frog SEO Spider
│   ├── 爬取整个站点
│   ├── 发现 broken links
│   ├── 检查 meta 标签
│   └── 导出 SEO 数据
├── Lighthouse
│   ├── 性能审计
│   ├── SEO 审计
│   └── 可访问性审计
└── DeepCrawl / Sitebulb
   ├── 大规模站点审计
   └── 自动化报告
```

---

## 7. 常见技术问题排查

### 7.1 页面未被索引

```
排查步骤：
1. 在 GSC 中搜索 "site:yourdomain.com/page-url"
2. 检查 robots.txt 是否阻止爬取
3. 检查是否有 noindex 标签
4. 检查 canonical 是否指向其他 URL
5. 检查页面是否有足够的内容（薄内容会被排除）
6. 检查服务器日志确认 Googlebot 是否访问过
```

### 7.2 索引量突然下降

```
可能原因：
1. 服务器宕机或响应超时
2. robots.txt 意外阻止了爬取
3. 网站迁移后 301 未正确配置
4. 算法更新影响了排名
5. 收到了手动惩罚

排查：
→ 检查 GSC 手动操作报告
→ 检查服务器日志
→ 比较算法更新时间表
```

---

## 8. 常见错误和解决方案

| 错误 | 影响 | 解决方案 |
|------|------|---------|
| robots.txt 阻止 CSS/JS | Google 无法正确渲染 | 允许 bot 访问静态资源 |
| 缺少 canonical 标签 | 重复内容问题 | 每个页面添加 canonical |
| 301 重定向链过长 | 权重流失 | 直接 301 到最终 URL |
| 内链死循环 | 爬虫浪费预算 | 定期检查链接结构 |
| Sitemap 包含已删除页面 | 爬取浪费 | 保持 sitemap 同步 |
| 未配置 hreflang | 多语言 SEO 失败 | 正确设置语言标记 |

---

## 9. 实战练习

### 练习：技术 SEO 审计

**任务**：
1. 使用 Screaming Frog 爬取你的网站
2. 检查所有页面的 Title 和 Meta Description
3. 查找 broken links 和重定向链
4. 验证 robots.txt 和 sitemap.xml
5. 在 GSC 中检查索引状态
6. 生成审计报告并制定修复计划

---

## 10. 关键要点总结

> **核心记忆点：**
> 1. 技术 SEO 是基础，没有它内容 SEO 无从谈起
> 2. robots.txt 和 sitemap.xml 是最基本的配置
> 3. Canonical 标签解决重复内容问题
> 4. SSR/SSG 比 CSR 更适合 SEO
> 5. GSC 是技术 SEO 最重要的诊断工具
> 6. 定期审计技术 SEO 状况
> 7. 服务器响应速度和稳定性直接影响爬取效率
> 8. 国际化站点需要正确配置 hreflang
