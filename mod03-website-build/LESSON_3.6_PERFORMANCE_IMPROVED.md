# Lesson 3.6: 网站性能优化（完整版）

## 学习目标
1. 深入理解 Core Web Vitals 各项指标的含义和优化方法
2. 掌握前端性能优化的完整工具链
3. 学会用 AI 辅助诊断和优化性能瓶颈
4. 建立持续监控的性能管理体系

---

## 1. Core Web Vitals 深度解析

### 什么是 Core Web Vitals？

Core Web Vitals 是 Google 定义的三个核心用户体验指标，直接影响搜索排名和转化率。

| 指标 | 全称 | 目标值 | 影响 |
|------|------|--------|------|
| LCP | Largest Contentful Paint | ≤ 2.5s | 加载速度感知 |
| INP | Interaction to Next Paint | ≤ 200ms | 交互响应性 |
| CLS | Cumulative Layout Shift | ≤ 0.1 | 视觉稳定性 |

### 2025 年最新数据
- 全球网站 LCP 中位数：**3.2 秒**（超过目标值 28%）
- 顶级 10% 网站的 LCP：**1.1 秒**
- 页面加载每慢 1 秒，转化率下降 **7%**
- CLS > 0.25 的网站 abandonment rate 增加 **38%**

---

## 2. LCP 优化（最大内容绘制）

### 2.1 定位 LCP 元素

```javascript
// 使用 Performance API 检测 LCP
const lcpEntries = performance.getEntriesByType('largest-contentful-paint');
const lastLcp = lcpEntries[lcpEntries.length - 1];

console.log('LCP element:', lastLcp.element?.tagName);
console.log('LCP size:', lastLcp.size, 'bytes');
console.log('LCP time:', lastLcp.renderTime, 'ms');

// 常见 LCP 元素类型：
// 1. <img> 标签（最常见）
// 2. <video>  poster 帧
// 3. 带有背景图的 <div>
// 4. <h1> 标题文字
```

### 2.2 LCP 优化策略

**策略 1：图片优化**
```html
<!-- ❌ 差的写法 -->
<img src="/images/hero.jpg" alt="Hero banner" />

<!-- ✅ 好的写法 -->
<link rel="preload" as="image" href="/images/hero.webp" />
<picture>
  <source srcset="/images/hero.avif" type="image/avif" />
  <source srcset="/images/hero.webp" type="image/webp" />
  <img
    src="/images/hero.jpg"
    alt="Hero banner"
    width="1920"
    height="1080"
    loading="eager"
    fetchpriority="high"
    class="hero-image"
  />
</picture>
```

```css
/* 使用 aspect-ratio 防止布局偏移 */
.hero-image {
  width: 100%;
  height: auto;
  aspect-ratio: 16 / 9;
  object-fit: cover;
}
```

**策略 2：关键 CSS 内联**
```javascript
// Next.js 中内联关键 CSS
import { inter } from '@/fonts';

export default function Layout({ children }) {
  return (
    <html lang="zh-CN" className={inter.className}>
      <head>
        {/* 内联首屏关键 CSS */}
        <style dangerouslySetInnerHTML={{ __html: `
          /* 关键样式 — 防止 FOUC */
          body { margin: 0; font-family: system-ui, sans-serif; }
          .hero { min-height: 60vh; display: flex; align-items: center; }
          .container { max-width: 1200px; margin: 0 auto; padding: 0 1rem; }
        `}} />
      </head>
      <body>{children}</body>
    </html>
  );
}
```

**策略 3：Server Components 预渲染**
```typescript
// Next.js Server Component — 构建时渲染，零客户端 JS
export default async function HomePage() {
  const posts = await getLatestPosts(); // 服务端数据获取

  return (
    <main>
      <HeroSection />           {/* 静态渲染 */}
      <PostList posts={posts} /> {/* 构建时生成 HTML */}
    </main>
  );
}
// 生成纯 HTML，LCP 元素直接在 HTML 中
```

