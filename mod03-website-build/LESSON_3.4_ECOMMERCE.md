# Lesson 3.4: 电商网站搭建

## 学习目标
1. 掌握Shopify/WooCommerce/自建方案
2. 学会支付集成
3. 实战：搭建一个数字产品商店

## 1. 方案对比

### Shopify
- 月费: \
- 优势: 开箱即用
- 适合: 快速启动

### WooCommerce
- 免费(需主机)
- 优势: 灵活可控
- 适合: WordPress用户

### 自建(Stripe + Next.js)
- 成本: 仅支付费
- 优势: 完全定制
- 适合: 开发者

## 2. Stripe集成

### 支付流程
`
1. 用户选择商品
2. 创建Checkout Session
3. 跳转到Stripe支付
4. 支付成功后回调
5. 发送数字产品链接
`

### 代码示例
`	ypescript
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

export async function createCheckoutSession(priceId, userId) {
  const session = await stripe.checkout.sessions.create({
    payment_method_types: ['card'],
    line_items: [{ price: priceId, quantity: 1 }],
    mode: 'payment',
    success_url: 'https://yoursite.com/success',
    cancel_url: 'https://yoursite.com/cancel',
    metadata: { userId }
  });
  
  return session.url;
}
`

## 3. 关键要点
1. 数字产品用Stripe
2. 实物产品考虑Shopify
3. 自动化发货流程
4. 发票和税务合规
