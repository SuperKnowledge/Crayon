//
//  Models.swift
//  Crayon
//
//  Created by leetao on 2025/8/18.
//

import Foundation


struct ChatMessage: Codable {
    /// User's message
    var message: String
    /// URL of uploaded screenshot (from /api/files/upload/screenshot)
    var screenshotUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case screenshotUrl = "screenshot_url"
    }
}

struct MessageResponse: Codable {
    /// Message ID
    var id: UUID
    /// Message role: "user", "assistant", or "system"
    var role: String // 在 Swift 中，可以创建一个 enum 来替代 String，以获得更强的类型安全
    /// Message content
    var content: String
    /// Whether code was changed
    var hasCodeChange: Bool
    /// Screenshot URL if any
    var screenshotUrl: String?
    /// Version at message time
    var versionNumber: Int
    /// Version/branch this message belongs to
    var versionId: UUID?
    /// App ID this message belongs to
    var appId: UUID
    /// Message timestamp
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case role
        case content
        case hasCodeChange = "has_code_change"
        case screenshotUrl = "screenshot_url"
        case versionNumber = "version_number"
        case versionId = "version_id"
        case appId = "app_id"
        case createdAt = "created_at"
    }
}

struct ChatResponse: Codable {
    /// Assistant's response
    var message: String
    /// Whether code was updated
    var hasCodeChange: Bool
    /// Updated JSON node state tree if code changed
    var nodeStateTree: [String: AnyCodable]?
    /// Updated TypeScript code if changed
    var typescriptCode: String?
    /// Current version number
    var versionNumber: Int
    /// Components requested but not available
    var requestedComponents: [String]
    /// Error message if any
    var error: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case hasCodeChange = "has_code_change"
        case nodeStateTree = "node_state_tree"
        case typescriptCode = "typescript_code"
        case versionNumber = "version_number"
        case requestedComponents = "requested_components"
        case error
    }
}

struct ConversationHistory: Codable {
    /// List of messages
    var messages: [MessageResponse]
    /// Total message count
    var totalMessages: Int
    /// App ID (nil for all apps)
    var appId: UUID?
    /// Current version number
    var currentVersion: Int
    
    enum CodingKeys: String, CodingKey {
        case messages
        case totalMessages = "total_messages"
        case appId = "app_id"
        case currentVersion = "current_version"
    }
}


// MARK: - App Usage Response
struct AppUsageResponse: Codable {
    /// Publication ID
    let publicationId: UUID
    /// Share token for URL
    let shareToken: String
    /// App title
    let title: String
    /// App description
    let description: String?
    /// App creator's email
    let authorEmail: String
    /// When first accessed
    let firstUsedAt: Date
    /// When last accessed
    let lastUsedAt: Date
    /// Number of times used
    let useCount: Int
    /// Whether bookmarked
    let isBookmarked: Bool
    /// Whether can be forked
    let isForkable: Bool
    
    enum CodingKeys: String, CodingKey {
        case publicationId = "publication_id"
        case shareToken = "share_token"
        case title
        case description
        case authorEmail = "author_email"
        case firstUsedAt = "first_used_at"
        case lastUsedAt = "last_used_at"
        case useCount = "use_count"
        case isBookmarked = "is_bookmarked"
        case isForkable = "is_forkable"
    }
}

// MARK: - App Usage List Response
struct AppUsageListResponse: Codable {
    /// List of used apps
    let apps: [AppUsageResponse]
    /// Total count
    let total: Int
}

// MARK: - Bookmark Request
struct BookmarkRequest: Codable {
    /// Bookmark state
    let isBookmarked: Bool
    
    enum CodingKeys: String, CodingKey {
        case isBookmarked = "is_bookmarked"
    }
}

