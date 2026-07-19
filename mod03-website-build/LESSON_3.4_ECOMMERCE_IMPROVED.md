# Lesson 3.4: 电商网站搭建（完整版）

## 学习目标
1. 理解电商平台选型的核心决策维度
2. 掌握 Shopify、WooCommerce、自建站三种模式的利弊
3. 学会用 AI 优化产品页面转化率
4. 独立完成一个可运营的电商站点

---

## 1. 电商模式选型决策树

```
你要卖什么？
├── 实体商品（实物发货）
│   ├── 有供应链？ → WooCommerce / 自建
│   └── 无供应链？ → Shopify + Dropshipping
├── 数字产品（下载/授权）
│   ├── 简单销售？ → Gumroad / Lemon Squeezy
│   └── 品牌化运营？ → Shopify / WooCommerce
├── SaaS 服务
│   ├── 短期 MVP？ → Stripe Payment Links
│   └── 长期运营？ → 自建 + Stripe
└── 混合模式
    └── Shopify（功能最全面）
```

### 三种模式深度对比

| 维度 | Shopify | WooCommerce | 自建站 (Next.js) |
|------|---------|-------------|-----------------|
| 月费 | $29-$299 | $0（插件免费） | $0（开源） |
| 交易费 | 0.5%-2% | 0% | 0% |
| 支付手续费 | 2.9%+$0.30 | 同左 | 同左 |
| 上手时间 | 30 分钟 | 2-4 小时 | 1-2 周 |
| 定制能力 | 中 | 高 | 极高 |
| 性能 | 优秀 | 取决于主机 | 优秀 |
| SEO | 良好 | 优秀 | 优秀 |
| 适合人群 | 非技术卖家 | 有 WP 经验 | 开发者 |

---

## 2. Shopify 深度搭建指南

### 2.1 为什么独立开发者首选 Shopify？

**数据支撑**：
- Shopify 平台 GMV 2024 年达到 **$3900 亿**
- 全球每 **30 秒**新开一个 Shopify 商店
- App Store 拥有 **8,000+** 电商应用
- 平均店主月收入 **$1,500-$5,000**（Shopify 数据）

**独立开发者优势**：
```
1. Hydrogen + Oxygen：Shopify 的 Headless 方案
   - 用 React/Next.js 构建前端
   - 自动部署到 Vercel
   - 保留 Shopify 的支付和库存管理

2. Shopify Functions：自定义业务逻辑
   - 修改结账流程
   - 自定义折扣规则
   - 定制配送计算

3. Liquid + GraphQL：灵活的主题开发
   - 完全控制前端展示
   - 实时库存和产品信息
```

### 2.2 Hydrogen 项目实战

```bash
# 安装 Hydrogen 脚手架
npm create @shopify/hydrogen@latest my-store

# 项目结构
my-store/
├── app/
│   ├── routes/                 # Next.js 风格路由
│   │   ├── index.tsx           # 首页
│   │   ├── products/
│   │   │   ├── $query.ts       # 产品查询
│   │   │   └── [handle].tsx    # 产品详情页
│   │   └── cart/
│   │       └── [id].tsx        # 购物车
│   ├── components/
│   │   ├── ProductCard.tsx     # 产品卡片
│   │   ├── CartDrawer.tsx      # 侧边购物车
│   │   └── Reviews.tsx         # 评论组件
│   ├── shopify.ts              # Shopify API 配置
│   └── root.tsx                # 根布局
├── public/                     # 静态资源
└── hydrogen.config.ts          # 构建配置
```

```typescript
// app/routes/products/[handle].tsx — 产品详情页
import { useQuery } from '@shopify/hydrogen';

// 使用 AI 生成的产品查询
const PRODUCT_QUERY = `#graphql
  fragment ProductOnProductPage on Product {
    id
    title
    description
    handle
    priceRange {
      minVariantPrice { amount currencyCode }
    }
    images(first: 5) {
      nodes {
        id
        url
        altText
        width
        height
      }
    }
    variants(first: 10) {
      nodes {
        id
        title
        selectedOptions { name value }
        price { amount currencyCode }
        compareAtPrice { amount currencyCode }
        availableForSale
      }
    }
    seo { title description }
  }
  query Product($handle: String!, $country: CountryCode)
    @inContext(country: $country)
    @cacheControl(duration: 21600) {
    product(handle: $handle) {
      ...ProductOnProductPage
    }
  }