---

## 3. INP 优化（交互响应）

### 3.1 INP 与 FID 的区别

```
FID (First Input Delay) — 只测量第一次交互
INP (Interaction to Next Paint) — 测量所有交互

INP 关注：
- 所有点击、键盘、触摸事件的响应时间
- 取最差的那个值（P98 百分位）
- 反映整页的交互体验
```

### 3.2 INP 优化技巧

```javascript
// 1. 减少主线程阻塞时间
// 使用 Web Worker 处理耗时任务
const worker = new Worker(new URL('./heavy-computation.worker.js', import.meta.url));
worker.postMessage(data);
worker.onmessage = (e) => {
  updateUI(e.data); // 主线程只负责更新 UI
};

// 2. 事件节流
function throttle(fn, delay) {
  let lastCall = 0;
  return (...args) => {
    const now = Date.now();
    if (now - lastCall >= delay) {
      lastCall = now;
      fn(...args);
    }
  };
}

// 3. 使用 passive 事件监听器
element.addEventListener('scroll', handleScroll, { passive: true });
element.addEventListener('touchstart', onTouchStart, { passive: true });

// 4. 避免布局抖动
// ❌ 读取 layout 属性后写入，导致强制同步布局
const height = element.offsetHeight; // 读取
element.style.height = height + 100 + 'px'; // 写入 → 触发 reflow

// ✅ 批量读写
const heights = elements.map(el => el.offsetHeight); // 全部读取
elements.forEach((el, i) => el.style.height = heights[i] + 100 + 'px'); // 全部写入
```

### 3.3 React 性能优化

```jsx
// 1. React.memo 避免不必要的重渲染
const Comment = React.memo(({ author, text }) => {
  return (
    <div className="comment">
      <strong>{author}</strong>
      <p>{text}</p>
    </div>
  );
});

// 2. useMemo 缓存计算结果
const sortedPosts = useMemo(() => {
  return posts.sort((a, b) => b.date - a.date);
}, [posts]);

// 3. useDeferredValue 延迟更新非关键状态
const deferredSearchTerm = useDeferredValue(searchTerm, 200);

// 4. Suspense 边界
<Suspense fallback={<LoadingSpinner />}>
  <HeavyComponent />
</Suspense>
```

---

## 4. CLS 优化（视觉稳定性）

### 4.1 CLS 常见来源

```
CLS = 0.15 的问题可能由：
- 广告插入导致页面跳动 (+0.05)
- 动态加载字体改变布局 (+0.03)
- Lazy 加载图片没有尺寸 (+0.04)
- JavaScript 动态插入内容 (+0.03)
```

### 4.2 CLS 优化清单

```css
/* 1. 为所有图片设置宽高 */
img, video, canvas, svg {
  max-width: 100%;
  height: auto;
}

/* 2. 使用 aspect-ratio 保持比例 */
.ad-container {
  aspect-ratio: 728 / 90;
  min-height: 90px; /* 占位 */
}

/* 3. 字体预加载防止 FOIT/FOUT */
@font-face {
  font-family: 'CustomFont';
  src: url('/fonts/custom.woff2') format('woff2');
  font-display: swap; /* 或使用 optional */
}

/* 4. 动画使用 transform 而非 layout 属性 */
.animated {
  /* ✅ 好：GPU 加速，不影响布局 */
  transform: translateY(-10px);
  opacity: 0;

  /* ❌ 差：触发 reflow */
  /* margin-top: -10px; */
  /* top: -10px; */
}
```

```html
<!-- 5. 预留广告位空间 -->
<div class="ad-slot" style="min-height: 250px;">
  <!-- 广告加载后替换内容 -->
</div>
```

---

## 5. 性能监控工具链

### 5.1 开发阶段

