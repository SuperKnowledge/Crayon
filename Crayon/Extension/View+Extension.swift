//
//  View+Extension.swift
//  Crayon
//
//  Created by leetao on 2025/8/10.
//

import Foundation
import SwiftUI

extension View {
    func applyStyle(_ style: StyleProps) -> some View {
        self
            .font(style.fontSize.map { .system(size: $0) } ?? .body)
            .foregroundColor(style.foregroundColor ?? .primary)
            .padding(style.padding ?? 0)
    }
}
