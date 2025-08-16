//
//  ContentView.swift
//  Crayon
//
//  Created by leetao on 2025/8/3.
//

import SwiftUI

struct ContentView: View {
    @State private var rootNode: ComponentNode?
    
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                if let node = rootNode {
                    SduiRenderer.renderWithState(node: node)
                } else {
                    ProgressView()
                        .onAppear(perform: loadUI)
                }
            }
            .navigationTitle("Dynamic UI")
            .navigationDestination(for: String.self) { screenId in
                DynamicDetailView(screenId: screenId)
            }
        }
        .onReceive(ActionHandler.shared.navigationSubject) { destinationId in
            navigationPath.append(destinationId)
        }
    }

    func loadUI() {
        // Updated JSON structure to match ComponentNode format
        let jsonString = """
        {
            "id": "login_form",
            "type": "SduiVStack",
            "props": {
                "spacing": 16
            },
            "children": [
                {
                    "id": "login_title",
                    "type": "SduiText",
                    "props": {
                        "text": "用户登录"
                    }
                },
                {
                    "id": "username_field",
                    "type": "SduiTextField",
                    "props": {
                        "placeholder": "请输入用户名",
                        "text": "@state:username"
                    }
                },
                {
                    "id": "password_field",
                    "type": "SduiTextField",
                    "props": {
                        "placeholder": "请输入密码",
                        "isSecure": true,
                        "text": "@state:password"
                    }
                },
                {
                    "id": "login_button",
                    "type": "SduiButton",
                    "props": {
                        "title": "登录"
                    },
                    "action": {
                        "trigger": "onClick",
                        "type": "login",
                        "payload": {
                            "username": "@state:username",
                            "password": "@state:password"
                        }
                    }
                }
            ],
            "state": {
                "bindings": {
                    "username": {
                        "key": "username",
                        "type": "string",
                        "defaultValue": "",
                        "computed": false
                    },
                    "password": {
                        "key": "password",
                        "type": "string",
                        "defaultValue": "",
                        "computed": false
                    }
                }
            }
        }        
"""
        do {
            let jsonData = jsonString.data(using: .utf8)!
            self.rootNode = try JSONDecoder().decode(ComponentNode.self, from: jsonData)
        } catch {
            Log.error("\(error)")
        }
    }
}

// A simple detail view to navigate to
struct DynamicDetailView: View {
    let screenId: String
    
    var body: some View {
        Text("You have navigated to screen: \(screenId)")
            .font(.largeTitle)
            .navigationTitle(screenId)
    }
}

#Preview {
    ContentView()
}
