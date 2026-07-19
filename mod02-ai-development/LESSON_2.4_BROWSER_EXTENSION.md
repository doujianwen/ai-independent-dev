# Lesson 2.4: 浏览器插件开发

## 学习目标
1. 掌握Chrome Extension Manifest V3开发
2. 学会用AI生成插件代码
3. 实战：开发一个AI写作助手插件

## 1. 插件基础结构

### Manifest V3配置
`json
{
  \"manifest_version\": 3,
  \"name\": \"AI Writing Assistant\",
  \"version\": \"1.0.0\",
  \"description\": \"AI-powered writing help for any website\",
  \"permissions\": [\"storage\", \"activeTab\"],
  \"action\": {
    \"default_popup\": \"popup.html\",
    \"default_icon\": \"icon.png\"
  },
  \"content_scripts\": [{
    \"matches\": [\"<all_urls>\"],
    \"js\": [\"content.js\"],
    \"css\": [\"content.css\"]
  }]
}
`

## 2. AI生成Popup界面

### Prompt:
`
创建一个浏览器插件的popup页面，包含：
1. 文本输入框(粘贴或选择文本)
2. 功能按钮：改写/扩写/缩写/翻译
3. 结果显示区域
4. 设置链接

样式要求：
- 简洁现代
- 暗色模式支持
- 响应式
`

### popup.html:
`html
<!DOCTYPE html>
<html>
<head>
  <link rel=\"stylesheet\" href=\"popup.css\">
</head>
<body>
  <div class=\"container\">
    <h2>AI写作助手</h2>
    
    <textarea id=\"textInput\" placeholder=\"粘贴文本到这里...\"></textarea>
    
    <div class=\"buttons\">
      <button onclick=\"rewrite()\">改写</button>
      <button onclick=\"expand()\">扩写</button>
      <button onclick=\"shorten()\">缩写</button>
      <button onclick=\"translate()\">翻译</button>
    </div>
    
    <div id=\"result\" class=\"result\"></div>
    
    <a href=\"#\" id=\"settings\">设置</a>
  </div>
  
  <script src=\"popup.js\"></script>
</body>
</html>
`

## 3. Content Script实现

### Prompt:
`
创建content.js实现：
1. 监听用户选中文本
2. 右键菜单添加\"用AI改写\"选项
3. 点击后弹出侧边栏
4. 侧边栏显示AI生成结果
5. 支持一键复制结果
`

### content.js:
`javascript
// 添加右键菜单
chrome.contextMenus.create({
  id: \"ai-rewrite\",
  title: \"用AI改写选中文本\",
  contexts: [\"selection\"]
});

// 监听右键菜单点击
chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === \"ai-rewrite\") {
    sendMessageToPopup(info.selectionText, tab.id);
  }
});

// 发送消息到popup
function sendMessageToPopup(text, tabId) {
  chrome.tabs.sendMessage(tabId, {
    action: \"rewrite\",
    text: text
  });
}

// 注入侧边栏
function injectSidebar() {
  const sidebar = document.createElement('div');
  sidebar.id = 'ai-sidebar';
  sidebar.innerHTML = \
    <div class=\"sidebar-header\">
      <h3>AI改写结果</h3>
      <button onclick=\"closeSidebar()\">×</button>
    </div>
    <div class=\"sidebar-content\" id=\"result\"></div>
    <button onclick=\"copyResult()\">复制</button>
  \;
  document.body.appendChild(sidebar);
}

function closeSidebar() {
  const sidebar = document.getElementById('ai-sidebar');
  if (sidebar) sidebar.remove();
}

function copyResult() {
  const text = document.getElementById('result').innerText;
  navigator.clipboard.writeText(text);
}
`

## 4. AI API集成

### Prompt:
`
实现AI改写功能：
1. 调用OpenAI API
2. 发送用户选中的文本
3. 返回改写结果
4. 处理加载状态和错误

使用chatgpt-api库或直接fetch。
`

### api.js:
`javascript
const OPENAI_API_KEY = 'your-api-key';

async function rewriteText(text) {
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': \Bearer \\
    },
    body: JSON.stringify({
      model: 'gpt-3.5-turbo',
      messages: [
        { role: 'system', content: '你是一个专业的文本改写助手。' },
        { role: 'user', content: \请改写以下内容，保持原意但更换表达方式：\\ }
      ],
      temperature: 0.7
    })
  });
  
  const data = await response.json();
  return data.choices[0].message.content;
}
`

## 5. 实战练习

### 练习1：广告拦截增强
`
功能：
- 显示隐藏的广告数量
- 一键屏蔽特定域名
- 统计节省的流量
`

### 练习2：密码管理器
`
功能：
- 自动生成强密码
- 存储加密密码
- 一键填充表单
- 密码强度检测
`

## 6. 发布流程
`
1. 代码测试完成
2. 准备图标和截图
3. 填写Chrome Web Store表单
4. 提交审核(1-3天)
5. 上架发布
`

## 7. 关键要点
1. **Manifest V3是标准** — 不要用V2
2. **权限最小化** — 只请求必要的权限
3. **用户体验流畅** — 加载状态要明确
4. **API密钥保护** — 不要硬编码在代码里
