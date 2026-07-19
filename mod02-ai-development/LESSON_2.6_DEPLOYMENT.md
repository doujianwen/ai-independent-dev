# Lesson 2.6: 部署与CI/CD

## 学习目标
1. 掌握Vercel/Netlify一键部署
2. 学会用GitHub Actions自动化构建
3. 实战：搭建完整的CI/CD流水线

## 1. Vercel部署

### 一键部署步骤
1. 推送代码到GitHub
2. 登录Vercel
3. Import Git Repository
4. 自动检测框架
5. 配置环境变量
6. Deploy!

### 环境变量配置
NEXT_PUBLIC_API_URL=https://api.yoursite.com
DATABASE_URL=postgresql://...
OPENAI_API_KEY=sk-...

## 2. GitHub Actions CI/CD

### 基础Workflow
name: CI/CD
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
      - run: npm ci
      - run: npm test
      - run: npm run build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == refs/heads/main
    steps:
      - uses: actions/checkout@v3
      - uses: amondnet/vercel-action@v20
        with:
          vercel-token: VERCEL_TOKEN_FROM_SECRETS
          working-directory: ./

## 3. 实战练习

### 练习1：自动化测试部署
配置：
- PR触发测试
- 测试通过后自动部署到Preview
- Merge到main部署到Production

### 练习2：多环境部署
环境：
- development: 开发分支
- staging: 测试分支
- production: main分支

## 4. 关键要点
1. 自动化一切 - 减少手动操作
2. 环境变量分离 - 不同环境不同配置
3. 监控和告警 - 部署失败立即通知
4. 回滚策略 - 一键回滚到上一个版本
