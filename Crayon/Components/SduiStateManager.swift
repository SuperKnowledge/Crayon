//
//  SduiStateBindingType.swift
//  Crayon
//
//  Created by leetao on 2025/8/10.
//


import SwiftUI
import Combine

// MARK: - State Binding Types
enum SduiStateBindingType: String, Codable {
    case string
    case number
    case boolean
    case object
    case array
}

struct SduiStateBinding: Codable {
    let key: String
    let type: SduiStateBindingType
    let defaultValue: AnyCodable?
    let computed: Bool?
    let expression: String?
}

struct SduiStateWatcher: Codable {
    let key: String
    let action: SduiAction
}

struct SduiStateConfiguration: Codable {
    let bindings: [String: SduiStateBinding]?
    let watchers: [SduiStateWatcher]?
}

class SduiStateManager: ObservableObject {
    @Published private var state: [String: Any] = [:]
    private var bindings: [String: SduiStateBinding] = [:]
    private var watchers: [SduiStateWatcher] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(configuration: SduiStateConfiguration? = nil) {
        if let config = configuration {
            initializeFromConfiguration(config)
        }
    }
    
    func initializeFromConfiguration(_ config: SduiStateConfiguration) {
        self.bindings = config.bindings ?? [:]
        self.watchers = config.watchers ?? []
        
        print("🔄 SduiStateManager: 初始化状态管理器")
        print("🔄 绑定数量: \(bindings.count)")
        
        // 初始化状态值
        for (key, binding) in bindings {
            if let computed = binding.computed, computed, binding.expression != nil {
                // 计算属性稍后会重新计算
                state[key] = binding.defaultValue?.value
                print("🔄 初始化计算属性: \(key) = \(String(describing: binding.defaultValue?.value))")
            } else {
                state[key] = binding.defaultValue?.value
                print("🔄 初始化状态值: \(key) = \(String(describing: binding.defaultValue?.value))")
            }
        }
        
        print("🔄 最终状态: \(state)")
        
        // 计算所有计算属性
        updateComputedProperties()
        
        // 设置状态变化监听
        setupStateWatching()
    }
    
    func setValue<T>(_ key: String, value: T) {
        guard let binding = bindings[key] else {
            print("Warning: No binding found for key: \(key)")
            return
        }
        
        if let computed = binding.computed, computed {
            print("Warning: Cannot set value for computed property: \(key)")
            return
        }
        
        let oldValue = state[key]
        state[key] = validateAndConvertValue(value, type: binding.type)
        
        // 触发计算属性更新
        updateComputedProperties()
        
        // 检查并触发 watchers
        checkWatchers(key: key, oldValue: oldValue, newValue: state[key])
    }
    
    func getValue<T>(_ key: String) -> T? {
        return state[key] as? T
    }
    
    func getState() -> [String: Any] {
        return state
    }
    
    private func validateAndConvertValue<T>(_ value: T, type: SduiStateBindingType) -> Any {
        switch type {
        case .string:
            return String(describing: value)
        case .number:
            if let numberValue = value as? NSNumber {
                return numberValue
            } else if let stringValue = value as? String, let doubleValue = Double(stringValue) {
                return NSNumber(value: doubleValue)
            }
            return NSNumber(value: 0)
        case .boolean:
            if let boolValue = value as? Bool {
                return boolValue
            } else if let stringValue = value as? String {
                return stringValue.lowercased() == "true"
            }
            return false
        case .object:
            return value is [String: Any] ? value : [:]
        case .array:
            return value is [Any] ? value : []
        }
    }
    
    private func updateComputedProperties() {
        for (key, binding) in bindings {
            if let computed = binding.computed, computed,
               let expression = binding.expression {
                do {
                    let result = try evaluateExpression(expression)
                    state[key] = result
                } catch {
                    print("Error computing property \(key): \(error)")
                }
            }
        }
    }
    
    private func evaluateExpression(_ expression: String) throws -> Any {
        // 简单的表达式计算器
        // 这里可以扩展为更复杂的表达式解析
        let context = state
        
        // 替换变量名为实际值
        var processedExpression = expression
        for (key, value) in context {
            let placeholder = key
            if let stringValue = value as? String {
                processedExpression = processedExpression.replacingOccurrences(of: placeholder, with: "\"\(stringValue)\"")
            } else if let numberValue = value as? NSNumber {
                processedExpression = processedExpression.replacingOccurrences(of: placeholder, with: "\(numberValue)")
            } else if let boolValue = value as? Bool {
                processedExpression = processedExpression.replacingOccurrences(of: placeholder, with: "\(boolValue)")
            }
        }
        
        // 这里应该使用更安全的表达式解析器
        // 为简化示例，这里只是返回原始表达式
        return processedExpression
    }
    
    private func setupStateWatching() {
        // 监听状态变化
        $state
            .sink { [weak self] _ in
                // 状态已经更新，watchers 在 checkWatchers 中处理
            }
            .store(in: &cancellables)
    }
    
    private func checkWatchers(key: String, oldValue: Any?, newValue: Any?) {
        // 检查值是否真的改变了
        if areEqual(oldValue, newValue) { return }
        
        for watcher in watchers {
            if watcher.key == key {
                executeAction(watcher.action, context: [
                    "oldValue": oldValue as Any,
                    "newValue": newValue as Any,
                    "key": key
                ])
            }
        }
    }
    
    private func areEqual(_ lhs: Any?, _ rhs: Any?) -> Bool {
        // 简单的相等性检查
        switch (lhs, rhs) {
        case (.none, .none):
            return true
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as NSNumber, rhs as NSNumber):
            return lhs == rhs
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        default:
            return false
        }
    }
    
    private func executeAction(_ action: SduiAction, context: [String: Any]) {
        // 执行 action 的逻辑
        print("Executing watcher action: \(action) with context: \(context)")
        
        switch action.type {
        case "STATE_UPDATE":
            if let payload = action.payload.value as? [String: Any],
               let targetKey = payload["key"] as? String,
               let newValue = payload["value"] {
                setValue(targetKey, value: newValue)
            }
        case "API_CALL":
            // 处理 API 调用
            break
        case "NAVIGATION":
            // 处理导航
            break
        default:
            break
        }
    }
}

// MARK: - Enhanced Component Node
struct ComponentNode: Codable, Identifiable {
    let id: String
    let type: String
    let props: [String: AnyCodable]
    let style: SduiStyle?
    let action: SduiAction?
    let state: SduiStateConfiguration?
    let children: [ComponentNode]?
    
    private enum CodingKeys: String, CodingKey {
        case id, type, props, style, action, state, children
    }
}

// MARK: - Enhanced Action
struct SduiAction: Codable {
    let trigger: String
    let type: String
    let payload: AnyCodable
}

// MARK: - Enhanced Style
struct SduiStyle: Codable {
    let variant: String?
    let color: String?
    let custom: [String: AnyCodable]?
}
