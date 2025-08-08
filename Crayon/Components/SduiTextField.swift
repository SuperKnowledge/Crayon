//
//  SduiTextField.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import SwiftUI

struct TextFieldProps: Codable {
    var text: String
    var placeholder: String?
    var keyboardType: KeyboardType = .default
    
    enum KeyboardType: String, Codable {
        case `default`
        case asciiCapable
        case numbersAndPunctuation
        case URL
        case numberPad
        case phonePad
        case namePhonePad
        case emailAddress
    }
}


struct SduiTextField: View {
    @State private var text: String
    let props: TextFieldProps
    let action: Action?
    
    init(props: TextFieldProps, action: Action?) {
        self.props = props
        self.action = action
        _text = State(initialValue: props.text)
    }
    
    var body: some View {
        TextField(props.placeholder ?? "", text: $text, onCommit: {
            guard let action = action else { return }
            var payload = action.payload
            
            payload["text"] = AnyCodable(text)
            var newAction = action
            newAction.payload = payload
            ActionInterpreter.shared.handle(newAction)
        })
        .keyboardType(mapKeyboardType(props.keyboardType))
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
    
    private func mapKeyboardType(_ type: TextFieldProps.KeyboardType) -> UIKeyboardType {
        switch type {
        case .default: return .default
        case .asciiCapable: return .asciiCapable
        case .numbersAndPunctuation: return .numbersAndPunctuation
        case .URL: return .URL
        case .numberPad: return .numberPad
        case .phonePad: return .phonePad
        case .namePhonePad: return .namePhonePad
        case .emailAddress: return .emailAddress
        }
    }
}
