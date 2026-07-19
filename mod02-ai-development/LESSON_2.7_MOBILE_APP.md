# Lesson 2.7: 移动端App开发

## 学习目标
1. 掌握React Native/Flutter + AI开发
2. 学会热更新和OTA
3. 实战：开发一个工具类App

## 1. React Native快速开发

### 项目初始化
`ash
npx react-native init MyAIApp
cd MyAIApp
npm install @react-navigation/native
`

### AI生成首页
`
Prompt: 创建一个React Native首页，包含：
- 顶部导航栏
- 功能卡片网格(2列)
- 每个卡片有图标、标题、描述
- 底部Tab导航(首页/发现/我的)
- 支持深色模式
`

## 2. 功能模块

### AI聊天界面
`
组件：
- 消息列表(ScrollView)
- 输入框( TextInput)
- 发送按钮
- 加载动画

功能：
- 流式输出(SSE)
- 消息历史
- 快捷指令
`

## 3. 热更新

### CodePush配置
`ash
npm install react-native-code-push
`

### 更新逻辑
`javascript
import codePush from 'react-native-code-push';

const syncOptions = {
  installMode: codePush.InstallMode.ON_NEXT_RESTART,
  mandatoryInstallMode: codePush.InstallMode.IMMEDIATE,
};

codePush.sync(syncOptions);
`

## 4. 发布流程

### App Store
`
1. Xcode归档
2. TestFlight内测
3. 提交App Store审核
4. 审核通过上架
`

### Google Play
`
1. 生成APK/AAB
2. 上传Play Console
3. 填写应用信息
4. 提交审核
`

## 5. 关键要点
1. 原生体验优先
2. 离线功能必备
3. 推送通知提升留存
4. Analytics追踪关键指标
