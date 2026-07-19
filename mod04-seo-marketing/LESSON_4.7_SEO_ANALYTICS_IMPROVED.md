# Lesson 4.7: SEO 数据分析（完整版）

## 学习目标
1. 掌握 Google Search Console 的高级用法
2. 学会用数据驱动的方式优化 SEO 策略
3. 能够解读 SEO 指标并制定改进计划
4. 建立自动化的 SEO 报告体系

---

## 1. Google Search Console 深度使用

### 1.1 核心报告解读

```
Performance Report（表现报告）— 最重要的报告

可分析的维度：
├── 总览指标
│   ├── 点击数（Clicks）
│   ├── 展示量（Impressions）
│   ├── 平均排名（Average Position）
│   └── 点击率（CTR）
├── 按页面分析
│   ├── 找出高展示低点击的页面
│   ├── 识别排名接近首页的页面
│   └── 发现新的关键词机会
├── 按查询分析
│   ├── 哪些关键词带来流量
│   ├── 哪些关键词有高展示但低排名
│   └── 发现搜索意图变化
├── 按国家/地区
│   ├── 地理分布分析
│   └── 本地化 SEO 优化
└── 按设备
    ├── 移动端 vs 桌面端对比
    └── Mobile-First 效果验证
```

### 1.2 高级筛选技巧

```
筛选器组合示例：

1. 发现优化机会
   展示量 > 1000 AND 平均排名 11-20
   → 这些页面即将进入首页，优化 Title 即可提升

2. 高展示低点击
   展示量 > 500 AND CTR < 1%
   → 优化 Meta Description 提高 CTR

3. 排名下滑预警
   平均排名比上月下降 > 5 位
   → 检查是否有算法更新或技术问题

4. 新关键词发现
   展示量 > 100 AND 排名 > 30
   → 值得为目标创建新内容
```

---

## 2. Google Analytics 4 与 SEO

### 2.1 SEO 相关的 GA4 报告

```
自然流量分析路径：
Reports → Acquisition → Traffic acquisition

关键指标：
├── Sessions（会话数）
│   └── 筛选 Source/Medium = google / organic
├── Engagement Rate（互动率）
│   └ → 衡量内容质量
├── Average Engagement Time（平均互动时长）
│   └ → 衡量内容深度
├── Conversions（转化）
│   └ → 衡量 SEO 的商业价值
└── Pages per Session（每会话页面数）
   └ → 衡量站点导航和内部链接效果
```

### 2.2 设置 SEO 自定义事件

```javascript
// 追踪 SEO 相关事件
import { gtag } from 'gtag';

// 追踪滚动深度
window.addEventListener('scroll', () => {
  const scrollDepth = (window.scrollY / document.documentElement.scrollHeight) * 100;
  if (scrollDepth >= 25 && scrollDepth < 30) {
    gtag('event', 'scroll_25', { engagement_time_msec: 100 });
  }
  if (scrollDepth >= 50 && scrollDepth < 55) {
    gtag('event', 'scroll_50', { engagement_time_msec: 200 });
  }
  if (scrollDepth >= 75 && scrollDepth < 80) {
    gtag('event', 'scroll_75', { engagement_time_msec: 300 });
  }
  if (scrollDepth >= 90) {
    gtag('event', 'scroll_90', { engagement_time_msec: 500 });
  }
});

// 追踪搜索行为
document.querySelector('#search-input')?.addEventListener('change', (e) => {
  gtag('event', 'site_search', {
    search_term: e.target.value,
  });
});
```

---

## 3. SEO 核心指标解读

### 3.1 指标含义和优化方向

```
指标              含义                    优化方向
─────────────────────────────────────────────────────
Organic Clicks    来自搜索引擎的点击数     提升排名 + 优化 CTR
Impressions       在搜索结果中展示的次数    覆盖更多关键词
CTR (点击率)      点击数/展示量           优化 Title + Meta
Avg Position      平均排名位置            内容优化 + 外链
Engagement Rate   用户互动率              内容质量 + UX
Bounce Rate       跳出率                  内容匹配度 + 页面速度
Conversion Rate   转化率                  转化路径优化
```

