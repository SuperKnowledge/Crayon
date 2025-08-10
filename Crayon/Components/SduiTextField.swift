//
//  SduiTextField.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import SwiftUI

// MARK: - Props Definitions
struct TextFieldProps {
    let text: String
    let placeholder: String
    let isSecure: Bool
    let isDisabled: Bool
    let keyboardType: KeyboardType
    
    enum KeyboardType: String, CaseIterable {
        case `default` = "default"
        case emailAddress = "emailAddress"
        case numberPad = "numberPad"
        case phonePad = "phonePad"
        case URL = "URL"
    }
}


struct SduiTextField: View {
    let props: TextFieldProps
    let style: StyleProps
    
    var body: some View {
        Group {
            if props.isSecure {
                SecureField(props.placeholder, text: .constant(props.text))
            } else {
                TextField(props.placeholder, text: .constant(props.text))
            }
        }
        .disabled(props.isDisabled)
        .keyboardType(swiftUIKeyboardType)
        .font(textFont)
        .foregroundColor(textColor)
        .padding(textPadding)
    }
    
    private var textFont: Font {
        if let fontSize = style.fontSize {
            return .system(size: fontSize)
        } else {
            return .body
        }
    }
    
    private var textColor: Color {
        return style.foregroundColor ?? .primary
    }
    
    private var textPadding: CGFloat {
        return style.padding ?? 0
    }
    
    private var swiftUIKeyboardType: UIKeyboardType {
        switch props.keyboardType {
        case .default: return .default
        case .emailAddress: return .emailAddress
        case .numberPad: return .numberPad
        case .phonePad: return .phonePad
        case .URL: return .URL
        }
    }
}
