//
//  UserInputTextField.swift
//  Crayon
//
//  Created by leetao on 2025/8/17.
//


//
//  UserInputTextField.swift
//  Crayon
//
//  Created by leetao on 2025/8/17.
//

import SwiftUI

struct UserInputTextField: View {
    @Binding var text: String
    let onSend: (String) -> Void
    
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
                   textEditorView
                   sendButtonView
               }
               .padding(.horizontal)
               .padding(.vertical, 8)
    }
    
    private var textEditorView: some View {
        TextEditor(text: $text)
            .font(.body)
            .padding(8)
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.secondarySystemBackground))
            .foregroundColor(.primary)
            .cornerRadius(20)
            .focused($isTextFieldFocused)
            .frame(maxHeight: 150)
            .onAppear {
                isTextFieldFocused = true
            }
    }
    
    // 将发送按钮也提取出来
    @ViewBuilder
    private var sendButtonView: some View {
        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            Button(action: {
                onSend(text)
                text = ""
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
            }

            .transition(.scale.combined(with: .opacity))
        }
    }
}

struct UserInputTextField_PreviewContainer: View {
    @State private var messageText = ""

    var body: some View {
        VStack {
            Spacer()
            Text("输入的内容: \(messageText)")
            Spacer()
            
            UserInputTextField(text: $messageText) { messageToSend in
        
                print("准备发送消息: \(messageToSend)")
            }
        }
        .background(Color(UIColor.systemGray5))
        .onTapGesture {
            // 点击背景时隐藏键盘
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}


#Preview {
    UserInputTextField_PreviewContainer()
}
