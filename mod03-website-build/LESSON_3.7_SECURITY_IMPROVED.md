# Lesson 3.7: 网站安全加固（完整版）

## 学习目标
1. 理解独立站面临的主要安全威胁和攻击向量
2. 掌握从基础设施到代码层的安全防护体系
3. 学会用 AI 辅助进行安全审计和漏洞检测
4. 建立完善的备份和灾难恢复策略

---

## 1. 独立开发者面临的安全威胁全景

### 2024-2025 年安全趋势数据

| 威胁类型 | 增长趋势 | 平均修复成本 |
|---------|---------|------------|
| SQL 注入 | +15% | $4,886 |
| XSS 攻击 | +22% | $3,907 |
| 暴力破解 | +35% | $1,850 |
| DDoS | +45% | $2,500 |
| 恶意软件植入 | +18% | $5,200 |
| 凭证泄露 | +28% | $4,200 |

### 独立站最常见的 5 个安全漏洞

```
1. 过时的 CMS/框架版本（CVE 已知漏洞未修补）
2. 弱密码或未启用双因素认证
3. 未配置 HTTPS / SSL 证书过期
4. 不安全的 API 端点（无认证/授权）
5. 第三方脚本注入（供应链攻击）
```

---

## 2. 基础设施层安全

### 2.1 HTTPS 强制配置

```nginx
# Nginx HTTPS 配置
server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    # SSL 证书
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    # 安全的 SSL 配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 1d;
    ssl_stapling on;
    ssl_stapling_verify on;

    # HTTP → HTTPS 强制跳转
}

server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$server_name$request_uri;
}
```

### 2.2 Cloudflare 安全配置

```
Cloudflare 免费套餐安全功能：
├── DDoS 防护（自动）
├── WAF（基础规则集）
├── SSL/TLS 加密
├── Bot 管理（基础）
├── 速率限制
└── 地理封锁（可选）

推荐配置：
1. SSL/TLS → 完全（Strict）
2. Security Level → High
3. Bot Fight Mode → ON
4. Under Attack Mode → 仅在攻击时开启
5. WAF → 添加自定义规则
```

### 2.3 安全头配置

```javascript
// Express.js 安全中间件
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "cdn.jsdelivr.net"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "cdn.yourdomain.com"],
      connectSrc: ["'self'"],
      fontSrc: ["'self'", "fonts.gstatic.com"],
      frameSrc: ["'none'"],
      objectSrc: ["'none'"],
    },
  },
  crossOriginEmbedderPolicy: true,
  crossOriginOpenerPolicy: true,
  crossOriginResourcePolicy: { policy: "same-site" },
}));

// 速率限制
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 分钟
  max: 100, // 每个 IP 最多 100 次请求
  message: '请求过于频繁，请稍后再试',
  standardHeaders: true,
  legacyHeaders: false,
});

app.use('/api/', limiter);

// 其他安全头
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '0'); // CSP 已足够
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  res.removeHeader('X-Powered-By'); // 隐藏技术栈
  next();
});
```

---

## 3. 应用层安全

### 3.1 认证安全

```typescript
// 安全的认证实现
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { randomBytes } from 'crypto';

const SALT_ROUNDS = 12;
const JWT_EXPIRY = '15m';       // 短有效期 Access Token
const REFRESH_EXPIRY = '7d';    // 较长有效期 Refresh Token

// 密码哈希
async function hashPassword(password: string): Promise<string> {
  return bcrypt.hash(password, SALT_ROUNDS);
}

// 密码验证
async function verifyPassword(password: string, hash: string): Promise<boolean> {
  return bcrypt.compare(password, hash);
}

// JWT 签发
function generateTokens(userId: string) {
  const accessToken = jwt.sign(
    { sub: userId, type: 'access' },
    process.env.JWT_SECRET!,
    { expiresIn: JWT_EXPIRY }
  );

  const refreshToken = randomBytes(32).toString('hex');
  // 将 refreshToken 存入数据库，关联 userId

  return { accessToken, refreshToken };
}

// 双因素认证（TOTP）
import { authenticator } from 'otplib';

function generateTOTPSecret(): string {
  return authenticator.generateSecret(); // 32 字符 Base32
}

function verifyTOTP(secret: string, token: string): boolean {
  return authenticator.verify({ secret, token });
}
```

### 3.2 输入验证与 Sanitization

```typescript
// 使用 Zod 进行类型安全的输入验证
import { z } from 'zod';

const UserRegistrationSchema = z.object({
  email: z.string().email('请输入有效的邮箱地址'),
  password: z.string()
    .min(12, '密码至少 12 个字符')
    .regex(/[A-Z]/, '密码必须包含大写字母')
    .regex(/[a-z]/, '密码必须包含小写字母')
    .regex(/[0-9]/, '密码必须包含数字'),
  name: z.string().min(2).max(50),
});

const BlogPostSchema = z.object({
  title: z.string().min(5).max(200),
  content: z.string().min(100).max(50000),
  tags: z.array(z.string().max(30)).max(10),
});

// 在 API 路由中使用
export async function POST(req: Request) {
  const body = await req.json();

  const result = UserRegistrationSchema.safeParse(body);
  if (!result.success) {
    return Response.json(
      { error: '验证失败', details: result.error.errors },
      { status: 400 }
    );
  }

  // result.data 已经过验证，类型安全
  const { email, password, name } = result.data;
  // ... 安全地处理数据
}
```

### 3.3 API 安全防护

