//
//  SduiRenderer.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import SwiftUI

struct SduiRenderer: View {
    let node: ComponentNode
    
    var body: some View {
        switch node.type {
        case "SduiText":
            SduiText(
                text: node.props["text"]?.value as? String ?? "",
                style: StyleProps(from: node.props["style"]?.value as? [String: AnyCodable] ?? [:])
            )
            
        case "SduiImage":
            SduiImage(
                url: node.props["url"]?.value as? String ?? "",
                style: StyleProps(from: node.props["style"]?.value as? [String: AnyCodable] ?? [:])
            )
            
        case "SduiButton":
            let buttonProps = ButtonProps(
                text: node.props["title"]?.value as? String ?? "",
                enabled: node.props["enabled"]?.value as? Bool ?? true,
                loading: node.props["loading"]?.value as? Bool ?? false,
                icon: node.props["icon"]?.value as? String,
                iconPosition: (node.props["iconPosition"]?.value as? String).flatMap(ButtonProps.IconPosition.init) ?? .left,
                accessibilityLabel: node.props["accessibilityLabel"]?.value as? String,
                tooltip: node.props["tooltip"]?.value as? String,
                size: (node.props["size"]?.value as? String).flatMap(ButtonProps.ButtonSize.init) ?? .medium
            )

            // 2. 组装 Style
            let style = Style(
                variant: (node.props["variant"]?.value as? String).flatMap(Style.Variant.init) ?? .default,
                color: (node.props["color"]?.value as? String).flatMap { Color(hex: $0) },
                custom: nil
            )

            // 3. 解析 Action
            let action = try? JSONDecoder().decode(
                Action.self,
                from: JSONSerialization.data(withJSONObject: node.props["action"]?.value ?? [:])
            )

            // 4. 调用新版 SduiButton
            SduiButton(props: buttonProps, style: style, action: action)

            
        case "SduiVStack":
            VStack(spacing: (node.props["spacing"]?.value as? Double).map { CGFloat($0) } ?? 8) {
                ForEach(node.children ?? []) { child in
                    SduiRenderer(node: child)
                }
            }
            
        case "SduiHStack":
            HStack(spacing: (node.props["spacing"]?.value as? Double).map{CGFloat($0)} ?? 8) {
                ForEach(node.children ?? []) { child in
                    SduiRenderer(node: child)
                }
            }
            
        case "SduiSpacer":
            Spacer(minLength: (node.props["minLength"]?.value as? Double).map{CGFloat($0)})
            
        default:
            EmptyView()
        }
    }
}
