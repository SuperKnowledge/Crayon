//
//  PrimaryActionBtn.swift
//  Crayon
//
//  Created by leetao on 2025/8/17.
//

import SwiftUI

struct PrimaryActionBtn: View {
    
    // 1. 声明一个 action 属性，它的类型是一个无参数、无返回值的闭包
    var action: () -> Void
    
    var body: some View {
        // 2. 将传入的 action 赋值给 Button 的 action 参数
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .bold))
                .padding(18)
                .foregroundColor(.white)
                .background(AngularGradient(gradient: Gradient(colors: [.purple, .blue, .cyan, .green, .yellow, .orange, .red, .purple]), center: .center))
                .clipShape(Circle())
        }
    }
}

#Preview {
    // 3. 在创建 PrimaryActionBtn 时，传入具体的执行代码
    PrimaryActionBtn(action: {
        print("按钮被点击了！")
    })
}
