//
//  UserInputTextField.swift
//  Crayon
//
//  Created by leetao on 2025/8/17.
//

import SwiftUI

struct UserInputTextField: View {
    @State private var userInput = ""

    var body: some View {
        VStack {
            TextEditor(text: $userInput)
                .font(.body)
                .foregroundColor(.gray)
                .padding(4) // 给文字和边框之间留一点空隙
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.secondary.opacity(0.5), lineWidth: 0.5)
                )
        }
        .padding()
    }
}

#Preview {
    UserInputTextField()
}
