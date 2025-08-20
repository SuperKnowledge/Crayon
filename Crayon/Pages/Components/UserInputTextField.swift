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
    
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 16) {
            if hasResponse {
                // 响应结果视图
                responseView
            }
            
            // 输入区域
            inputAreaView
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .ignoresSafeArea(.keyboard, edges: .bottom)
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
            .frame(minHeight: 100, maxHeight: 200)
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
            if hasResponse {
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
            .frame(minHeight: hasResponse ? 50 : 120)
            .onAppear {
                if !hasResponse {
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
        }
        
        
        ChatAPI.sendMessage(message: messageToSend, screenshotUrl: nil, model: nil) { result in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                    hasResponse = true
                    
                    switch result {
                    case .success(let response):
                        isError = false
                        responseMessage = response.message
                        
                        // 处理错误情况
                        if let error = response.error {
                            isError = true
                            responseMessage = error
                        }
                        
                    case .failure(let error):
                        isError = true
                        responseMessage = "Network error: \(error.localizedDescription)"
                    }
                }
                text = ""
            }
        }
    }
    
    // 清除响应
    private func clearResponse() {
        withAnimation(.easeInOut(duration: 0.3)) {
            hasResponse = false
            isError = false
            responseMessage = ""
            isTextFieldFocused = true
        }
    }
}

struct UserInputTextField_PreviewContainer: View {
    @State private var messageText = ""

    var body: some View {
     
            UserInputTextField()
    }
}


#Preview {
    UserInputTextField_PreviewContainer()
}
