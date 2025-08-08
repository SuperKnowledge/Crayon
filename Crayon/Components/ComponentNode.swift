//
//  ComponentNode.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//


struct ComponentNode: Codable, Identifiable {
    let id: String
    let type: String
    let props: [String: AnyCodable] // AnyCodable 方便存储任意类型
    let children: [ComponentNode]?
}
