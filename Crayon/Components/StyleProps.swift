//
//  StyleProps.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import SwiftUI

struct StyleProps {
    var foregroundColor: Color?
    var backgroundColor: Color?
    var fontSize: CGFloat?
    var padding: CGFloat?
    var cornerRadius: CGFloat?
    
    init(from dict: [String: AnyCodable]) {
        if let hex = dict["foregroundColor"]?.value as? String {
            self.foregroundColor = Color(hex: hex)
        }
        if let hex = dict["backgroundColor"]?.value as? String {
            self.backgroundColor = Color(hex: hex)
        }
        if let size = dict["fontSize"]?.value as? Double {
            self.fontSize = CGFloat(size)
        }
        if let pad = dict["padding"]?.value as? Double {
            self.padding = CGFloat(pad)
        }
        if let radius = dict["cornerRadius"]?.value as? Double {
            self.cornerRadius = CGFloat(radius)
        }
    }
}
