# Lesson 1.3: AI编程助手深度使用

## 学习目标
1. 掌握Cursor/GitHub Copilot/Windsurf的核心功能
2. 学会让AI帮你写代码、找Bug、重构
3. 建立AI辅助开发的工作流

## 1. 三大AI编程工具对比

### Cursor
- **价格**: 免费\ / Pro \/月 / Team \/月
- **优势**: 代码库感知最强，支持多文件编辑，内置Terminal
- **特色**: Composer模式可跨文件协作，Cline插件支持自主执行任务
- **适合**: 需要深度理解项目结构的开发者

### GitHub Copilot
- **价格**: 免费学生 / \/月个人 / \/月企业
- **优势**: VSCode原生集成，生态最成熟
- **特色**: Copilot Chat支持自然语言对话，Agentic mode可自主编辑
- **适合**: 已在VSCode工作的开发者

### Windsurf
- **优势**: 深度代码理解，支持多语言
- **特色**: Cascade模式可自动执行多步骤任务
- **适合**: 需要复杂代码分析的开发者

## 2. Cursor 核心功能详解

### 功能一：AI代码生成 (Cmd+K)
`
快捷键：Cmd+K (Mac) / Ctrl+K (Windows)
用法：选中代码或光标所在位置，输入自然语言指令
示例：
- "将这个函数改为异步版本"
- "添加错误处理和日志"
- "重写为TypeScript"
`

### 功能二：Chat面板 (Cmd+L)
`
快捷键：Cmd+L (Mac) / Ctrl+L (Windows)
用法：与AI对话，询问代码相关问题
示例：
- "解释这段代码的作用"
- "这个Bug可能是什么原因？"
- "如何优化这个查询的性能？"
`

### 功能三：Composer模式 (Cmd+I)
`
快捷键：Cmd+I (Mac) / Ctrl+I (Windows)
用法：跨文件编辑，AI可自动创建/修改多个文件
示例：
- "创建一个用户注册页面，包含表单验证"
- "重构整个认证模块，使用JWT"
- "添加API路由和对应的数据库模型"
`

### 功能四：Cline插件
`
作用：让AI自主执行终端命令
能力：
- 安装依赖
- 运行测试
- 构建项目
- 部署到服务器
注意：需要人工审核每次操作
`

## 3. AI编程最佳实践

### 实践一：分步提示
`
❌ 差："帮我做一个完整的电商网站"
✅ 好：
Step 1: "创建一个Express.js项目，配置TypeScript"
Step 2: "添加用户认证模块，使用JWT"
Step 3: "创建产品列表API，支持分页和搜索"
Step 4: "实现购物车功能，包含数据库模型"
Step 5: "添加支付接口，集成Stripe"
`

### 实践二：提供上下文
`
❌ 差："修复这个Bug"
✅ 好：
"我的用户登录页面在点击登录后返回500错误。
错误日志：'Cannot read property 'id' of undefined'
相关文件：auth.controller.js, user.model.js
可能的原因：用户对象未正确初始化"
`

### 实践三：代码审查
`
"请审查以下代码，指出：
1. 安全漏洞
2. 性能问题
3. 代码异味
4. 改进建议

\\\javascript
[粘贴代码]
\\\"
`

### 实践四：测试生成
`
"为以下函数生成单元测试：
- 使用Jest框架
- 覆盖正常路径和边界情况
- 包含mock数据
- 断言清晰

\\\javascript
function calculateDiscount(price, coupon) { ... }
\\\"
`

## 4. 实战：用AI从0搭建Express.js API

### Step 1: 初始化项目
`
Prompt: "用Express.js和TypeScript初始化一个REST API项目，
包含以下配置：
- TypeScript严格模式
- ESLint + Prettier
- 目录结构：src/controllers, src/routes, src/models, src/middleware
- 环境变量管理
- Dockerfile"
`

### Step 2: 创建用户模型
`
Prompt: "创建一个用户Mongoose模型，包含：
- username (unique, required)
- email (unique, required)
- password (hashed)
- role (user/admin)
- createdAt, updatedAt
添加pre-save钩子加密密码"
`

### Step 3: 认证控制器
`
Prompt: "创建用户认证Controller，包含：
- 注册：验证邮箱格式，密码强度，返回JWT
- 登录：验证凭据，返回access_token和refresh_token
- 登出：使refresh_token失效
- 中间件：验证JWT，设置req.user"
`

### Step 4: 添加错误处理
`
Prompt: "创建全局错误处理中间件：
- 捕获所有未处理的异常
- 区分已知错误和未知错误
- 返回统一的错误格式
- 记录错误日志
- 生产环境不暴露堆栈信息"
`

### Step 5: 生成测试
`
Prompt: "为认证模块生成Jest测试：
- 测试注册成功/失败场景
- 测试登录成功/失败场景
- Mock数据库和邮件服务
- 测试JWT验证中间件
- 测试覆盖率至少80%"
`

## 5. AI调试技巧

### 技巧一：错误信息分析
`
"这个错误是什么意思？如何修复？

Error: TypeError: Cannot read properties of undefined (reading 'map')
at UserList.render (UserList.jsx:45)
at Component.render (react-dom.development.js:18813)

可能的原因：
1. users数组未定义
2. API请求尚未完成
3. 数据结构变化"
`

### 技巧二：逻辑审查
`
"这段代码的逻辑是否正确？

\\\javascript
// 计算用户等级
function getUserLevel(points) {
  if (points > 1000) return 'gold';
  if (points > 500) return 'silver';
  if (points > 100) return 'bronze';
  return 'none';
}
\\\

问题：边界值如何处理？1000分是gold还是silver？"
`

### 技巧三：性能优化
`
"这个查询性能很差，如何优化？

\\\javascript
// 获取用户及其订单
const users = await User.find();
const orders = [];
for (const user of users) {
  const userOrders = await Order.find({ userId: user._id });
  orders.push(...userOrders);
}
\\\

问题：N+1查询问题，应使用populate或聚合管道"
`

## 6. 练习作业

1. 安装Cursor，用Composer模式创建一个完整的Todo App
2. 给你的现有项目写一个System Prompt，让AI成为你的编程搭档
3. 用AI帮你找一个Bug，记录Prompt和修复过程

## 关键要点
1. **AI是副驾驶，你是机长** — 始终审查AI输出的代码
2. **上下文越丰富，结果越好** — 提供文件路径、错误日志、业务逻辑
3. **分步比一步到位更有效** — 复杂任务拆成小步骤
4. **测试是必须的** — AI生成的代码必须经过测试验证