```bash
# 1. Lighthouse CI — 自动化性能审计
npx lhci autorun

# 2. Web Vitals 实时监控
# 安装
npm install web-vitals

# 使用
import { onLCP, onINP, onCLS } from 'web-vitals';

onLCP(({ value }) => {
  console.log('LCP:', value);
  // 上报到分析平台
  analytics.track('web_vital_lcp', { value });
});

onINP(({ value }) => {
  console.log('INP:', value);
  analytics.track('web_vital_inp', { value });
});

onCLS(({ value }) => {
  console.log('CLS:', value);
  analytics.track('web_vital_cls', { value });
});
```

### 5.2 生产环境

```javascript
// 使用 CrUX API 获取真实用户数据
async function getRealWorldMetrics(domain) {
  const response = await fetch(
    `https://chromeuxreport.googleapis.com/v1/records:queryRecord?key=${API_KEY}`
  );
  const data = await response.json();
  return data.record?.metrics;
}

// 或使用 Google Search Console API
async function getGSCPerformance(url) {
  const response = await fetch(
    'https://www.googleapis.com/searchconsent/v4/sites/{property}/searchAnalytics/query',
    {
      method: 'POST',
      body: JSON.stringify({
        startDate: '2025-01-01',
        endDate: '2025-01-31',
        dimensions: ['page'],
        dimensionFilters: { state: 'confirmed' }
      })
    }
  );
  return response.json();
}
```

---

## 6. AI 辅助性能优化

### 6.1 用 AI 诊断性能问题

```
提示词模板：

「我正在使用 Lighthouse 审计我的网站，得到以下结果：

LCP: 4.2s (需要改进)
INP: 350ms (需要改进)
CLS: 0.08 (良好)

以下是 network 瀑布图和 performance 火焰图数据：
[粘贴数据]

请帮我分析：
1. LCP 延迟的主要原因是什么？
2. INP 高的可能原因？
3. 具体的优化建议和代码示例」
```

### 6.2 用 AI 生成优化后的代码

```
提示词模板：

「请将以下 React 组件优化，使其满足 Core Web Vitals 要求：
- 图片使用 Next/Image 组件
- 关键 CSS 内联
- 非关键组件使用 lazy loading
- 添加适当的 loading 和 skeleton 状态
- 确保 CLS < 0.1」
```

---

## 7. 常见错误和解决方案

| 错误 | 影响 | 解决方案 |
|------|------|---------|
| 图片未压缩 | LCP > 5s | 使用 WebP/AVIF，压缩到 < 100KB |
| 未设置图片尺寸 | CLS 增加 | width + height + aspect-ratio |
| 字体未预加载 | FOUT 闪烁 | font-display: swap + preload |
| 大量第三方脚本 | INP > 500ms | 异步加载，使用 lazy hydration |
| 未使用 CDN | 全球延迟高 | Cloudflare/Vercel Edge |
| 每次请求都拉全量数据 | 缓存命中率低 | 使用 ISR + 增量静态再生 |

---

## 8. 实战练习

### 练习：将网站 Lighthouse 分数提升到 90+

**任务**：
1. 运行 Lighthouse 审计当前网站
2. 针对每个不及格项制定优化计划
3. 实施优化并验证效果
4. 编写性能优化报告

**验收标准**：
- Lighthouse Performance ≥ 90
- LCP ≤ 2.5s
- INP ≤ 200ms
- CLS ≤ 0.1

---

## 9. 关键要点总结

> **核心记忆点：**
> 1. Core Web Vitals 直接影响搜索排名和转化率
> 2. LCP 优化核心：图片压缩 + 关键 CSS + 预渲染
> 3. INP 优化核心：减少主线程阻塞 + 事件优化
> 4. CLS 优化核心：预留空间 + 固定尺寸 + 避免动态插入
> 5. 使用 Web Vitals 库做实时监控
> 6. AI 可以帮助诊断和优化，但需要具体数据
> 7. CDN + 缓存是成本最低的优化手段
> 8. 性能优化是持续过程，不是一次性工作
