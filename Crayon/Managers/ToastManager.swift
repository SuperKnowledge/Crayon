//
//  ToastManager.swift
//  Crayon
//
//  Created by leetao on 2025/8/22.
//


import SwiftUI
import AlertToast

@MainActor
final class ToastManager: ObservableObject {
    @Published var showToast = false
    @Published var toastTitle = ""
    @Published var toastType: AlertToast.AlertType = .regular
    @Published var toastSubTitle: String?
    
    /// 显示一个 Toast 消息。
    /// - Parameters:
    ///   - title: 要显示的消息文本。
    ///   - type: Toast 的类型 (例如 .complete, .error, .regular)。
    func show(title: String, type: AlertToast.AlertType = .regular, subTitle:String? = nil) {
        self.toastTitle = title
        self.toastType = type
        self.showToast = true // 直接设置为 true，而不是 toggle()，这样可以重复触发
        self.toastSubTitle = subTitle
    }
}