`;

export async function loader({ params, request, context }) {
  const { product } = await context.shopify.query(PRODUCT_QUERY, {
    variables: { handle: params.handle },
  });
  return { product };
}

export default function ProductPage({ loaderData }) {
  const { product } = loaderData;

  // 使用 AI 生成的结构化数据
  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'Product',
    name: product.title,
    description: product.description,
    image: product.images.nodes.map(img => img.url),
    offers: {
      '@type': 'AggregateOffer',
      priceCurrency: product.priceRange.minVariantPrice.currencyCode,
      lowPrice: product.priceRange.minVariantPrice.amount,
      offerCount: product.variants.nodes.filter(v => v.availableForSale).length,
    },
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />

      <div className="product-page">
        <div className="product-gallery">
          {product.images.nodes.map((img) => (
            <img key={img.id} src={img.url} alt={img.altText || product.title} />
          ))}
        </div>

        <div className="product-info">
          <h1>{product.title}</h1>
          <p className="price">${product.priceRange.minVariantPrice.amount}</p>
          <div className="description" dangerouslySetInnerHTML={{ __html: product.description }} />

          {product.variants.nodes.map(variant => (
            <button
              key={variant.id}
              disabled={!variant.availableForSale}
              onClick={() => addToCart(variant.id)}
            >
              {variant.title} - ${variant.price.amount}
            </button>
          ))}
        </div>
      </div>
    </>
  );
}
```

---

## 3. WooCommerce 电商实战

### 3.1 核心配置

```php
<?php
// woocommerce-custom.php — 用 AI 生成的 WooCommerce 自定义代码

// 1. 自定义结账字段
add_filter('woocommerce_checkout_fields', 'custom_checkout_fields');
function custom_checkout_fields($fields) {
    // 添加生日字段（用于个性化营销）
    $fields['billing']['billing_birthdate'] = array(
        'label'       => '出生日期（可选）',
        'description' => '帮助我们为您提供个性化推荐',
        'type'        => 'date',
        'required'    => false,
        'class'       => array('form-row-wide'),
    );
    return $fields;
}

// 2. 批量产品价格调整（AI 动态定价）
add_action('woocommerce_before_calculate_totals', 'dynamic_pricing');
function dynamic_pricing($cart) {
    if (is_admin() && !defined('DOING_AJAX')) return;

    foreach ($cart->get_cart() as $cart_item) {
        $product = $cart_item['data'];
        $quantity = $cart_item['quantity'];

        // 阶梯定价：买越多越便宜
        if ($quantity >= 10) {
            $new_price = $product->get_price() * 0.8;  // 20% 折扣
        } elseif ($quantity >= 5) {
            $new_price = $product->get_price() * 0.9;  // 10% 折扣
        } else {
            $new_price = $product->get_price();
        }

        $product->set_price($new_price);
    }
}

// 3. 自动生成产品描述（集成 AI API）
add_action('add_meta_boxes', 'ai_description_meta_box');
function ai_description_meta_box() {
    add_meta_box(
        'ai-description',
        'AI 生成产品描述',
        'render_ai_description_box',
        'product'
    );
}

function render_ai_description_box($post) {
    wp_nonce_field('ai_description_action', 'ai_description_nonce');
    ?>
    <textarea id="ai-description-textarea" rows="8" cols="50"
              placeholder="输入产品关键词，AI 将自动生成描述..."></textarea>
    <button type="button" id="generate-ai-description">生成描述</button>
    <script>
    jQuery('#generate-ai-description').click(function() {
        const keywords = jQuery('#ai-description-textarea').val();
        fetch('/wp-admin/admin-ajax.php', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({
                action: 'generate_product_description',
                keywords: keywords,
                nonce: '<?php echo wp_create_nonce("ai_description_nonce"); ?>'
            })
        }).then(r => r.json()).then(data => {
            jQuery('#description').val(data.description);
        });
    });
    </script>
    <?php
}

add_action('wp_ajax_generate_product_description', 'ajax_generate_description');
function ajax_generate_description() {
    check_ajax_referer('ai_description_nonce', 'nonce');

    $keywords = sanitize_text_field($_POST['keywords']);

    // 调用 OpenAI API
    $prompt = "请为以下产品生成一段 200 字的营销描述，突出产品优势和使用场景：$keywords";

    $response = wp_remote_post('https://api.openai.com/v1/chat/completions', [
        'headers' => [
            'Authorization' => 'Bearer YOUR_API_KEY',
            'Content-Type' => 'application/json',
        ],
        'body' => json_encode([
            'model' => 'gpt-4o-mini',
            'messages' => [['role' => 'user', 'content' => $prompt]],
            'max_tokens' => 500,
        ]),
    ]);

    $body = json_decode(wp_remote_retrieve_body($response), true);
    $description = $body['choices'][0]['message']['content'] ?? '';

    wp_send_json(['description' => $description]);
}
```

---

## 4. 支付集成

### 4.1 Stripe 集成（自建站推荐）

