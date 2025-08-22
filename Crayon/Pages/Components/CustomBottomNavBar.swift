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
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 28) {
            ForEach(items) { item in
                Button(action: {
                    selectedTab = item
                }) {
                    Image(systemName: item.iconName)
                        .foregroundColor(
                            colorScheme == .light
                                ? (selectedTab == item ? .black : Color.black.opacity(0.5))
                                : (selectedTab == item ? .white : Color.white.opacity(0.5))
                        )
                        .scaleEffect(selectedTab == item ? 1.15 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedTab)
                }
            }
        }
        .font(.title2)
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .background(colorScheme == .light ? Color.white : Color.black)
        .clipShape(Capsule())
    }
}


#Preview {
    CustomBottomNavBar(items:TabItem.allCases, selectedTab: .constant(TabItem.home))
}
