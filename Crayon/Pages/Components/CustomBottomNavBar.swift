//
//  CustomBottomNavBar.swift
//  Crayon
//
//  Created by leetao on 2025/8/17.
//

import SwiftUI

import SwiftUI

enum TabItem: Int, CaseIterable, Identifiable {
    case home
    case apps
    case profile
    
    var id: Int { self.rawValue }
    
    // 每个 case 对应的图标名称
    var iconName: String {
        switch self {
        case .home:
            return "house.fill"
        case .apps:
            return "list.dash"
        case .profile:
            return "person.fill"
        }
    }
}

struct CustomBottomNavBar: View {
    let items: [TabItem]
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 28) {
            ForEach(items) { item in
                Button(action: {
                    // 点击按钮时，更新绑定的状态
                    selectedTab = item
                }) {
                    Image(systemName: item.iconName)
                        // 根据是否被选中来改变样式
                        .foregroundColor(selectedTab == item ? .teal : .teal.opacity(0.5))
                        .scaleEffect(selectedTab == item ? 1.15 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedTab)
                }
            }
        }
        .font(.title2)
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .background(Color.accentColor.opacity(0.2))
        .clipShape(Capsule())
    }
}


#Preview {
    CustomBottomNavBar(items:TabItem.allCases, selectedTab: .constant(TabItem.home))
}
