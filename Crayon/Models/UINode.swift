//
//  UINode.swift
//  Crayon
//
//  Created by leetao on 2025/8/3.
//

import SwiftUI

// A struct to hold all possible properties. This part is fine.
struct UIProperties: Codable {
    // Generic
    var padding: CGFloat? // Use CGFloat for SwiftUI consistency
    var backgroundColor: String? // e.g., "#FF5733"
    var cornerRadius: CGFloat?

    // Layout (VStack/HStack)
    var spacing: CGFloat?
    var alignment: String? // "leading", "center", "trailing"

    // Text
    var text: String?
    var fontSize: CGFloat?
    var fontWeight: String? // "bold", "semibold", "regular"

    // Image
    var url: String?
    var width: CGFloat?
    var height: CGFloat?
    var clipShape: String? // "Circle"
    
    // Button
    var label: UINode? // A button's label is another node
}

// The main node in the tree
class UINode: Codable, Identifiable, Hashable {
    let id: String
    let type: ComponentType
    var properties: UIProperties?
    var children: [UINode]?
    var actions: [UIAction]?
    
  
    init(id: String, type: ComponentType, properties: UIProperties? = nil, children: [UINode]? = nil, actions: [UIAction]? = nil) {
        self.id = id
        self.type = type
        self.properties = properties
        self.children = children
        self.actions = actions
    }
    
    // MARK: - Codable Conformance
    
    private enum CodingKeys: String, CodingKey {
        case id, type, properties, children, actions
    }
    

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode each property from the container
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(ComponentType.self, forKey: .type)
        properties = try container.decodeIfPresent(UIProperties.self, forKey: .properties)
        children = try container.decodeIfPresent([UINode].self, forKey: .children)
        actions = try container.decodeIfPresent([UIAction].self, forKey: .actions)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(properties, forKey: .properties)
        try container.encodeIfPresent(children, forKey: .children)
        try container.encodeIfPresent(actions, forKey: .actions)
    }
    
    // MARK: - Hashable & Equatable Conformance (This was already correct)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UINode, rhs: UINode) -> Bool {
        lhs.id == rhs.id
    }
}

// Enum for all supported component types
enum ComponentType: String, Codable {
    case VStack, HStack, Text, Image, Button, Spacer
}

// Defines an action a component can perform
struct UIAction: Codable {
    var trigger: String // e.g., "onClick"
    var type: String // e.g., "API_CALL", "NAVIGATE"
    var payload: [String: String]? // e.g., {"url": "/api/follow"}
}
