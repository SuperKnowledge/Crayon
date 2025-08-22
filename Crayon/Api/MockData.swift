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
    
    // MARK: - Chat Response Mock Data
    static let mockChatResponseWithNodeTree = ChatResponse(
        message: "I've created a beautiful card component for you!",
        hasCodeChange: true,
        nodeStateTree: [
            "id": AnyCodable("card_component"),
            "type": AnyCodable("SduiVStack"),
            "props": AnyCodable([
                "spacing": 16,
                "padding": 20
            ]),
            "children": AnyCodable([
                [
                    "id": AnyCodable("card_title"),
                    "type": AnyCodable("SduiText"),
                    "props": AnyCodable([
                        "text": "Sample Card",
                        "style": [
                            "fontSize": 24,
                            "fontWeight": "bold",
                            "color": "#333333"
                        ]
                    ])
                ],
                [
                    "id": AnyCodable("card_content"),
                    "type": AnyCodable("SduiText"),
                    "props": AnyCodable([
                        "text": "This is a sample card content with some description text.",
                        "style": [
                            "fontSize": 16,
                            "color": "#666666"
                        ]
                    ])
                ]
            ])
        ],
        typescriptCode: nil,
        versionNumber: 1,
        requestedComponents: [],
        error: nil
    )
    
    static let mockChatResponseWithError = ChatResponse(
        message: "Sorry, I couldn't process your request.",
        hasCodeChange: false,
        nodeStateTree: nil,
        typescriptCode: nil,
        versionNumber: 1,
        requestedComponents: [],
        error: "Invalid component syntax"
    )
    
    // MARK: - Validation Mock Data
    static let mockValidationSuccess: [String: Bool] = [
        "typecheck": true,
        "serialize": true
    ]
    
    static let mockValidationTypecheckFail: [String: Bool] = [
        "typecheck": false,
        "serialize": false
    ]
    
    static let mockValidationSerializeFail: [String: Bool] = [
        "typecheck": true,
        "serialize": false
    ]
    
    static let mockChatResponseForLogin = ChatResponse(
        message: "Login component created!",
        hasCodeChange: true,
        nodeStateTree: [
            "type": AnyCodable("SduiVStack"),
            "props": AnyCodable([:]),
            "children": AnyCodable([
                [
                    "type": AnyCodable("SduiText"),
                    "props": AnyCodable([
                        "text": "用户登录"
                    ])
                ],
                [
                    "type": AnyCodable("SduiTextField"),
                    "props": AnyCodable([
                        "placeholder": "请输入用户名",
                        "data-state-key": "username",
                        "data-state-bindings": "[{\"stateKey\": \"username\", \"propName\": \"text\", \"bidirectional\": true}]"
                    ]),
                    "stateBindings": AnyCodable([
                        [
                            "stateKey": "username",
                            "propName": "text",
                            "bidirectional": true
                        ]
                    ])
                ],
                [
                    "type": AnyCodable("SduiTextField"),
                    "props": AnyCodable([
                        "placeholder": "请输入密码",
                        "isSecure": true,
                        "data-state-key": "password",
                        "data-state-bindings": "[{\"stateKey\": \"password\", \"propName\": \"text\", \"bidirectional\": true}]"
                    ]),
                    "stateBindings": AnyCodable([
                        [
                            "stateKey": "password",
                            "propName": "text",
                            "bidirectional": true
                        ]
                    ])
                ],
                [
                    "type": AnyCodable("SduiButton"),
                    "props": AnyCodable([
                        "title": "登录"
                    ]),
                    "action": AnyCodable([
                        "type": "login",
                        "data": [
                            "username": "{{username}}",
                            "password": "{{password}}"
                        ]
                    ])
                ]
            ])
        ],
        typescriptCode: nil,
        versionNumber: 1,
        requestedComponents: [],
        error: nil
    )
}
