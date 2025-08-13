# Crayon - SwiftUI Dynamic UI Rendering Framework

![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)
![Language](https://img.shields.io/badge/language-Swift-orange.svg)
![Framework](https://img.shields.io/badge/framework-SwiftUI-green.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)

[中文文档](README_CN.md) | [English](README.md)

Crayon is a SwiftUI-based dynamic UI rendering framework that allows developers to dynamically build and render user interfaces through JSON configuration. The framework supports Server-Driven UI (SDUI) patterns, providing a flexible component system, state management, and action handling mechanisms.

## 📋 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Architecture Overview](#architecture-overview)
- [Core Components](#core-components)
- [JSON Configuration Format](#json-configuration-format)
- [Usage Examples](#usage-examples)
- [Custom Components](#custom-components)
- [State Management](#state-management)
- [Action System](#action-system)
- [JavaScript Integration](#javascript-integration)
- [API Documentation](#api-documentation)
- [Contributing](#contributing)

## ✨ Features

- 🎨 **Dynamic UI Rendering**: Build SwiftUI interfaces dynamically through JSON configuration
- 🧩 **Rich Component Library**: Built-in UI components (Text, Button, TextField, Image, etc.)
- 🔄 **State Management**: Reactive state management and data binding
- ⚡ **Action System**: Flexible event handling and action execution mechanisms
- 🌐 **JavaScript Integration**: Support for JavaScript scripts to generate UI dynamically
- 📱 **Native Performance**: Based on SwiftUI, maintaining native app performance and experience
- 🎯 **Type Safety**: Fully based on Swift type system with compile-time type checking
- 🔧 **Extensible**: Easy to add custom components and action handlers

## 📱 Requirements

- iOS 18.5+
- Xcode 16.4+
- Swift 5.0+
- SwiftUI support

## 🚀 Quick Start

### Installation

1. Clone the project:
```bash
git clone https://github.com/LeetaoGoooo/Crayon.git
cd Crayon
```

2. Open the project with Xcode:
```bash
open Crayon.xcodeproj
```

3. Build and run the project

### Basic Usage

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
        // Load UI configuration from JSON
        let jsonData = loadUIConfigFromJSON()
        self.rootNode = try? JSONDecoder().decode(UINode.self, from: jsonData)
    }
}
```

## 🏗️ Architecture Overview

Crayon adopts a layered architecture design, mainly including the following core layers:

```
┌─────────────────────────────────────┐
│            SwiftUI View Layer        │
├─────────────────────────────────────┤
│          Component Rendering Layer   │
│  • DynamicViewRenderer              │
│  • SduiRenderer                     │
├─────────────────────────────────────┤
│            Component Library Layer   │
│  • SduiText, SduiButton             │
│  • SduiTextField, SduiImage         │
├─────────────────────────────────────┤
│            State Management Layer    │
│  • SduiStateManager                 │
│  • Reactive Data Binding            │
├─────────────────────────────────────┤
│            Action Handling Layer     │
│  • ActionHandler                    │
│  • ActionInterpreter                │
├─────────────────────────────────────┤
│            Data Model Layer          │
│  • UINode, ComponentNode            │
│  • Props, Actions                   │
├─────────────────────────────────────┤
```

## 🧩 Core Components

### Renderer Components

- **DynamicViewRenderer**: Basic dynamic view renderer
- **SduiRenderer**: Advanced SDUI component renderer

### UI Components

- **SduiText**: Text component
- **SduiButton**: Button component
- **SduiTextField**: Text input component
- **SduiImage**: Image component
- **SduiIcon**: Icon component
- **SduiPicker**: Picker component
- **SduiImageUploader**: Image upload component

### Layout Components

- **VStack**: Vertical layout
- **HStack**: Horizontal layout
- **Spacer**: Space filler

## 📄 JSON Configuration Format

### Basic Node Structure

```json
{
  "id": "unique_id",
  "type": "ComponentType",
  "properties": {
    // Component properties
  },
  "children": [
    // Child components array
  ],
  "actions": [
    // Action configurations
  ]
}
```

### Text Component Example

```json
{
  "id": "welcome_text",
  "type": "Text",
  "properties": {
    "text": "Welcome to Crayon",
    "fontSize": 24,
    "fontWeight": "bold"
  }
}
```

### Button Component Example

```json
{
  "id": "submit_button",
  "type": "Button",
  "properties": {
    "label": {
      "id": "button_label",
      "type": "Text",
      "properties": {
        "text": "Submit"
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

### Layout Component Example

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
        "text": "Title"
      }
    },
    {
      "id": "content",
      "type": "TextField",
      "properties": {
        "placeholder": "Enter content",
        "value": ""
      }
    }
  ]
}
```

## 🎯 Usage Examples

### Creating a Simple Form

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
            "text": "User Registration",
            "fontSize": 24,
            "fontWeight": "bold"
          }
        },
        {
          "id": "name_field",
          "type": "TextField",
          "properties": {
            "placeholder": "Enter username",
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
                "text": "Register"
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

## 🔧 Custom Components

### Creating Custom Components

```swift
struct CustomComponent: View {
    let props: CustomProps
    let style: StyleProps
    
    var body: some View {
        // Custom component implementation
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

### Registering Custom Components

```swift
// Add new case in SduiRenderer
case "CustomComponent":
    let customProps = CustomProps(
        title: node.props["title"]?.value as? String ?? "",
        subtitle: node.props["subtitle"]?.value as? String ?? ""
    )
    let style = StyleProps(from: node.props["style"]?.value as? [String: AnyCodable] ?? [:])
    CustomComponent(props: customProps, style: style)
```

## 📊 State Management

### State Binding Configuration

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

### Using State Values

```json
{
  "id": "text_field",
  "type": "TextField",
  "properties": {
    "text": "@state:userName",
    "placeholder": "Enter username"
  }
}
```

## ⚡ Action System

### Supported Action Types

- **API_CALL**: API calls
- **NAVIGATION**: Page navigation
- **JAVASCRIPT**: JavaScript script execution
- **SHARE**: Content sharing
- **STATE_UPDATE**: State updates

### Action Handling Example

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
        // Custom action handling logic
        print("Handling custom action: \(action)")
    }
}
```

## 🌐 JavaScript Integration

### JavaScript Script Example

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

### Using JSEngine

```swift
let jsEngine = JSEngine()
let script = loadJavaScriptFromFile()
let data = ["items": [["title": "Item 1"], ["title": "Item 2"]]]

if let jsonString = jsEngine.generateUIJson(from: script, with: data) {
    let jsonData = jsonString.data(using: .utf8)!
    let uiNode = try JSONDecoder().decode(UINode.self, from: jsonData)
    // Render UI
}
```

## 📚 API Documentation

### Core Classes

#### UINode
Main UI node data model

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
State manager

```swift
class SduiStateManager: ObservableObject {
    func setValue<T>(_ key: String, value: T)
    func getValue<T>(_ key: String) -> T?
    func getState() -> [String: Any]
}
```

#### ActionInterpreter
Action interpreter

```swift
class ActionInterpreter: ActionHandling {
    static let shared: ActionInterpreter
    func handle(_ action: Action)
}
```

### Component Properties

#### StyleProps
Style property configuration

```swift
struct StyleProps {
    var foregroundColor: Color?
    var backgroundColor: Color?
    var fontSize: CGFloat?
    var padding: CGFloat?
    var cornerRadius: CGFloat?
}
```

## 🔄 Workflow

1. **JSON Configuration**: Define UI structure and behavior
2. **Parsing**: Parse JSON into UINode objects
3. **Rendering**: Use DynamicViewRenderer to render SwiftUI views
4. **Interaction**: Handle user interactions and action execution
5. **State Updates**: Reactive UI state updates

## 📁 Project Structure

```
Crayon/
├── Components/          # UI Component Library
│   ├── SduiText.swift
│   ├── SduiButton.swift
│   ├── SduiTextField.swift
│   └── ...
├── Models/             # Data Models
│   └── UINode.swift
├── Views/              # View Layer
│   └── DynamicViewRenderer.swift
├── ViewModel/          # View Models
│   └── ActionHandler.swift
├── JSEngine/           # JavaScript Engine
│   └── JSEngine.swift
├── Extension/          # Extensions
│   ├── Color+Extension.swift
│   └── View+Extension.swift
└── Tools/              # Utility Classes
    └── Log.swift
```

## 🧪 Testing

The project includes unit tests and UI tests:

```bash
# Run unit tests
xcodebuild test -scheme Crayon -destination 'platform=iOS Simulator,name=iPhone 15'

# Run UI tests
xcodebuild test -scheme CrayonUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🛠️ Development Guide

### Adding New Components

1. Create a new component file in the `Components/` directory
2. Define the component's Props structure
3. Implement the SwiftUI View
4. Register the new component in `SduiRenderer`
5. Update JSON configuration documentation

### Adding New Actions

1. Add new action type in `ActionInterpreter`
2. Implement action handling logic
3. Update action documentation

## 🤝 Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## 👥 Maintainers

- [@LeetaoGoooo](https://github.com/LeetaoGoooo)

## 🔗 Related Links

- [SwiftUI Official Documentation](https://developer.apple.com/documentation/swiftui/)
- [Server-Driven UI Concept](https://www.airbnb.com/blog/a-deep-dive-into-airbnbs-server-driven-ui-system)

## 📮 Feedback

If you have any questions or suggestions, please contact us through:

- Submit an [Issue](https://github.com/LeetaoGoooo/Crayon/issues)
- Send an email to [your-email@example.com]

---

**Happy Coding with Crayon! 🎨**
