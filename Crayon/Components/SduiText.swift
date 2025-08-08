//
//  SduiText.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import SwiftUI

struct SduiText: View {
    let text: String
    let style: StyleProps
    
    var body: some View {
        Text(text)
            .font(.system(size: style.fontSize ?? 14))
            .foregroundColor(style.foregroundColor ?? .primary)
            .padding(style.padding ?? 0)
    }
}
