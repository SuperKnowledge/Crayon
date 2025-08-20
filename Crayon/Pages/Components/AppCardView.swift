//
//  AppUsageResponse.swift
//  Crayon
//
//  Created by leetao on 2025/8/20.
//


import SwiftUI


// MARK: - App Card View Component
struct AppCardView: View {
    let appUsage: AppUsageResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Header Section
            HStack(alignment: .top) {
                // App Icon
                Image(systemName: "swift")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                // Title and Author
                VStack(alignment: .leading, spacing: 4) {
                    Text(appUsage.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.circle")
                        Text(appUsage.authorEmail)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                }
                
                Spacer()
                
                // Status Icons (Bookmark & Fork)
                HStack(spacing: 12) {
                    Image(systemName: appUsage.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(appUsage.isBookmarked ? .yellow : .secondary)
                    
                    Image(systemName: "arrow.triangle.branch")
                        .foregroundColor(appUsage.isForkable ? .green : .secondary.opacity(0.5))
                }
                .font(.callout)
            }
            
            // MARK: - Description Section
            if let description = appUsage.description, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3) // 限制描述最多显示3行
            }
            
            // Divider
            Divider()
            
            // MARK: - Stats Section
            HStack {
                StatView(iconName: "play.circle", text: "\(appUsage.useCount) uses")
                Spacer()
                StatView(iconName: "clock", text: "Last used: \(appUsage.lastUsedAt.formatted(.relative(presentation: .named)))")
            }
        }
        .padding()
        .background(Color(.systemBackground)) // 自适应深色/浅色模式
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Helper View for Stats
struct StatView: View {
    let iconName: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: iconName)
                .font(.caption)
            Text(text)
                .font(.caption)
        }
        .foregroundColor(.secondary)
    }
}


// MARK: - SwiftUI Preview
struct AppCardView_Previews: PreviewProvider {
    // 示例数据1: 包含所有信息
    static let sampleApp1 = AppUsageResponse(
        publicationId: UUID(),
        shareToken: "abc-123",
        title: "Awesome Swift App That Has A Very Long Title To Test Line Limiting",
        description: "This is a detailed description of the application. It explains its purpose, main features, and how it can help users achieve their goals efficiently.",
        authorEmail: "developer@example.com",
        firstUsedAt: Date().addingTimeInterval(-3600 * 24 * 30), // 30天前
        lastUsedAt: Date().addingTimeInterval(-3600 * 24 * 2),   // 2天前
        useCount: 128,
        isBookmarked: true,
        isForkable: true
    )

    // 示例数据2: 不含描述，且未收藏
    static let sampleApp2 = AppUsageResponse(
        publicationId: UUID(),
        shareToken: "def-456",
        title: "Minimalist Utility",
        description: nil, // 没有描述
        authorEmail: "user@example.com",
        firstUsedAt: Date().addingTimeInterval(-3600 * 5), // 5小时前
        lastUsedAt: Date().addingTimeInterval(-60 * 10),    // 10分钟前
        useCount: 5,
        isBookmarked: false,
        isForkable: false
    )
    
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("App Cards")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                AppCardView(appUsage: sampleApp1)
                
                AppCardView(appUsage: sampleApp2)
            }
            .padding()
        }
        .background(Color(.systemGray6))
    }
}
