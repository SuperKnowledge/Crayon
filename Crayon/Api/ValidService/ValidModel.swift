//
//  ComponentRequestBody.swift
//  Crayon
//
//  Created by leetao on 2025/8/22.
//


import Foundation

// MARK: - Request Body
struct ComponentRequestBody: Codable {
    let componentCode: String
}

struct ComponentJSON: Decodable {
}

struct StateManagerPayload: Decodable {
}


// MARK: - Response Models
struct UnifiedPayload: Decodable {
    let isValid: Bool?

    let json: ComponentJSON?
    let stateManager: StateManagerPayload?
}

struct ApiResponse: Decodable {
    let success: Bool
    let any: UnifiedPayload
}
