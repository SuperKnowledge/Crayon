//
//  UserInputTextField.swift
//  Crayon
//
//  Created by leetao on 2025/8/17.
//


import SwiftUI


struct UserInputTextField: View {
    @State private var text: String = ""
    @State private var isLoading: Bool = false
    @State private var hasResponse: Bool = false
    @State private var responseMessage: String = ""
    @State private var isError: Bool = false
    @State private var showValidationSteps: Bool = false
    @State private var componentCodeToValidate: String? = nil
    
    @State private var currentChatResponse: ChatResponse?
    
    @Binding var isMinimized: Bool
    let onSuccessResponse: (ChatResponse) -> Void
    
    @FocusState private var isTextFieldFocused: Bool
    
    init(isMinimized: Binding<Bool> = .constant(false), onSuccessResponse: @escaping (ChatResponse) -> Void = { _ in }) {
        self._isMinimized = isMinimized
        self.onSuccessResponse = onSuccessResponse
    }

    var body: some View {
        VStack(spacing: 16) {
            if showValidationSteps, let code = componentCodeToValidate {
                            ValidationStepsView(
                                componentCode: code,
                                onAllStepsCompleted: {
                                    // When the view reports completion, update our state
                                    handleValidationCompleted()
                                },
                                onValidationFailed: {
                               
                                    handleValidationFailed()
                                }
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
            
            if hasResponse && !isMinimized && !showValidationSteps {
                // 响应结果视图
                responseView
            }
            
            // 输入区域
            inputAreaView
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(.easeInOut(duration: 0.3), value: isMinimized)
        .animation(.easeInOut(duration: 0.3), value: showValidationSteps)
    }
    
    // 响应结果视图
    private var responseView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(isError ? "Error" : "Response")
                    .font(.headline)
                    .foregroundColor(isError ? .red : .primary)
                
                Spacer()
                
                Button(action: clearResponse) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            
            ScrollView {
                Text(responseMessage)
                    .font(.body)
                    .foregroundColor(isError ? .red : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
            }
            .frame(minHeight: 100, maxHeight: isMinimized ? 50 : 200)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
        .padding(16)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    // 输入区域视图
    private var inputAreaView: some View {
        ZStack(alignment: .bottomTrailing) {
            if hasResponse || isMinimized {
                // 压缩状态的输入框
                Spacer()
                compactInputView
            } else {
                // 完整状态的输入框
                expandedInputView
            }
            
            sendButtonView
        }
    }
    
    // 压缩状态的输入框
    private var compactInputView: some View {
        HStack(spacing: 8) {
            TextField("Type a message...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isTextFieldFocused)
            
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
                    .padding(.trailing, 8)
            }
        }
        .transition(.scale.combined(with: .opacity))
    }
    
    // 完整状态的输入框
    private var expandedInputView: some View {
        TextEditor(text: $text)
            .font(.body)
            .padding(8)
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.secondarySystemBackground))
            .foregroundColor(.primary)
            .cornerRadius(20)
            .focused($isTextFieldFocused)
            .frame(minHeight: 120)
            .onAppear {
                if !hasResponse && !isMinimized {
                    isTextFieldFocused = true
                }
            }
            .transition(.scale.combined(with: .opacity))
    }
    
    // 发送按钮
    @ViewBuilder
    private var sendButtonView: some View {
        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading {
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
            }
            .transition(.scale.combined(with: .opacity))
        }
    }
    
    // 发送消息方法
    private func sendMessage() {
        let messageToSend = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !messageToSend.isEmpty else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            isLoading = true
            hasResponse = false
            isError = false
            showValidationSteps = false
            currentChatResponse = nil
        }
        
        ChatAPI.sendMessage(message: messageToSend, screenshotUrl: nil, model: nil) { result in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                    
                    switch result {
                    case .success(let response):
                        // 处理错误情况
                        if let error = response.error {
                            isError = true
                            responseMessage = error
                            hasResponse = true
                        } else {
                            // 成功获得响应，开始验证流程
                            currentChatResponse = response
                            startValidationProcess(response: response)
                        }
                        
                    case .failure(let error):
                        isError = true
                        responseMessage = "Network error: \(error.localizedDescription)"
                        hasResponse = true
                    }
                }
                text = ""
            }
        }
    }
    
    // 开始验证流程
    private func startValidationProcess(response: ChatResponse) {
        // 如果没有 nodeStateTree，直接显示响应消息
        guard let nodeStateTree = response.nodeStateTree else {
            responseMessage = response.message
            hasResponse = true
            return
        }
        
        // 显示验证步骤
        showValidationSteps = true
        
        // 从 nodeStateTree 提取组件代码进行验证
        let componentCode = convertNodeStateTreeToComponentCode(nodeStateTree)
        
        self.componentCodeToValidate = componentCode
        self.showValidationSteps = true
    }
    

    // 验证完成后的处理
    private func handleValidationCompleted() {
           withAnimation(.easeInOut(duration: 0.3)) {
               showValidationSteps = false
               componentCodeToValidate = nil // Clean up state
           }
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
               if let response = currentChatResponse {
                   onSuccessResponse(response)
               }
           }
       }
    
    // 验证失败后的处理
    private func handleValidationFailed() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showValidationSteps = false
            componentCodeToValidate = nil // Clean up state
            isError = true
            responseMessage = "Component validation failed. Please check the structure and try again."
            hasResponse = true
        }
    }
    
    // 将 nodeStateTree 转换为组件代码字符串
    private func convertNodeStateTreeToComponentCode(_ nodeStateTree: [String: AnyCodable]) -> String {
        Log.info("convertNodeStateTreeToComponentCode,\(nodeStateTree)")
        
        do {
            let jsonData = try JSONEncoder().encode(nodeStateTree)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            Log.warning("Failed to convert nodeStateTree to component code: \(error)")
        }
        return "<Component>Invalid</Component>"
    }
    
    // 清除响应
    private func clearResponse() {
          withAnimation(.easeInOut(duration: 0.3)) {
              hasResponse = false
              isError = false
              responseMessage = ""
              showValidationSteps = false
              currentChatResponse = nil
              componentCodeToValidate = nil // Also clear the validation code
              isTextFieldFocused = true
          }
      }
}

struct UserInputTextField_PreviewContainer: View {
    @State private var isMinimized = false

    var body: some View {
        UserInputTextField(isMinimized: $isMinimized) { response in
            print("Response: \(response)")
        }
    }
}

#Preview {
    UserInputTextField_PreviewContainer()
}
