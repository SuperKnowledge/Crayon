//
//  Action.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//
import SwiftUI
import JavaScriptCore

// Action 数据模型
struct Action: Codable {
    var trigger: String
    var type: String
    var payload: [String: AnyCodable]
}

// ActionHandler 协议
protocol ActionHandling {
    func handle(_ action: Action)
}


class ActionInterpreter: ActionHandling, ObservableObject {
    
    static let shared = ActionInterpreter()
    
    // 持有 JS 执行环境
    private var jsContext: JSContext?
    
    init() {
        jsContext = JSContext()
        jsContext?.exceptionHandler = { context, exception in
            print("JS Error: \(String(describing: exception))")
        }
    }
    
    func handle(_ action: Action) {
        switch action.type {
            
        case "API_CALL":
            guard let urlAny = action.payload["url"],
                  let url = urlAny.value as? String else {
                print("Invalid or missing url")
                return
            }
            performAPICall(url: url)
            
        case "NAVIGATION":
            guard let targetAny = action.payload["target"] ,
                let target = targetAny.value as? String else{
                print("Invalid or missing url")
                return
            }
            performNavigation(to: target)
        case "JAVASCRIPT":
            guard let scriptAny = action.payload["script"],
                  let script = scriptAny.value as? String else{
                  print("Invalid or missing url")
                  return
              }
            
                runJavaScript(script)
            
            
        case "SHARE":
            guard let textAny = action.payload["text"],
                  let text = textAny.value as? String else{
                print("Invalid or missing url")
                return
            }
            performShare(text: text)
            
        default:
            print("未知 Action 类型: \(action.type)")
        }
    }
    
    // === 各类型处理 ===
    private func performAPICall(url: String) {
        print("调用 API: \(url)")
        // MVP 阶段只打印，后续可接入 URLSession
    }
    
    private func performNavigation(to target: String) {
        print("导航到: \(target)")
        // MVP 阶段只打印，后续可结合 SwiftUI NavigationStack
    }
    
    private func runJavaScript(_ script: String) {
        print("执行 JS 脚本: \(script)")
        _ = jsContext?.evaluateScript(script)
    }
    
    private func performShare(text: String) {
        print("分享文本: \(text)")
        // MVP 阶段只打印，后续可接入 UIActivityViewController
    }
}
