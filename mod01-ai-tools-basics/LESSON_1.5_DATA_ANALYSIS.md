# Lesson 1.5: AI数据分析与可视化

## 学习目标
1. 掌握ChatGPT Code Interpreter和Claude Artifacts的数据分析能力
2. 学会用AI自动化数据处理和报表生成
3. 实战：分析一份电商销售数据并生成可视化报告

## 1. AI数据分析工具概览

### ChatGPT Code Interpreter
- **能力**: Python代码执行，文件上传下载
- **适合**: 数据清洗、统计分析、可视化
- **限制**: 免费用户有大小限制

### Claude Artifacts
- **能力**: 实时代码执行，HTML/React渲染
- **适合**: 交互式仪表板，快速原型
- **优势**: 长上下文，适合大数据集

### Python + AI
- **库**: pandas, matplotlib, seaborn, plotly
- **优势**: 完全可控，可重复
- **适合**: 复杂分析，生产环境

## 2. 数据清洗实战

### 场景：电商销售数据清洗

**上传文件**: sales_data.csv (包含10,000条销售记录)

**Prompt**:
`
请帮我分析这份电商销售数据：
1. 检查数据质量问题（缺失值、重复值、异常值）
2. 清理数据并保存干净版本
3. 生成数据质量报告

主要字段:
- order_id: 订单号
- customer_id: 客户ID
- product_category: 产品类别
- quantity: 数量
- unit_price: 单价
- total_amount: 总金额
- order_date: 订单日期
- region: 地区
`

**AI生成的Python代码**:
`python
import pandas as pd
import numpy as np

# 加载数据
df = pd.read_csv('sales_data.csv')

# 数据质量检查
print('数据集形状:', df.shape)
print('\\n缺失值:')
print(df.isnull().sum())
print('\\n数据类型:')
print(df.dtypes)
print('\\n基本统计:')
print(df.describe())

# 清理重复订单
df = df.drop_duplicates(subset=['order_id'])

# 处理缺失值
df['quantity'] = df['quantity'].fillna(df['quantity'].median())
df['region'] = df['region'].fillna('Unknown')

# 验证计算
df['calculated_total'] = df['quantity'] * df['unit_price']
df['amount_diff'] = abs(df['total_amount'] - df['calculated_total'])
print('\\n金额差异超过1元的订单数:', (df['amount_diff'] > 1).sum())

# 保存干净数据
df.to_csv('sales_data_clean.csv', index=False)
`

## 3. 数据分析实战

### 关键指标分析

**Prompt**:
`
基于清洗后的数据，请分析：
1. 月度销售趋势
2. 各品类销售占比
3. 地区销售分布
4. 客户复购率
5. 高价值客户特征
6. 生成可视化图表
`

**AI生成的分析代码**:
`python
import matplotlib.pyplot as plt
import seaborn as sns

# 设置中文字体
plt.rcParams['font.sans-serif'] = ['SimHei']

# 1. 月度销售趋势
df['order_date'] = pd.to_datetime(df['order_date'])
df['month'] = df['order_date'].dt.to_period('M')
monthly_sales = df.groupby('month')['total_amount'].sum()

plt.figure(figsize=(12, 6))
plt.plot(monthly_sales.index.astype(str), monthly_sales.values)
plt.title('Monthly Sales Trend')
plt.xlabel('Month')
plt.ylabel('Sales Amount ($)')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('monthly_trend.png', dpi=300)

# 2. 品类销售占比
category_sales = df.groupby('product_category')['total_amount'].sum().sort_values(ascending=False)
plt.figure(figsize=(10, 6))
plt.bar(category_sales.index, category_sales.values)
plt.title('Sales by Category')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('category_sales.png', dpi=300)

# 3. 地区分布
region_sales = df.groupby('region')['total_amount'].sum().sort_values(ascending=False)
plt.figure(figsize=(10, 6))
plt.pie(region_sales.values, labels=region_sales.index, autopct='%1.1f%%')
plt.title('Sales Distribution by Region')
plt.savefig('region_distribution.png', dpi=300)

print('图表已生成!')
`

## 4. 交互式仪表板

### 使用Plotly创建交互式图表

**Prompt**:
`
请用Plotly创建一个交互式销售仪表板，包含:
1. 月度销售折线图(可筛选年份)
2. 品类销售饼图(可点击查看详情)
3. 地区热力图
4. 关键指标卡片(MRR, 转化率, 客单价)
`

**AI生成的代码**:
`python
import plotly.graph_objects as go
from plotly.subplots import make_subplots

# 创建子图
fig = make_subplots(
    rows=2, cols=2,
    subplot_titles=('Monthly Sales', 'Category Distribution',
                   'Regional Performance', 'Key Metrics'),
    specs=[[{"type": "xy"}, {"type": "pie"}],
          [{"type": "xy"}, {"type": "indicator"}]]
)

# 月度销售
fig.add_trace(
    go.Scatter(x=monthly_sales.index.astype(str),
              y=monthly_sales.values,
              name='Sales'),
    row=1, col=1
)

# 品类分布
fig.add_trace(
    go.Pie(labels=category_sales.index,
          values=category_sales.values,
          hole=.3),
    row=1, col=2
)

# 更新布局
fig.update_layout(height=800, showlegend=True)
fig.write_html('sales_dashboard.html')
print('交互式仪表板已生成: sales_dashboard.html')
`

## 5. 自动化报表

### 设置月度自动报告

**Prompt**:
`
帮我创建一个自动化月度报告脚本:
1. 读取当月销售数据
2. 计算关键指标
3. 生成对比图表(环比/同比)
4. 输出Markdown格式报告
5. 保存到指定文件夹
`

## 6. 实战练习

### 练习1：个人财务分析
`
上传你的银行流水CSV，分析:
- 月度支出趋势
- 各类别支出占比
- 异常消费提醒
- 储蓄建议
`

### 练习2：网站流量分析
`
上传Google Analytics导出文件，分析:
- 流量来源分布
- 页面浏览量趋势
- 用户行为路径
- 转化漏斗
`

## 7. 关键要点

1. **数据质量决定分析价值** — 先清洗再分析
2. **可视化胜过千言万语** — 选择合适的图表类型
3. **交互式仪表板更好用** — Plotly比静态图更有价值
4. **自动化节省时间** — 建立可重复的分析流程

## 8. 推荐资源
- [Pandas官方文档](https://pandas.pydata.org/docs/)
- [Plotly Express教程](https://plotly.com/python/plotly-express/)
- [数据可视化最佳实践](https://www.data-to-viz.com/)
