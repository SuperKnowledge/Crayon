//
//  ButtonProps.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import SwiftUI

struct Style {
    var variant: Variant
    var color: Color?
    var custom: [String: Any]?
    
    enum Variant: String {
        case `default`
        case bordered
        case primary
        case danger
    }
}

struct ButtonProps {
    var text: String
    var enabled: Bool = true
    
    var loading: Bool = false
    var icon: String? = nil
    var iconPosition: IconPosition = .left
    var accessibilityLabel: String? = nil
    var tooltip: String? = nil
    var size: ButtonSize = .medium
    
    enum IconPosition: String {
        case left, right
    }
    
    enum ButtonSize: String {
        case small, medium, large
    }
}

struct SduiButton: View {
    let props: ButtonProps
    let style: Style
    let action: Action?
    
    var body: some View {
        Button(action: {
            guard props.enabled, !props.loading, let action = action else { return }
            ActionInterpreter.shared.handle(action)
        }) {
            HStack {
                if let icon = props.icon, props.iconPosition == .left {
                    Image(systemName: icon)
                }
                if props.loading {
                    ProgressView()
                } else {
                    Text(props.text)
                }
                if let icon = props.icon, props.iconPosition == .right {
                    Image(systemName: icon)
                }
            }
            .font(fontSize)
            .foregroundColor(props.enabled ? (style.color ?? .primary) : .gray)
        }
        .disabled(!props.enabled || props.loading)
        .accessibilityLabel(Text(props.accessibilityLabel ?? props.text))
  
    }
    
    private var fontSize: Font {
        switch props.size {
        case .small: return .footnote
        case .medium: return .body
        case .large: return .title3
        }
    }
}