### 3.2 健康 SEO 站点的基准值

```
内容型站点（博客）：
├── 自然流量月增长率：5-15%
├── 平均 CTR：2-5%（首页）/ 0.5-2%（第 2-3 页）
├── 平均停留时间：≥ 2 分钟
├── 每会话页面数：≥ 2.5
└── 跳出率：≤ 55%

电商型站点：
├── 自然流量月增长率：3-10%
├── 平均 CTR：3-8%
├── 平均停留时间：≥ 1.5 分钟
├── 每会话页面数：≥ 3
└── 转化率：1-3%
```

---

## 4. SEO 数据驱动的优化流程

### 4.1 月度 SEO 分析流程

```
Week 1: 数据收集
├── 导出 GSC Performance 数据
├── 导出 GA4 自然流量报告
├── 导出排名跟踪数据
└── 汇总外链数据

Week 2: 数据分析
├── 识别 Top 10 表现页面
├── 找出 Top 10 待优化页面
├── 分析关键词排名变化
└── 检查 Core Web Vitals 变化

Week 3: 制定优化计划
├── 为待优化页面制定优化方案
├── 规划新内容方向
├── 安排技术修复
└── 设定下月目标

Week 4: 执行和优化
├── 实施优化方案
├── 发布新内容
├── 修复技术问题
└── 跟踪效果
```

### 4.2 用 AI 分析 SEO 数据

```
提示词模板：

「以下是我网站的 GSC 数据（过去 28 天）：

[粘贴数据：查询、页面、展示量、点击数、CTR、平均排名]

请帮我分析：
1. 哪些关键词最有优化潜力？
2. 哪些页面的 CTR 低于预期？
3. 哪些排名正在上升/下降？
4. 建议的优化优先级
5. 内容创作方向建议

请用表格形式呈现分析结果。」
```

---

## 5. SEO 报告模板

### 5.1 月度 SEO 报告

```
# [月份] SEO 月度报告

## 概览
- 自然流量：XX,XXX（环比 +X%）
- 关键词排名（前 100）：XXX（+XX）
- 首页排名关键词：XXX（+XX）
- 总外链：XXX（+XX）

## 亮点
1. "[关键词]" 从第 15 名上升到第 5 名
2. 新发布的 "[文章名]" 获得 XX 次展示
3. 获得 XX 个高质量外链

## 需要关注
1. "[关键词]" 排名下降 5 位
2. 移动端 LCP 从 2.1s 增加到 2.8s
3. [页面名] 的 CTR 低于 1%

## 下月计划
1. 优化 [页面名] 的 Title 和 Meta Description
2. 发布 4 篇新内容
3. 开展 2 次客座博客
```

---

## 6. 常见错误和解决方案

| 错误 | 后果 | 解决方案 |
|------|------|---------|
| 只看点击数不看展示量 | 错失优化机会 | 综合分析所有指标 |
| 不区分设备数据 | 优化方向错误 | 分别分析移动/桌面 |
| 短期波动就恐慌 | 误判形势 | 看 28 天滚动平均值 |
| 不跟踪转化率 | 不知道 SEO 价值 | 设置转化目标 |
| 忽略竞争对手数据 | 盲目优化 | 定期竞品分析 |

---

## 7. 实战练习

### 练习：完成月度 SEO 分析报告

**任务**：
1. 连接 GSC 和 GA4 到你的网站
2. 导出过去 28 天的数据
3. 使用提供的模板生成月度报告
4. 识别 3 个最重要的优化机会
5. 制定下周的优化行动计划

---

## 8. 关键要点总结

> **核心记忆点：**
> 1. GSC 是 SEO 最重要的免费工具
> 2. 综合看点击、展示、排名、CTR 四个指标
> 3. 高展示低排名 = 优化机会
> 4. 高展示低 CTR = 优化 Title/Description
> 5. GA4 补充用户行为数据
> 6. AI 可以快速分析大量 SEO 数据
> 7. 月度报告帮助跟踪长期趋势
> 8. 数据驱动决策 > 凭感觉优化
