//
//  JSONDecoder+Extension.swift
//  Crayon
//
//  Created by leetao on 2025/8/20.
//

import Foundation

extension JSONDecoder {
    static let appUsageDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            // Try ISO8601 with microseconds first
            if let date = DateFormatter.iso8601Full.date(from: dateString) {
                return date
            }
            
            // Fallback to ISO8601 formatter
            let iso8601 = ISO8601DateFormatter()
            iso8601.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = iso8601.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        }
        return decoder
    }()
}