```typescript
// API 路由安全最佳实践
// 1. 始终验证身份
// 2. 限制请求频率
// 3. 验证输入数据
// 4. 最小化错误信息
// 5. 使用 HTTPS 传输

// Next.js API 路由示例
import { verify } from 'jsonwebtoken';

export async function GET(req: Request) {
  // 验证认证
  const token = req.headers.get('authorization')?.replace('Bearer ', '');
  if (!token) {
    return Response.json({ error: '未授权' }, { status: 401 });
  }

  try {
    const decoded = verify(token, process.env.JWT_SECRET!);
    // decoded 包含 userId
  } catch {
    return Response.json({ error: 'Token 无效' }, { status: 401 });
  }

  // 处理请求...
}
```

---

## 4. 数据安全与备份

### 4.1 数据加密

```typescript
// 敏感数据加密
import crypto from 'crypto';

const ALGORITHM = 'aes-256-gcm';
const IV_LENGTH = 16;

function encrypt(text: string): { iv: string; encrypted: string; authTag: string } {
  const iv = crypto.randomBytes(IV_LENGTH);
  const key = crypto.scryptSync(process.env.ENCRYPTION_KEY!, 'salt', 32);
  const cipher = crypto.createCipheriv(ALGORITHM, key, iv);

  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  const authTag = cipher.getAuthTag().toString('hex');

  return { iv: iv.toString('hex'), encrypted, authTag };
}

function decrypt(iv: string, encrypted: string, authTag: string): string {
  const ivBuf = Buffer.from(iv, 'hex');
  const key = crypto.scryptSync(process.env.ENCRYPTION_KEY!, 'salt', 32);
  const decipher = crypto.createDecipheriv(ALGORITHM, key, ivBuf);
  decipher.setAuthTag(Buffer.from(authTag, 'hex'));

  let decrypted = decipher.update(encrypted, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
}
```

### 4.2 备份策略

```
备份策略（3-2-1 原则）：
├── 3 份数据副本（原始 + 2 备份）
├── 2 种不同存储介质
└── 1 份离线/异地备份

推荐方案：
1. 每日自动备份到云存储（S3 / Backblaze B2）
2. 每周备份一份到本地 NAS
3. 每月做一次完整恢复演练

UpdraftPlus 配置：
- 备份频率：每日
- 保留份数：4 份
- 存储位置：Amazon S3 + Google Drive
- 包含：数据库 + 文件 + 插件配置
- 加密：AES-256
```

---

## 5. AI 辅助安全审计

### 5.1 用 AI 扫描代码漏洞

```
提示词模板：

「请作为安全审计员审查以下代码，找出所有潜在的安全漏洞：

[粘贴代码]

请分类：
1. Critical（严重）— 可直接被利用
2. High（高危）— 需要尽快修复
3. Medium（中危）— 建议修复
4. Low（低危）— 最佳实践

对于每个漏洞，提供：
- CVE 编号（如适用）
- 漏洞原理
- 修复代码示例」
```

### 5.2 用 AI 生成安全报告

```
提示词模板：

「我刚刚完成了网站的安全扫描，以下是结果：
[粘贴扫描结果]

请帮我：
1. 总结最重要的 3 个安全问题
2. 按优先级排列修复顺序
3. 给出每个问题的具体修复步骤
4. 生成一份给非技术团队成员的安全报告」
```

---

## 6. 常见错误和解决方案

| 错误 | 风险等级 | 解决方案 |
|------|---------|---------|
| 使用默认管理员密码 | 🔴 Critical | 立即更换 + 启用 2FA |
| SSL 证书过期 | 🔴 Critical | 设置自动续期（Certbot） |
| 未做输入验证 | 🔴 Critical | 使用 Zod/ Joi 验证所有输入 |
| 敏感数据明文存储 | 🔴 Critical | 加密存储 + 环境变量 |
| 公开 .env 文件 | 🟠 High | 检查 .gitignore + 扫描 GitHub |
| 过时的依赖包 | 🟠 High | 定期运行 npm audit |
| 未配置速率限制 | 🟡 Medium | 所有 API 端点加限流 |
| 缺少安全头 | 🟡 Medium | 使用 Helmet 自动配置 |
| 未做备份恢复测试 | 🔵 Low | 每季度做一次恢复演练 |

---

## 7. 实战练习

### 练习：安全加固 Checklist

**任务**：
1. 对你的独立站进行全面安全审计
2. 修复所有 Critical 和 High 级别问题
3. 配置 HTTPS + 安全头
4. 设置自动备份
5. 运行 Lighthouse Security 审计

**工具推荐**：
- [securityheaders.com](https://securityheaders.com) — 安全头检测
- [ssllabs.com](https://www.ssllabs.com/ssltest/) — SSL 评级
- [npm audit](https://docs.npmjs.com/cli/v10/commands/npm-audit) — 依赖漏洞扫描
- [snyk.io](https://snyk.io) — 代码安全扫描

---

## 8. 关键要点总结

> **核心记忆点：**
> 1. HTTPS 是标配，不是选项
> 2. 密码永远不要明文存储，使用 bcrypt 哈希
> 3. 所有用户输入都要验证和净化
> 4. 启用双因素认证保护管理后台
> 5. 遵循 3-2-1 备份原则
> 6. 定期扫描依赖漏洞（npm audit / Dependabot）
> 7. AI 可以辅助安全审计，但不能替代专业工具
> 8. 安全是持续过程，不是一次性工作
