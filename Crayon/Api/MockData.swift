//
//  MockData.swift
//  Crayon
//
//  Created by leetao on 2025/8/21.
//

import Foundation

struct MockData {
    static let sampleApps: [AppUsageResponse] = [
        AppUsageResponse(
            publicationId: UUID(),
            shareToken: "abc-123",
            title: "Weather Dashboard",
            description: "A beautiful weather app with detailed forecasts and interactive maps. Perfect for planning your daily activities.",
            authorEmail: "john.doe@example.com",
            firstUsedAt: Date().addingTimeInterval(-3600 * 24 * 30), // 30 days ago
            lastUsedAt: Date().addingTimeInterval(-3600 * 2), // 2 hours ago
            useCount: 45,
            isBookmarked: true,
            isForkable: true
        ),
        
        AppUsageResponse(
            publicationId: UUID(),
            shareToken: "def-456",
            title: "Todo Manager",
            description: "Stay organized with this simple yet powerful task management application.",
            authorEmail: "jane.smith@example.com",
            firstUsedAt: Date().addingTimeInterval(-3600 * 24 * 7), // 7 days ago
            lastUsedAt: Date().addingTimeInterval(-3600 * 24), // 1 day ago
            useCount: 12,
            isBookmarked: false,
            isForkable: true
        ),
        
        AppUsageResponse(
            publicationId: UUID(),
            shareToken: "ghi-789",
            title: "Calculator Pro",
            description: nil,
            authorEmail: "dev@mathtools.com",
            firstUsedAt: Date().addingTimeInterval(-3600 * 24 * 3), // 3 days ago
            lastUsedAt: Date().addingTimeInterval(-60 * 30), // 30 minutes ago
            useCount: 8,
            isBookmarked: true,
            isForkable: false
        ),
        
        AppUsageResponse(
            publicationId: UUID(),
            shareToken: "jkl-012",
            title: "Photo Editor Suite with Advanced Filters and Professional Tools",
            description: "Transform your photos with professional-grade editing tools. Features include filters, adjustments, cropping, and much more. Perfect for photographers and content creators who need powerful editing capabilities on the go.",
            authorEmail: "creative@phototools.net",
            firstUsedAt: Date().addingTimeInterval(-3600 * 24 * 14), // 14 days ago
            lastUsedAt: Date().addingTimeInterval(-3600 * 6), // 6 hours ago
            useCount: 23,
            isBookmarked: false,
            isForkable: true
        )
    ]
    
    static let bookmarkedApps: [AppUsageResponse] = sampleApps.filter { $0.isBookmarked }
}
