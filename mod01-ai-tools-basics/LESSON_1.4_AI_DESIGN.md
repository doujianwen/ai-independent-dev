# Lesson 1.4: AI设计工具 — 从文本到图像

## 学习目标
1. 掌握Midjourney v7、DALL-E 4、Stable Diffusion 3的核心用法
2. 学会写高质量的图像生成提示词
3. 建立商业图片生成工作流
4. 实战：为你的产品生成Banner和图标

## 1. 三大AI图像工具对比

### Midjourney v7
- **价格**: \/月 (Standard)
- **优势**: 图像质量最高，艺术感强
- **适合**: 品牌视觉、概念设计、营销素材
- **特点**: Discord社区操作，风格多样

### DALL-E 4 (ChatGPT Plus)
- **价格**: 包含在ChatGPT Plus \/月
- **优势**: 与ChatGPT无缝集成，理解复杂指令
- **适合**: 快速原型、产品概念图
- **特点**: 支持编辑和变体生成

### Stable Diffusion 3
- **价格**: 免费开源
- **优势**: 完全可控，可本地部署
- **适合**: 批量生成、定制化需求
- **特点**: 需要GPU，学习曲线较陡

## 2. 图像提示词写作框架

### BRTE 框架
`
B - Background (背景)
R - Subject (主体)
T - Tone (色调/氛围)
E - Environment (环境/光影)

示例:
Background: 极简白色背景
Subject: 一个透明的玻璃水瓶，水面有波纹
Tone: 清新、现代、高端
Environment: 柔和的自然光从左侧照射
`

### 进阶技巧

#### 风格关键词
`
摄影风格: professional photography, editorial, lifestyle
艺术风格: minimalist, abstract, surreal, impressionist
配色方案: pastel colors, vibrant, monochrome, warm tones
构图: close-up, wide angle, rule of thirds, symmetrical
`

#### 负面提示词 (Negative Prompt)
`
避免: blurry, low quality, distorted, watermark, text
质量: masterpiece, best quality, ultra detailed
`

## 3. 实战一：产品Banner生成

### 场景：AI写作工具Banner

**Prompt**:
`
A modern SaaS product banner for an AI writing tool.
Background: clean gradient from light blue to white
Main element: floating laptop displaying a writing interface
Accent: subtle AI neural network pattern in background
Text area: left side with empty space for headline
Style: flat design, minimal, professional
Colors: blue (#3B82F6), white, gray
Resolution: 1920x1080, web optimized
`

**Midjourney参数**:
`
--ar 16:9 --v 7 --style raw --q 2
`

### 场景：课程宣传图

**Prompt**:
`
An inspiring educational illustration.
Subject: diverse group of people using laptops and tablets
Setting: modern co-working space with plants
Mood: productive, creative, collaborative
Style: 3D isometric illustration, colorful
Lighting: warm golden hour sunlight
Elements: AI icons floating, thought bubbles with checkmarks
Composition: centered, balanced
`

## 4. 实战二：图标和Logo生成

### 工具图标设计

**Prompt**:
`
A minimalist app icon for an AI writing assistant.
Shape: rounded square
Symbol: stylized pen tip merging with a brain circuit
Colors: primary blue (#3B82F6) on white background
Style: flat, modern, recognizable at small sizes
No text, no gradients, solid colors only
`

### Logo设计

**Prompt**:
`
A professional logo for a tech startup.
Company name: WriteAI
Symbol: abstract W letter formed by flowing lines
Style: geometric, modern, scalable
Colors: deep blue and electric blue gradient
Format: vector-style, clean lines
Variations: horizontal, stacked, icon-only
`

## 5. 批量生成工作流

### 步骤1：确定设计系统
`
- 主色调: #3B82F6 (蓝), #8B5CF6 (紫)
- 字体: Inter, SF Pro
- 圆角: 12px
- 阴影: soft, layered
`

### 步骤2：创建模板库
`
Banner模板:
- 1920x1080 (网站头部)
- 1200x628 (社交媒体)
- 1080x1920 (Stories)

图标模板:
- 512x512 (App Store)
- 1024x1024 (高清版)

产品图模板:
- 800x800 (电商主图)
- 1200x1200 (详情页)
`

### 步骤3：批量生成
`
1. 用同一Prompt框架生成10个变体
2. 选择最好的3个
3. 用Photoshop/Canva微调
4. 导出不同尺寸
`

## 6. 实战三：社交媒体素材

### Instagram帖子系列

**Prompt**:
`
A series of 5 Instagram posts for an AI tool launch.
Style: consistent brand identity
Post 1: Announcement - bold typography, product shot
Post 2: Feature highlight - icon + short text
Post 3: Testimonial - quote card design
Post 4: Tutorial - step-by-step infographic
Post 5: CTA - limited offer, countdown timer

Color scheme: brand blue and white
Typography: clean, modern sans-serif
Layout: grid-based, plenty of whitespace
`

### YouTube缩略图

**Prompt**:
`
A YouTube thumbnail for a tech tutorial video.
Title text area: top third, bold yellow text on dark background
Main image: laptop with code on screen
Accent elements: arrows pointing to key areas
Style: high contrast, eye-catching, professional
Size: 1280x720 (16:9)
`

## 7. 图像后处理

### 常用工具
`
1. Canva - 快速排版，加文字
2. Photoshop - 精细编辑
3. Remove.bg - 去除背景
4. Upscale.media - 图像放大
5. Fotor - 批量处理
`

### 工作流
`
AI生成原始图 -> 去除背景 -> 添加文字 -> 调色 -> 导出
`

## 8. 练习作业

1. 为你的课程项目生成3张Banner
2. 设计一套5个功能图标
3. 制作一个Instagram帖子系列(5张)

## 关键要点
1. **提示词越具体，结果越好** — 包含风格、配色、构图
2. **建立设计系统** — 保持一致性比单次质量更重要
3. **批量生成，精选优化** — 不要追求一次完美
4. **AI生成 + 人工精修 = 最佳效果**
