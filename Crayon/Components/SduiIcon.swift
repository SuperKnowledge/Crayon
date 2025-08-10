//
//  SduiIcon.swift
//  Crayon
//
//  Created by leetao on 2025/8/10.
//
import SwiftUI

struct IconProps {
    let name: String
    let size: Double
    let color: String?
}

// MARK: - Additional Components Implementation
struct SduiIcon: View {
    let props: IconProps
    
    var body: some View {
        Image(systemName: props.name)
            .font(.system(size: CGFloat(props.size)))
            .foregroundColor(props.color.flatMap { Color(hex: $0) } ?? .primary)
    }
}

