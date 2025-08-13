# Crayon - SwiftUI 动态 UI 渲染框架

![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)
![Language](https://img.shields.io/badge/language-Swift-orange.svg)
![Framework](https://img.shields.io/badge/framework-SwiftUI-green.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)

[中文文档](README_CN.md) | [English](README.md)

Crayon 是一个基于 SwiftUI 的动态 UI 渲染框架，允许开发者通过 JSON 配置动态构建和渲染用户界面。该框架支持服务端驱动 UI (SDUI) 模式，提供了灵活的组件系统、状态管理和动作处理机制。

## 📋 目录

- [特性](#特性)
- [系统要求](#系统要求)
- [快速开始](#快速开始)
- [架构概览](#架构概览)
- [核心组件](#核心组件)
- [JSON 配置格式](#json-配置格式)
- [使用示例](#使用示例)
- [自定义组件](#自定义组件)
- [状态管理](#状态管理)
- [动作系统](#动作系统)
- [JavaScript 集成](#javascript-集成)
- [API 文档](#api-文档)
- [贡献指南](#贡献指南)

## ✨ 特性

- 🎨 **动态 UI 渲染**: 通过 JSON 配置动态构建 SwiftUI 界面
- 🧩 **丰富的组件库**: 内置多种 UI 组件 (Text, Button, TextField, Image 等)
- 🔄 **状态管理**: 响应式状态管理和数据绑定
- ⚡ **动作系统**: 灵活的事件处理和动作执行机制
- 🌐 **JavaScript 集成**: 支持 JavaScript 脚本动态生成 UI
- 📱 **原生性能**: 基于 SwiftUI，保持原生应用的性能和体验
- 🎯 **类型安全**: 完全基于 Swift 类型系统，编译时类型检查
- 🔧 **可扩展**: 易于添加自定义组件和动作处理器

## 📱 系统要求

- iOS 18.5+
- Xcode 16.4+
- Swift 5.0+
- SwiftUI 支持

## 🚀 快速开始

### 安装

1. 克隆项目：
```bash
git clone https://github.com/LeetaoGoooo/Crayon.git
cd Crayon
```

2. 使用 Xcode 打开项目：
```bash
open Crayon.xcodeproj
```

3. 构建并运行项目

### 基本使用

```swift
import SwiftUI

struct ContentView: View {
    @State private var rootNode: UINode?
    
    var body: some View {
        VStack {
            if let node = rootNode {
                DynamicViewRenderer(node: node)
            } else {
                ProgressView()
                    .onAppear(perform: loadUI)
            }
        }
    }
    
    func loadUI() {
        // 从 JSON 加载 UI 配置
        let jsonData = loadUIConfigFromJSON()
        self.rootNode = try? JSONDecoder().decode(UINode.self, from: jsonData)
    }
}
```

## 🏗️ 架构概览

Crayon 采用分层架构设计，主要包含以下几个核心层：

```
┌─────────────────────────────────────┐
│            SwiftUI 视图层            │
├─────────────────────────────────────┤
│            组件渲染层               │
│  • DynamicViewRenderer              │
│  • SduiRenderer                     │
├─────────────────────────────────────┤
│            组件库层                 │
│  • SduiText, SduiButton             │
│  • SduiTextField, SduiImage         │
├─────────────────────────────────────┤
│            状态管理层               │
│  • SduiStateManager                 │
│  • 响应式数据绑定                   │
├─────────────────────────────────────┤
│            动作处理层               │
│  • ActionHandler                    │
│  • ActionInterpreter                │
├─────────────────────────────────────┤
│            数据模型层               │
│  • UINode, ComponentNode            │
│  • Props, Actions                   │
├─────────────────────────────────────┤
```

## 🧩 核心组件

### 渲染器组件

- **DynamicViewRenderer**: 基础动态视图渲染器
- **SduiRenderer**: 高级 SDUI 组件渲染器

### UI 组件

- **SduiText**: 文本组件
- **SduiButton**: 按钮组件
- **SduiTextField**: 文本输入组件
- **SduiImage**: 图片组件
- **SduiIcon**: 图标组件
- **SduiPicker**: 选择器组件
- **SduiImageUploader**: 图片上传组件

### 布局组件

- **VStack**: 垂直布局
- **HStack**: 水平布局
- **Spacer**: 空间填充

## 📄 JSON 配置格式

### 基本节点结构

```json
{
  "id": "unique_id",
  "type": "ComponentType",
  "properties": {
    // 组件属性
  },
  "children": [
    // 子组件数组
  ],
  "actions": [
    // 动作配置
  ]
}
```

### 文本组件示例

```json
{
  "id": "welcome_text",
  "type": "Text",
  "properties": {
    "text": "欢迎使用 Crayon",
    "fontSize": 24,
    "fontWeight": "bold"
  }
}
```

### 按钮组件示例

```json
{
  "id": "submit_button",
  "type": "Button",
  "properties": {
    "label": {
      "id": "button_label",
      "type": "Text",
      "properties": {
        "text": "提交"
      }
    }
  },
  "actions": [
    {
      "trigger": "onClick",
      "type": "API_CALL",
      "payload": {
        "url": "https://api.example.com/submit",
        "method": "POST"
      }
    }
  ]
}
```

### 布局组件示例

```json
{
  "id": "main_layout",
  "type": "VStack",
  "properties": {
    "spacing": 16,
    "padding": 20
  },
  "children": [
    {
      "id": "title",
      "type": "Text",
      "properties": {
        "text": "标题"
      }
    },
    {
      "id": "content",
      "type": "TextField",
      "properties": {
        "placeholder": "请输入内容",
        "value": ""
      }
    }
  ]
}
```

## 🎯 使用示例

### 创建简单表单

```swift
func createFormUI() -> UINode {
    let jsonString = """
    {
      "id": "form",
      "type": "VStack",
      "properties": {
        "spacing": 16,
        "padding": 20
      },
      "children": [
        {
          "id": "title",
          "type": "Text",
          "properties": {
            "text": "用户注册",
            "fontSize": 24,
            "fontWeight": "bold"
          }
        },
        {
          "id": "name_field",
          "type": "TextField",
          "properties": {
            "placeholder": "请输入用户名",
            "value": ""
          },
          "actions": [
            {
              "trigger": "onChange",
              "type": "VALIDATE",
              "payload": {
                "field": "username"
              }
            }
          ]
        },
        {
          "id": "submit_button",
          "type": "Button",
          "properties": {
            "label": {
              "id": "submit_label",
              "type": "Text",
              "properties": {
                "text": "注册"
              }
            }
          },
          "actions": [
            {
              "trigger": "onClick",
              "type": "API_CALL",
              "payload": {
                "url": "/api/register",
                "method": "POST"
              }
            }
          ]
        }
      ]
    }
    """
    
    let jsonData = jsonString.data(using: .utf8)!
    return try! JSONDecoder().decode(UINode.self, from: jsonData)
}
```

## 🔧 自定义组件

### 创建自定义组件

```swift
struct CustomComponent: View {
    let props: CustomProps
    let style: StyleProps
    
    var body: some View {
        // 自定义组件实现
        VStack {
            Text(props.title)
                .font(.title)
            Text(props.subtitle)
                .font(.subtitle)
        }
        .applyStyle(style)
    }
}

struct CustomProps {
    let title: String
    let subtitle: String
}
```

### 注册自定义组件

```swift
// 在 SduiRenderer 中添加新的 case
case "CustomComponent":
    let customProps = CustomProps(
        title: node.props["title"]?.value as? String ?? "",
        subtitle: node.props["subtitle"]?.value as? String ?? ""
    )
    let style = StyleProps(from: node.props["style"]?.value as? [String: AnyCodable] ?? [:])
    CustomComponent(props: customProps, style: style)
```

## 📊 状态管理

### 状态绑定配置

```json
{
  "state": {
    "bindings": {
      "userName": {
        "key": "userName",
        "type": "string",
        "defaultValue": "",
        "computed": false
      },
      "isValid": {
        "key": "isValid",
        "type": "boolean",
        "defaultValue": false,
        "computed": true,
        "expression": "userName.length > 3"
      }
    },
    "watchers": [
      {
        "key": "userName",
        "action": {
          "trigger": "change",
          "type": "VALIDATE",
          "payload": {
            "field": "userName"
          }
        }
      }
    ]
  }
}
```

### 使用状态值

```json
{
  "id": "text_field",
  "type": "TextField",
  "properties": {
    "text": "@state:userName",
    "placeholder": "请输入用户名"
  }
}
```

## ⚡ 动作系统

### 支持的动作类型

- **API_CALL**: API 调用
- **NAVIGATION**: 页面导航
- **JAVASCRIPT**: JavaScript 脚本执行
- **SHARE**: 内容分享
- **STATE_UPDATE**: 状态更新

### 动作处理示例

```swift
class CustomActionHandler: ActionHandling {
    func handle(_ action: Action) {
        switch action.type {
        case "CUSTOM_ACTION":
            handleCustomAction(action)
        default:
            ActionInterpreter.shared.handle(action)
        }
    }
    
    private func handleCustomAction(_ action: Action) {
        // 自定义动作处理逻辑
        print("处理自定义动作: \(action)")
    }
}
```

## 🌐 JavaScript 集成

### JavaScript 脚本示例

```javascript
function render(data) {
    return {
        id: "dynamic_ui",
        type: "VStack",
        properties: {
            spacing: 16
        },
        children: data.items.map((item, index) => ({
            id: `item_${index}`,
            type: "Text",
            properties: {
                text: item.title
            }
        }))
    };
}
```

### 使用 JSEngine

```swift
let jsEngine = JSEngine()
let script = loadJavaScriptFromFile()
let data = ["items": [["title": "Item 1"], ["title": "Item 2"]]]

if let jsonString = jsEngine.generateUIJson(from: script, with: data) {
    let jsonData = jsonString.data(using: .utf8)!
    let uiNode = try JSONDecoder().decode(UINode.self, from: jsonData)
    // 渲染 UI
}
```

## 📚 API 文档

### 核心类

#### UINode
主要的 UI 节点数据模型

```swift
class UINode: Codable, Identifiable, Hashable {
    let id: String
    let type: ComponentType
    var properties: UIProperties?
    var children: [UINode]?
    var actions: [UIAction]?
}
```

#### SduiStateManager
状态管理器

```swift
class SduiStateManager: ObservableObject {
    func setValue<T>(_ key: String, value: T)
    func getValue<T>(_ key: String) -> T?
    func getState() -> [String: Any]
}
```

#### ActionInterpreter
动作解释器

```swift
class ActionInterpreter: ActionHandling {
    static let shared: ActionInterpreter
    func handle(_ action: Action)
}
```

### 组件属性

#### StyleProps
样式属性配置

```swift
struct StyleProps {
    var foregroundColor: Color?
    var backgroundColor: Color?
    var fontSize: CGFloat?
    var padding: CGFloat?
    var cornerRadius: CGFloat?
}
```

## 🔄 工作流程

1. **JSON 配置**: 定义 UI 结构和行为
2. **解析**: 将 JSON 解析为 UINode 对象
3. **渲染**: 使用 DynamicViewRenderer 渲染 SwiftUI 视图
4. **交互**: 处理用户交互和动作执行
5. **状态更新**: 响应式更新 UI 状态

## 📁 项目结构

```
Crayon/
├── Components/          # UI 组件库
│   ├── SduiText.swift
│   ├── SduiButton.swift
│   ├── SduiTextField.swift
│   └── ...
├── Models/             # 数据模型
│   └── UINode.swift
├── Views/              # 视图层
│   └── DynamicViewRenderer.swift
├── ViewModel/          # 视图模型
│   └── ActionHandler.swift
├── JSEngine/           # JavaScript 引擎
│   └── JSEngine.swift
├── Extension/          # 扩展
│   ├── Color+Extension.swift
│   └── View+Extension.swift
└── Tools/              # 工具类
    └── Log.swift
```

## 🧪 测试

项目包含单元测试和 UI 测试：

```bash
# 运行单元测试
xcodebuild test -scheme Crayon -destination 'platform=iOS Simulator,name=iPhone 15'

# 运行 UI 测试
xcodebuild test -scheme CrayonUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🛠️ 开发指南

### 添加新组件

1. 在 `Components/` 目录下创建新的组件文件
2. 定义组件的 Props 结构
3. 实现 SwiftUI View
4. 在 `SduiRenderer` 中注册新组件
5. 更新 JSON 配置文档

### 添加新动作

1. 在 `ActionInterpreter` 中添加新的动作类型
2. 实现动作处理逻辑
3. 更新动作文档

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📝 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 👥 维护者

- [@LeetaoGoooo](https://github.com/LeetaoGoooo)

## 🔗 相关链接

- [SwiftUI 官方文档](https://developer.apple.com/documentation/swiftui/)
- [Server-Driven UI 概念](https://www.airbnb.com/blog/a-deep-dive-into-airbnbs-server-driven-ui-system)

## 📮 反馈

如果您有任何问题或建议，请通过以下方式联系我们：

- 提交 [Issue](https://github.com/LeetaoGoooo/Crayon/issues)
- 发送邮件至 [your-email@example.com]

---

**Happy Coding with Crayon! 🎨**
