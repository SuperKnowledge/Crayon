//
//  SduiRenderer.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import SwiftUI


struct SduiRenderer: View {
    let node: ComponentNode
    var stateManager: SduiStateManager?
    
    init(node: ComponentNode, stateManager: SduiStateManager? = nil) {
        self.node = node
        self.stateManager = stateManager
    }
    
    var body: some View {
        switch node.type {
        case "SduiText":
            SduiText(
                text: resolveStateValue(node.props["text"]?.value as? String ?? ""),
                style: StyleProps(from: node.props["style"]?.value as? [String: AnyCodable] ?? [:])
            )
            
        case "SduiImage":
            SduiImage(
                url: resolveStateValue(node.props["url"]?.value as? String ?? ""),
                style: StyleProps(from: node.props["style"]?.value as? [String: AnyCodable] ?? [:])
            )
            
        case "SduiButton":
            let buttonProps = ButtonProps(
                text: resolveStateValue(node.props["title"]?.value as? String ?? ""),
                enabled: resolveStateValue(node.props["enabled"]?.value as? Bool ?? true),
                loading: resolveStateValue(node.props["loading"]?.value as? Bool ?? false),
                icon: node.props["icon"]?.value as? String,
                iconPosition: (node.props["iconPosition"]?.value as? String).flatMap(ButtonProps.IconPosition.init) ?? .left,
                accessibilityLabel: node.props["accessibilityLabel"]?.value as? String,
                tooltip: node.props["tooltip"]?.value as? String,
                size: (node.props["size"]?.value as? String).flatMap(ButtonProps.ButtonSize.init) ?? .medium
            )

            let style = Style(
                variant: (node.props["variant"]?.value as? String).flatMap(Style.Variant.init) ?? .default,
                color: (node.props["color"]?.value as? String).flatMap { Color(hex: $0) },
                custom: nil
            )

            let action = try? JSONDecoder().decode(
                Action.self,
                from: JSONSerialization.data(withJSONObject: node.props["action"]?.value ?? [:])
            )

            SduiButton(props: buttonProps, style: style, action: action)

        case "SduiTextField":
            let textFieldProps = TextFieldProps(
                text: resolveStateValue(node.props["text"]?.value as? String ?? ""),
                placeholder: node.props["placeholder"]?.value as? String ?? "",
                isSecure: node.props["isSecure"]?.value as? Bool ?? false,
                isDisabled: node.props["isDisabled"]?.value as? Bool ?? false,
                keyboardType: (node.props["keyboardType"]?.value as? String).flatMap(TextFieldProps.KeyboardType.init) ?? .default
            )
            
            let style = StyleProps(from: node.props["style"]?.value as? [String: AnyCodable] ?? [:])
            
            SduiTextField(props: textFieldProps, style: style)

        case "SduiIcon":
            let iconProps = IconProps(
                name: node.props["name"]?.value as? String ?? "",
                size: node.props["size"]?.value as? Double ?? 16,
                color: node.props["color"]?.value as? String
            )
            
            SduiIcon(props: iconProps)

        case "SduiPicker":
            let pickerProps = PickerProps(
                selectedValue: resolveStateValue(node.props["selectedValue"]?.value as? String ?? ""),
                options: (node.props["options"]?.value as? [[String: Any]] ?? []).compactMap { dict in
                    guard let label = dict["label"] as? String,
                          let value = dict["value"] as? String else { return nil }
                    return PickerOption(label: label, value: value)
                },
                placeholder: node.props["placeholder"]?.value as? String
            )
            
            SduiPicker(props: pickerProps)

        case "SduiImageUploader":
            let imageUploaderProps = ImageUploaderProps(
                imageUrl: resolveStateValue(node.props["imageUrl"]?.value as? String),
                placeholder: node.props["placeholder"]?.value as? String ?? "Tap to upload image",
                maxSize: node.props["maxSize"]?.value as? Int,
                allowedTypes: node.props["allowedTypes"]?.value as? [String] ?? ["jpg", "png"]
            )
            
            SduiImageUploader(props: imageUploaderProps)

            
        case "SduiVStack":
            VStack(spacing: (node.props["spacing"]?.value as? Double).map { CGFloat($0) } ?? 8) {
                ForEach(node.children ?? []) { child in
                    SduiRenderer(node: child, stateManager: stateManager)
                }
            }
            
        case "SduiHStack":
            HStack(spacing: (node.props["spacing"]?.value as? Double).map{CGFloat($0)} ?? 8) {
                ForEach(node.children ?? []) { child in
                    SduiRenderer(node: child, stateManager: stateManager)
                }
            }
            
        case "SduiSpacer":
            Spacer(minLength: (node.props["minLength"]?.value as? Double).map{CGFloat($0)})
            
        default:
            EmptyView()
        }
    }
    
    // 解析状态值或直接返回值
    private func resolveStateValue<T>(_ value: T) -> T {
        // 如果值是字符串且以 @state: 开头，则从状态管理器获取值
        if let stringValue = value as? String,
           stringValue.hasPrefix("@state:"),
           let stateManager = stateManager {
            let stateKey = String(stringValue.dropFirst(7)) // 移除 "@state:" 前缀
            return stateManager.getValue(stateKey) ?? value
        }
        return value
    }
}

extension SduiRenderer {
    static func renderWithState(node: ComponentNode) -> some View {
        if let stateConfig = node.state {
            // 创建带状态的渲染器
            let stateManager = SduiStateManager(configuration: stateConfig)
            return AnyView(SduiRenderer(node: node, stateManager: stateManager))
        } else {
            // 普通渲染器
            return AnyView(SduiRenderer(node: node))
        }
    }
}


