//
//  ValidationTestView.swift
//  Crayon
//
//  Created by leetao on 2025/8/22.
//

import SwiftUI

struct ValidationTestView: View {
    @State private var showInputDialog = false
    @State private var inputTextFieldMinimized = false
    @State private var showRenderDialog = false
    @State private var renderNode: ComponentNode?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Validation Flow Test")
                .font(.title)
                .fontWeight(.bold)
            
            Text("This page is for testing the validation flow with mock data.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                Button("Test Normal Flow (Success)") {
                    showInputDialog = true
                }
                .buttonStyle(.borderedProminent)
                
                Text("Try typing: 'Create a button'")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 16) {
                Button("Test Typecheck Failure") {
                    showInputDialog = true
                }
                .buttonStyle(.bordered)
                
                Text("Try typing: 'invalid component'")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 16) {
                Button("Test Serialize Failure") {
                    showInputDialog = true
                }
                .buttonStyle(.bordered)
                
                Text("Try typing: 'serialize_fail component'")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("Mock Mode Status")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Chat API Mock:")
                    Spacer()
                    Text(ChatAPI.useMockData ? "Enabled" : "Disabled")
                        .foregroundColor(ChatAPI.useMockData ? .green : .red)
                }
                
                HStack {
                    Text("Valid API Mock:")
                    Spacer()
                    Text(ValidApi.useMockData ? "Enabled" : "Disabled")
                        .foregroundColor(ValidApi.useMockData ? .green : .red)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
        .padding()
        .sheet(isPresented: $showInputDialog) {
            UserInputTextField(
                isMinimized: $inputTextFieldMinimized,
                onSuccessResponse: { response in
                    handleChatResponse(response)
                }
            )
        }
        .sheet(isPresented: $showRenderDialog) {
            if let node = renderNode {
                NavigationView {
                    VStack {
                        SduiRenderer.renderWithState(node: node)
                    }
                    .navigationTitle("Generated UI")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showRenderDialog = false
                                renderNode = nil
                                inputTextFieldMinimized = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func handleChatResponse(_ chatResponse: ChatResponse) {
        // 最小化输入框
        withAnimation(.easeInOut(duration: 0.3)) {
            inputTextFieldMinimized = true
        }
        
        // 延迟一点时间后显示渲染结果
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            parseAndShowRenderResult(chatResponse)
        }
    }
    
    private func parseAndShowRenderResult(_ chatResponse: ChatResponse) {
        // 直接使用 node_state_tree 字段
        guard let nodeStateTree = chatResponse.nodeStateTree,
              let jsonData = try? JSONEncoder().encode(nodeStateTree) else {
            Log.warning("No node_state_tree found in response or it failed to encode.")
            createFallbackNode(chatResponse.message)
            return
        }

        
        do {
            let node = try JSONDecoder().decode(ComponentNode.self, from: jsonData)
            renderNode = node
            showRenderDialog = true
        } catch {
            print("Failed to decode ComponentNode: \(error)")
            // 如果解析失败，创建一个简单的文本显示
            createFallbackNode(chatResponse.message)
        }
    }
    
    private func createFallbackNode(_ message: String) {
        let fallbackNode = ComponentNode(
            id: "fallback_response",
            type: "SduiVStack",
            props: [
                "spacing": AnyCodable(16)
            ],
            style: nil,
            action: nil,
            state:nil,
            children:[
                ComponentNode(
                    id: "response_title",
                    type: "SduiText",
                    props: [
                        "text":  AnyCodable("Chat Response"),
                        "style": AnyCodable([
                            "fontSize": 20,
                            "fontWeight": "bold"
                        ])
                    ],
                    style:nil,
                    action:nil,
                    state: nil,
                    children: nil
                    
                ),
                ComponentNode(
                    id: "response_content",
                    type: "SduiText",
                    props: [
                        "text": AnyCodable(message)
                    ],
                    style:nil,
                    action:nil,
                    state: nil,
                    children: nil
                ),
                
            ],
        )
        
        renderNode = fallbackNode
        showRenderDialog = true
    }
}

#Preview {
    ValidationTestView()
}
