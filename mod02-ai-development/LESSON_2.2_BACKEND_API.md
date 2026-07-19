# Lesson 2.2: Node.js/Python 后端开发

## 学习目标
1. 学会用AI生成完整的后端API
2. 掌握数据库设计和ORM使用
3. 实战：搭建一个RESTful API

## 1. Node.js + Express 快速开发

### 项目初始化

**Prompt for Cursor**:
`
用Express.js和TypeScript初始化一个REST API项目，
包含以下配置：
- TypeScript严格模式
- ESLint + Prettier
- 目录结构：src/controllers, src/routes, src/models, src/middleware
- 环境变量管理 (.env)
- Dockerfile
`

### AI生成的项目结构
`
backend/
├── src/
│   ├── controllers/
│   │   └── auth.controller.ts
│   ├── models/
│   │   └── User.ts
│   ├── routes/
│   │   └── auth.routes.ts
│   ├── middleware/
│   │   └── auth.middleware.ts
│   └── app.ts
├── .env.example
├── Dockerfile
└── package.json
`

## 2. 用户认证模块

### 生成User模型

**Prompt**:
`
创建一个用户Mongoose模型，包含：
- username (unique, required, min 3 chars)
- email (unique, required, valid format)
- password (hashed, min 8 chars)
- role (user/admin, default user)
- createdAt, updatedAt

添加pre-save钩子加密密码(使用bcrypt)。
`

**AI生成的代码**:
`	ypescript
import mongoose, { Document, Schema } from 'mongoose';
import bcrypt from 'bcryptjs';

export interface IUser extends Document {
  username: string;
  email: string;
  password: string;
  role: 'user' | 'admin';
  comparePassword(candidatePassword: string): Promise<boolean>;
}

const UserSchema = new Schema<IUser>({
  username: { type: String, required: true, unique: true, minlength: 3 },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true, minlength: 8 },
  role: { type: String, enum: ['user', 'admin'], default: 'user' }
}, { timestamps: true });

// Hash password before saving
UserSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

// Compare password method
UserSchema.methods.comparePassword = async function(candidate: string) {
  return bcrypt.compare(candidate, this.password);
};

export default mongoose.model<IUser>('User', UserSchema);
`

### 生成认证Controller

**Prompt**:
`
创建用户认证Controller，包含：
1. 注册：验证邮箱格式，密码强度，返回JWT
2. 登录：验证凭据，返回access_token和refresh_token
3. 登出：使refresh_token失效
4. 中间件：验证JWT，设置req.user

密码规则：
- 至少8位
- 包含大小写字母和数字
- 不能使用常见密码
`

## 3. 数据库设计

### 电商数据库Schema

**Prompt**:
`
设计一个电商系统的数据库Schema，使用Prisma ORM：

需要的表：
1. Users - 用户信息
2. Products - 商品
3. Categories - 分类
4. Orders - 订单
5. OrderItems - 订单项
6. Reviews - 评价
7. Addresses - 收货地址

关系：
- 用户有多个订单
- 订单有多个订单项
- 商品属于分类
- 商品有多个评价

请生成Prisma Schema文件。
`

**AI生成的Schema**:
`prisma
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  username  String
  password  String
  role      String   @default("user")
  orders    Order[]
  reviews   Review[]
  createdAt DateTime @default(now())
}

model Product {
  id          String   @id @default(uuid())
  name        String
  description String
  price       Float
  category    Category @relation(fields: [categoryId], references: [id])
  categoryId  String
  reviews     Review[]
  orderItems  OrderItem[]
  createdAt   DateTime @default(now())
}

model Order {
  id          String   @id @default(uuid())
  user        User     @relation(fields: [userId], references: [id])
  userId      String
  items       OrderItem[]
  total       Float
  status      String   @default("pending")
  createdAt   DateTime @default(now())
}
`

## 4. API路由生成

### 生成CRUD API

**Prompt**:
`
为Product模型生成完整的RESTful API：

GET /api/products - 获取产品列表(支持分页、筛选、排序)
GET /api/products/:id - 获取单个产品
POST /api/products - 创建产品(仅管理员)
PUT /api/products/:id - 更新产品(仅管理员)
DELETE /api/products/:id - 删除产品(仅管理员)

筛选条件：
- category: 按分类筛选
- minPrice/maxPrice: 价格范围
- sortBy: 价格/评分/销量
- q: 关键词搜索

分页：
- page: 页码(默认1)
- limit: 每页数量(默认20, 最大100)
`

## 5. 测试生成

### 自动生成单元测试

**Prompt**:
`
为认证API生成Jest测试：

测试用例：
1. 注册成功 - 返回201和用户信息
2. 注册失败 - 邮箱重复返回400
3. 登录成功 - 返回tokens
4. 登录失败 - 密码错误返回401
5. JWT验证中间件 - 有效token放行，无效token拒绝

使用supertest进行HTTP测试，
Mock数据库操作。
`

## 6. 实战练习

### 练习1：博客API
`
用AI生成一个博客系统的后端API：
- 用户认证
- 文章CRUD
- 评论功能
- 标签系统
- 搜索功能
`

### 练习2：任务管理API
`
生成一个Todo应用的API：
- 用户注册/登录
- 任务创建/更新/删除
- 任务分类
- 优先级设置
- 截止日期提醒
`

## 7. 关键要点
1. **分层架构** — Controller/Service/Model分离
2. **验证很重要** — 前后端都要验证输入
3. **错误处理统一** — 全局错误中间件
4. **测试覆盖核心逻辑** — 特别是认证和支付
