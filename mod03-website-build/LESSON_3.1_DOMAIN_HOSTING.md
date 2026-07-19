# Lesson 3.1: 域名与主机选择

## 学习目标
1. 学会选择合适的域名注册商和主机方案
2. 理解不同托管方案的优劣
3. 掌握DNS配置和SSL证书

## 1. 域名选择策略

### 域名类型对比
| 类型 | 示例 | 价格/年 | 适用场景 |
|------|------|---------|---------|
| .com | example.com | \-15 | 首选，全球认可 |
| .net | example.net | \-15 | 技术类产品 |
| .io | example.io | \-50 | 科技公司 |
| .ai | example.ai | \-150 | AI相关产品 |
| .cn | example.cn | \-50 | 中国市场 |

### 域名命名原则
1. **简短易记** — 不超过15个字符
2. **易于拼写** — 避免连字符和数字
3. **包含关键词** — 有助于SEO
4. **避免歧义** — 不同语言发音一致

### 推荐注册商
| 注册商 | 价格 | 隐私保护 | 特点 |
|--------|------|---------|------|
| Namecheap | \.88/.com | 免费 | 性价比高 |
| Cloudflare | \.15/.com | 免费 | 无加价 |
| Porkbun | \.67/.com | 免费 | 界面友好 |
| GoDaddy | \.99/.com | \.99/年 | 促销价低但续费贵 |

## 2. 主机方案对比

### 方案一：Vercel/Netlify (推荐新手)
`
优点：
- 免费套餐足够个人项目
- 自动HTTPS
- Git集成，一键部署
- 全球CDN

缺点：
- 自定义服务器限制
- 不适合大型应用

价格：免费 ~ \/月
`

### 方案二：Cloudflare Pages
`
优点：
- 完全免费
- 无限带宽
- 与Cloudflare DNS集成

缺点：
- 功能相对简单
- 构建时间限制

价格：免费
`

### 方案三：DigitalOcean/VPS
`
优点：
- 完全控制服务器
- 可运行任何软件

缺点：
- 需要运维知识
- 安全风险自负

价格：\-20/月
`

### 方案四：Shared Hosting
`
优点：
- 便宜
- 控制面板友好

缺点：
- 性能有限
- 共享IP可能被屏蔽

价格：\-10/月
`

## 3. DNS配置

### 基本DNS记录
`
记录类型：
- A记录：域名 -> IP地址
- CNAME：域名 -> 域名
- MX记录：邮件服务器
- TXT记录：域名验证

示例配置：
@        A    192.0.2.1
www      CNAME example.com
mail     MX    mail.example.com
_dmarc   TXT   v=DMARC1; p=reject;
`

### Cloudflare配置步骤
1. 注册Cloudflare账号
2. 添加站点，选择免费计划
3. 更改域名DNS服务器为Cloudflare提供的NS
4. 等待DNS传播（通常几分钟）
5. 启用SSL（Full模式）
6. 启用CDN和缓存规则

## 4. SSL证书

### 免费SSL选项
- Let's Encrypt（自动续期）
- Cloudflare Universal SSL
- Vercel/Netlify自动SSL

### 配置HTTPS
`
ginx
# Nginx配置示例
server {
    listen 443 ssl http2;
    server_name example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
    
    # 强制HTTPS
    return 301 https://\System.Management.Automation.Internal.Host.InternalHost\;
}
`

## 5. 实战：配置你的第一个网站

### 步骤1：注册域名
`ash
# 使用Namecheap命令行（如果支持）
# 或在网页上注册
# 推荐：example-ai-tools.com
`

### 步骤2：创建Vercel项目
`ash
# 安装Vercel CLI
npm i -g vercel

# 创建Next.js项目
npx create-next-app@latest ai-tools-blog
cd ai-tools-blog

# 部署到Vercel
vercel
`

### 步骤3：绑定域名
`
1. 在Vercel项目设置中添加域名
2. 按照提示配置DNS记录
3. 等待SSL证书签发
4. 测试https://yourdomain.com
`

## 6. 练习作业

1. 注册一个你的项目域名
2. 在Vercel上部署一个静态网站
3. 配置自定义域名和HTTPS

## 关键要点
1. **.com域名是首选** — 即使其他类型更便宜
2. **Vercel/Netlify适合大多数项目** — 免费且易用
3. **Cloudflare是必装的** — CDN + SSL + DDoS防护
4. **尽早配置HTTPS** — 搜索引擎偏好安全网站
