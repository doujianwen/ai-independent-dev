# Lesson 2.3: 微信小程序开发

## 学习目标
1. 掌握微信小程序开发流程
2. 学会用微信开发者工具 + AI辅助开发
3. 实战：搭建一个知识付费小程序

## 1. 小程序开发环境

### 工具准备
`
1. 微信开发者工具 (免费)
   - 下载地址: developers.weixin.qq.com
   - 包含模拟器、调试器

2. 小程序账号
   - 注册: mp.weixin.qq.com
   - 类型: 个人/企业
   - 认证费用: 300元/年(企业)

3. 云开发 (推荐)
   - 免服务器部署
   - 自带数据库
   - 免费额度足够个人项目
`

### 项目结构
`
miniprogram/
├── app.js          # 入口文件
├── app.json        # 全局配置
├── app.wxss        # 全局样式
├── pages/
│   ├── index/      # 首页
│   ├── course/     # 课程页
│   ├── payment/    # 支付页
│   └── profile/    # 个人中心
├── components/     # 自定义组件
└── utils/          # 工具函数
`

## 2. AI生成首页

### Prompt for Cursor:
`
创建一个微信小程序首页(index)，包含：
1. Banner轮播图(3张)
2. 课程分类(4个图标)
3. 热门课程列表(卡片形式)
4. 底部导航栏(首页/课程/我的)

样式要求：
- 现代化设计
- 圆角卡片
- 渐变色Banner
- 响应式布局
`

### AI生成的WXML:
`xml
<!--pages/index/index.wxml-->
<view class=\"container\">
  <!-- Banner -->
  <swiper class=\"banner\" indicator-dots autoplay circular>
    <swiper-item wx:for=\"{{banners}}\" wx:key=\"id\">
      <image src=\"{{item.url}}\" mode=\"aspectFill\"/>
    </swiper-item>
  </swiper>

  <!-- Categories -->
  <view class=\"categories\">
    <view class=\"cat-item\" wx:for=\"{{categories}}\" wx:key=\"id\">
      <image src=\"{{item.icon}}\"/>
      <text>{{item.name}}</text>
    </view>
  </view>

  <!-- Hot Courses -->
  <view class=\"courses\">
    <view class=\"section-title\">热门课程</view>
    <view class=\"course-card\" wx:for=\"{{hotCourses}}\" wx:key=\"id\">
      <image src=\"{{item.cover}}\" class=\"cover\"/>
      <view class=\"info\">
        <text class=\"title\">{{item.title}}</text>
        <text class=\"price\">￥{{item.price}}</text>
        <text class=\"students\">{{item.students}}人已学</text>
      </view>
    </view>
  </view>
</view>
`

## 3. 支付功能集成

### Prompt:
`
实现小程序支付功能：
1. 订单创建页面
2. 调用微信支付API
3. 支付结果处理
4. 订单状态更新

需要包含：
- 商品列表
- 价格计算
- 优惠券
- 支付方式选择
`

### 支付逻辑:
`javascript
// pages/payment/payment.js
Page({
  data: {
    totalAmount: 0,
    courses: []
  },

  onPay() {
    const { totalAmount } = this.data;
    
    wx.requestPayment({
      timeStamp: '',
      nonceStr: '',
      package: '',
      signType: 'MD5',
      paySign: '',
      success: (res) => {
        wx.showToast({ title: '支付成功' });
        this.navigateToCourses();
      },
      fail: (err) => {
        wx.showToast({ title: '支付失败', icon: 'none' });
      }
    });
  }
});
`

## 4. 云开发数据库

### 创建集合

**Prompt**:
`
设计云开发数据库结构：
1. courses集合 - 课程信息
2. orders集合 - 订单记录
3. users集合 - 用户信息
4. reviews集合 - 课程评价

包含必要的索引和权限设置。
`

### 云函数示例:
`javascript
// cloudfunctions/getCourses/index.js
const cloud = require('wx-server-sdk');
cloud.init();
const db = cloud.database();

exports.main = async (event, context) => {
  const { category = '', page = 1, pageSize = 10 } = event;
  
  let query = db.collection('courses');
  if (category) {
    query = query.where({ category });
  }
  
  const result = await query
    .skip((page - 1) * pageSize)
    .limit(pageSize)
    .orderBy('students', 'desc')
    .get();
    
  return result;
};
`

## 5. 实战练习

### 练习1：电商小程序
`
功能：
- 商品展示
- 购物车
- 下单支付
- 订单管理
- 物流跟踪
`

### 练习2：工具小程序
`
功能：
- AI写作助手
- 图片处理
- 二维码生成
- 计算器
`

## 6. 关键要点
1. **云开发简化部署** — 免服务器配置
2. **微信支付是核心** — 尽早测试支付流程
3. **用户体验第一** — 小程序讲究轻量快速
4. **合规很重要** — 注意内容审核和资质
