# Lesson 2.5: 数据库设计与ORM

## 学习目标
1. 掌握SQL vs NoSQL的选择方法
2. 学会用AI生成数据库Schema
3. 实战：设计一个完整的电商数据库

## 1. 数据库选型指南

### SQL vs NoSQL对比
| 特性 | PostgreSQL | MongoDB |
|------|-----------|---------|
| 数据结构 | 固定schema | 灵活schema |
| 事务支持 | ACID | 有限 |
| 关联查询 | 强 | 弱 |
| 扩展性 | 垂直为主 | 水平扩展 |
| 适合场景 | 金融、电商 | 内容、IoT |

### 推荐方案
`
电商系统: PostgreSQL (强一致性)
博客系统: MongoDB (灵活内容)
聊天应用: Redis + PostgreSQL
数据分析: ClickHouse
缓存: Redis
`

## 2. AI生成Schema

### Prompt:
`
为我设计一个SaaS产品的数据库Schema，使用Prisma ORM：

需要的表：
1. Users - 用户(邮箱、密码哈希、角色、订阅状态)
2. Plans - 订阅计划(免费版/专业版/企业版)
3. Subscriptions - 用户订阅记录
4. Projects - 用户项目
5. Invitations - 项目邀请
6. AuditLogs - 操作日志

关系：
- 用户属于一个计划
- 用户有多个项目
- 项目可以有多个成员(通过Invitations)

添加必要索引和外键约束。
`

## 3. Prisma Schema示例
`prisma
model User {
  id           String    @id @default(uuid())
  email        String    @unique
  passwordHash String
  role         String    @default(\"user\")
  planId       String
  plan         Plan      @relation(fields: [planId], references: [id])
  subscriptions Subscription[]
  projects     Project[]
  createdAt    DateTime  @default(now())
  updatedAt    DateTime  @updatedAt
}

model Plan {
  id          String       @id @default(uuid())
  name        String       @unique
  price       Float
  features    String[]     // JSON encoded features
  users       User[]
  subscriptions Subscription[]
}

model Project {
  id          String   @id @default(uuid())
  name        String
  ownerId     String
  owner       User     @relation(fields: [ownerId], references: [id])
  invitations Invitation[]
  members     Member[]
  createdAt   DateTime @default(now())
}
`

## 4. 实战练习

### 练习1：博客数据库
`
设计一个博客系统的数据库：
- 用户、文章、分类、标签、评论
- 支持文章收藏和点赞
`

### 练习2：任务管理数据库
`
设计一个Kanban任务管理系统的数据库：
- 用户、项目、看板、列表、卡片
- 支持卡片标签和截止日期
`

## 5. 关键要点
1. **先设计再编码** — Schema一旦上线很难修改
2. **索引很重要** — 查询慢通常是缺索引
3. **软删除优于硬删除** — 保留数据历史
4. **审计日志必备** — 追踪谁做了什么
