//
//  AnyCodable.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import Foundation

public struct AnyCodable: Codable {
    public let value: Any
    
    public init(_ value: Any) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.value = ()
        } else if let bool = try? container.decode(Bool.self) {
            self.value = bool
        } else if let int = try? container.decode(Int.self) {
            self.value = int
        } else if let double = try? container.decode(Double.self) {
            self.value = double
        } else if let string = try? container.decode(String.self) {
            self.value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            self.value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        // Helper function to encode any value recursively
        func encodeValue(_ val: Any) throws {
            switch val {
            case is Void, is NSNull:
                try container.encodeNil()
            case let bool as Bool:
                try container.encode(bool)
            case let int as Int:
                try container.encode(int)
            case let int8 as Int8:
                try container.encode(int8)
            case let int16 as Int16:
                try container.encode(int16)
            case let int32 as Int32:
                try container.encode(int32)
            case let int64 as Int64:
                try container.encode(int64)
            case let uint as UInt:
                try container.encode(uint)
            case let uint8 as UInt8:
                try container.encode(uint8)
            case let uint16 as UInt16:
                try container.encode(uint16)
            case let uint32 as UInt32:
                try container.encode(uint32)
            case let uint64 as UInt64:
                try container.encode(uint64)
            case let float as Float:
                try container.encode(float)
            case let double as Double:
                try container.encode(double)
            case let string as String:
                try container.encode(string)
            case let anycodable as AnyCodable:
                // Recursively encode AnyCodable by extracting its value
                try encodeValue(anycodable.value)
            case let array as [Any]:
                try container.encode(array.map { AnyCodable($0) })
            case let dictionary as [String: Any]:
                try container.encode(dictionary.mapValues { AnyCodable($0) })
            default:
                throw EncodingError.invalidValue(val, EncodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unsupported type: \(type(of: val))"
                ))
            }
        }
        
        try encodeValue(self.value)
    }
}
