//
//  DynamicViewRenderer.swift
//  Crayon
//
//  Created by leetao on 2025/8/3.
//

import SwiftUI


struct DynamicViewRenderer: View {
    let node: UINode

    var body: some View {
        render(node: node)
    }

    @ViewBuilder
    private func render(node: UINode) -> some View {
        // Switch on the component type
        switch node.type {
        case .VStack:
            VStack(spacing: node.properties?.spacing) {
                // Recursively render children
                if let children = node.children {
                    ForEach(children) { childNode in
                        DynamicViewRenderer(node: childNode)
                    }
                }
            }
            .applyModifiers(from: node.properties)

        case .HStack:
            HStack(spacing: node.properties?.spacing) {
                if let children = node.children {
                    ForEach(children) { childNode in
                        DynamicViewRenderer(node: childNode)
                    }
                }
            }
            .applyModifiers(from: node.properties)

        case .Text:
            if let text = node.properties?.text {
                Text(text)
                    .applyModifiers(from: node.properties)
            }

        case .Image:
            if let urlString = node.properties?.url, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .applyModifiers(from: node.properties)
            }
            
        case .Button:
            Button(action: {
                // Find the onClick action and handle it
                if let action = node.actions?.first(where: { $0.trigger == "onClick" }) {
                    ActionHandler.shared.handle(action)
                }
            }) {
                // A button's label is another node, so render it
                if let labelNode = node.properties?.label {
                    DynamicViewRenderer(node: labelNode)
                }
            }
            .applyModifiers(from: node.properties)

        case .Spacer:
            Spacer()
        }
    }
}

// Helper to avoid repetitive code
extension View {
    @ViewBuilder
    func applyModifiers(from properties: UIProperties?) -> some View {
        let view = self
        if let properties = properties {
            // This is where you map JSON properties to SwiftUI modifiers
            view
                .padding(properties.padding ?? 0)
                .frame(width: properties.width, height: properties.height)
                .background(Color(properties.backgroundColor ?? "#00000000")) // Custom Color init
                .cornerRadius(properties.cornerRadius ?? 0)
                
        } else {
            view
        }
    }
}