```typescript
// app/api/create-checkout/route.ts
import { Stripe } from 'stripe';
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

export async function POST(request: Request) {
  const { items, customerId } = await request.json();

  // 创建 Stripe Checkout Session
  const session = await stripe.checkout.sessions.create({
    payment_method_types: ['card', 'alipay', 'wechat_pay'],
    line_items: items.map((item: any) => ({
      price_data: {
        currency: 'usd',
        product_data: {
          name: item.name,
          description: item.description,
          images: [item.imageUrl],
        },
        unit_amount: item.price * 100, // 以分为单位
      },
      quantity: item.quantity,
    })),
    mode: 'payment',
    customer: customerId,
    success_url: `${process.env.SITE_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
    cancel_url: `${process.env.SITE_URL}/cart`,
    metadata: {
      customerId,
      items: JSON.stringify(items),
    },
  });

  return Response.json({ url: session.url });
}
```

### 4.2 支付转化率优化

```
支付流程优化清单：
□ 支持多种支付方式（信用卡、支付宝、微信支付、PayPal）
□ 显示安全认证标识（SSL、PCI DSS）
□ 免注册结账（Guest Checkout）
□ 显示价格明细（避免隐藏费用）
□ 提供进度指示器（3 步结账 → 显示当前步骤）
□ 移动端优化（按钮 ≥ 44px 触控区域）
□ 自动填充地址（Google Places API）
□ 失败重试提示（清晰的错误信息）

数据支撑：
- 简化结账流程可提高转化率 35%
- 显示安全徽章可提高信任度 17%
- 免注册结账可减少放弃率 20%
- 多种支付方式可增加收入 15-30%
```

---

## 5. 产品页面转化优化（AI 辅助）

### 5.1 产品页面结构

```
高转化产品页面结构：
1. Hero 区：高质量产品图 + 核心卖点（3 秒内传达价值）
2. 社会证明：评分 + 评价数量 + 已购人数
3. 痛点共鸣：「你是否遇到过...？」
4. 解决方案：我们的产品如何解决这些问题
5. 功能详情：3-5 个核心功能 + 图示
6. 对比表格：vs 竞品（突出优势）
7. 用户评价：真实用户截图 + 评价
8. FAQ：消除最后顾虑
9. CTA：明确的购买按钮 + 限时优惠
```

### 5.2 用 AI 优化产品描述

```
提示词模板：

「你是一位 Conversion Rate Optimization 专家。
请为以下产品撰写高转化率的產品描述：

产品名称：[名称]
目标用户：[用户画像]
核心功能：[功能列表]
价格：[价格]
竞品：[主要竞品]

要求：
1. 采用 PAS 框架（Problem-Agitation-Solution）
2. 开头用痛点引起共鸣
3. 每个功能都关联一个用户收益
4. 加入社会证明元素
5. 结尾有明确的行动号召
6. 语言简洁有力，避免行话
7. 字数 300-500 字」
```

---

## 6. 常见错误和解决方案

| 错误 | 后果 | 解决方案 |
|------|------|---------|
| 选择错误的平台 | 后期迁移成本高 | MVP 阶段先用 Shopify，验证后迁移 |
| 产品图片模糊 | 转化率下降 40% | 使用 AI 放大工具（Topaz Gigapixel） |
| 支付网关未配置 | 无法收款 | 提前申请 Stripe/PayPal 商户号 |
| 未做移动端测试 | 60%+ 流量流失 | 每个页面都做手机测试 |
| 忽略 SEO | 无自然流量 | 每页自定义 Title + Meta Description |
| 没有退货政策 | 信任度低 | 明确展示退换货政策 |

---

## 7. 实战练习

### 练习：搭建数字产品销售站

**任务**：
1. 选择一个数字产品（AI Prompt 模板集 / Notion 模板 / 电子书）
2. 使用 Shopify 或 WooCommerce 搭建销售页面
3. 集成 Stripe 支付
4. 用 AI 生成产品描述和营销文案
5. 设置自动交付（购买后自动发送下载链接）

**进阶**：
- 添加用户评价系统
- 实现 A/B 测试（两个不同 CTA 按钮）
- 设置邮件通知（购买确认 + 感谢邮件）

---

## 8. 关键要点总结

> **核心记忆点：**
> 1. 实体商品 → WooCommerce/Shopify；数字产品 → Gumroad/自建
> 2. Shopify 最快上线，WooCommerce 最灵活，自建最可控
> 3. Hydrogen + Oxygen 是 Shopify 的最佳开发者方案
> 4. 支付转化率优化的关键是减少摩擦
> 5. AI 可以批量生成高质量产品描述
> 6. 移动端体验决定电商成败（60%+ 流量来自手机）
> 7. 社会证明（评价、评分、已购人数）大幅提升转化
> 8. 自动化交付是数字产品的核心竞争力
