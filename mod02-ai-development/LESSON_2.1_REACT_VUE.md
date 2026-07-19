# Lesson 2.1: React/Vue 快速开发

## 学习目标
1. 掌握用AI快速生成React/Vue组件
2. 学会Tailwind CSS + AI进行响应式布局
3. 实战：搭建一个产品展示页

## 1. 项目初始化

### 使用Vite创建React项目
`ash
npm create vite@latest ai-product-showcase -- --template react-ts
cd ai-product-showcase
npm install
npm install tailwindcss postcss autoprefixer
npx tailwindcss init -p
`

### Tailwind配置
`javascript
// tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    \"./index.html\",
    \"./src/**/*.{js,ts,jsx,tsx}\",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#3B82F6',
        secondary: '#8B5CF6',
      },
    },
  },
  plugins: [],
}
`

## 2. AI生成首页组件

### Prompt 1: 导航栏
`
请创建一个React导航栏组件Navbar.tsx，要求：
- 使用Tailwind CSS
- 包含Logo、导航链接(首页、功能、定价、关于)、登录按钮
- 响应式设计：移动端汉堡菜单
- 滚动时添加阴影效果
- 导出默认组件
`

### 预期代码结构
`	sx
// src/components/Navbar.tsx
import { useState, useEffect } from 'react';

export default function Navbar() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 10);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <nav className={\ixed w-full z-50 transition-shadow \\}>
      <div className=\"max-w-7xl mx-auto px-4 sm:px-6 lg:px-8\">
        <div className=\"flex justify-between items-center h-16\">
          {/* Logo */}
          <div className=\"flex-shrink-0\">
            <span className=\"text-xl font-bold text-primary\">AI Writer</span>
          </div>
          
          {/* Desktop Navigation */}
          <div className=\"hidden md:flex space-x-8\">
            <a href=\"#home\" className=\"text-gray-700 hover:text-primary\">首页</a>
            <a href=\"#features\" className=\"text-gray-700 hover:text-primary\">功能</a>
            <a href=\"#pricing\" className=\"text-gray-700 hover:text-primary\">定价</a>
            <a href=\"#about\" className=\"text-gray-700 hover:text-primary\">关于</a>
          </div>

          {/* Login Button */}
          <div className=\"hidden md:block\">
            <button className=\"bg-primary text-white px-4 py-2 rounded-lg hover:bg-blue-600\">
              登录
            </button>
          </div>

          {/* Mobile Menu Button */}
          <div className=\"md:hidden\">
            <button onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}>
              {/* Hamburger icon */}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Menu */}
      {isMobileMenuOpen && (
        <div className=\"md:hidden bg-white shadow-lg\">
          <div className=\"px-2 pt-2 pb-3 space-y-1\">
            <a href=\"#home\" className=\"block px-3 py-2 text-gray-700\">首页</a>
            <a href=\"#features\" className=\"block px-3 py-2 text-gray-700\">功能</a>
            <a href=\"#pricing\" className=\"block px-3 py-2 text-gray-700\">定价</a>
            <button className=\"w-full bg-primary text-white px-4 py-2 rounded-lg\">
              登录
            </button>
          </div>
        </div>
      )}
    </nav>
  );
}
`

## 3. AI生成Hero区域

### Prompt 2: Hero Section
`
请创建一个React Hero区域组件HeroSection.tsx，要求：
- 左侧：大标题"用AI让写作效率提升10倍" + 副标题 + CTA按钮
- 右侧：产品截图/演示动画占位
- 渐变背景
- 响应式设计
- 添加简单的入场动画
`

## 4. AI生成功能卡片

### Prompt 3: Features Grid
`
请创建一个功能展示组件Features.tsx，要求：
- 3列网格布局（移动端1列）
- 每张卡片包含：图标、标题、描述
- 功能1: AI写作助手 - 智能生成文章草稿
- 功能2: 语法纠错 - 实时检测并修正错误
- 功能3: 多语言支持 - 支持20+种语言
- Hover效果：上浮 + 阴影
- 使用Lucide React图标库
`

## 5. AI生成定价页面

### Prompt 4: Pricing Cards
`
请创建一个定价组件Pricing.tsx，要求：
- 3个定价层级：免费版、专业版(\/月)、团队版(\/月)
- 专业版高亮显示"最受欢迎"
- 每个层级列出包含的功能
- 月付/年付切换（年付打8折）
- 响应式设计
- 添加简单的对比表格
`

## 6. 组装主页

### App.tsx
`	sx
import Navbar from './components/Navbar';
import HeroSection from './components/HeroSection';
import Features from './components/Features';
import Pricing from './components/Pricing';
import Footer from './components/Footer';

function App() {
  return (
    <div className=\"min-h-screen bg-gradient-to-b from-blue-50 to-white\">
      <Navbar />
      <main className=\"pt-16\">
        <HeroSection />
        <Features />
        <Pricing />
      </main>
      <Footer />
    </div>
  );
}

export default App;
`

## 7. 部署预览

`ash
# 本地运行
npm run dev

# 构建生产版本
npm run build

# 预览
npm run preview
`

## 8. 练习作业

1. 用AI为你的课程项目生成一个完整的着陆页
2. 添加一个"用户评价"部分，包含5条评价卡片
3. 添加一个"FAQ"手风琴组件

## 关键要点
1. **分组件生成** — 不要试图一次让AI生成整个页面
2. **提供设计参考** — 给AI链接或截图效果更好
3. **迭代优化** — 先生成基础版本，再逐步添加交互
4. **移动端优先** — 让AI先生成移动端布局，再扩展桌面端
