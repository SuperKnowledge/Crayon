//
//  ContentView.swift
//  Crayon
//
//  Created by leetao on 2025/8/3.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager()
    @EnvironmentObject private var toastManager: ToastManager
    @State private var selectedTab: TabItem = .home
    @State private var showInputDialog = false
    @State private var showRenderDialog = false
    @State private var renderNode: ComponentNode?
    @State private var inputTextFieldMinimized = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            mainContentView
            HStack(alignment:.center, spacing: 32){
                CustomBottomNavBar(
                    items: TabItem.allCases,
                    selectedTab: $selectedTab
                )
        
                PrimaryActionBtn {
                    if (!authManager.isLoggedIn ){
                        toastManager.show(title: "Login", type:.systemImage("xmark.circle.fill", Color.red), subTitle: "Please Login first")
                        return;
                    }
                    showInputDialog.toggle()
                    
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 8)
            .buttonStyle(.plain)
        }
        .onChange(of: selectedTab) { newTab in
            print("Tab changed to: \(newTab)")
        }
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
    
    @ViewBuilder
    private var mainContentView: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            switch selectedTab {
            case .home:
                Home()
                    .environmentObject(authManager)
                    .navigationTitle("Home")
            case .apps:
                 Apps()
                    .navigationTitle("App")
            case .profile:
                Profile()
                    .navigationTitle("Profile")
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
    ContentView()
}
