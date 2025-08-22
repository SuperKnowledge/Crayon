//
//  RootToastModifier.swift
//  Crayon
//
//  Created by leetao on 2025/8/22.
//


import SwiftUI
import AlertToast

struct RootToastModifier: ViewModifier {
    @StateObject private var toastManager = ToastManager()

    func body(content: Content) -> some View {
        content
            .environmentObject(toastManager)
            .toast(isPresenting: $toastManager.showToast, alert: {
                AlertToast(
                    displayMode: .hud,
                    type: toastManager.toastType,
                    title: toastManager.toastTitle,
                    subTitle: toastManager.toastSubTitle
                )
            })
    }
}

extension View {
    func rootToast() -> some View {
        self.modifier(RootToastModifier())
    }
}
