//
//  ContentView.swift
//  Crayon
//
//  Created by leetao on 2025/8/3.
//

import SwiftUI

struct ContentView: View {
    @State private var rootNode: UINode?
    
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                if let node = rootNode {
                    DynamicViewRenderer(node: node)
                } else {
                    ProgressView()
                        .onAppear(perform: loadUI)
                }
            }
            .navigationTitle("Dynamic UI")
            .navigationDestination(for: String.self) { screenId in
                DynamicDetailView(screenId: screenId)
            }
        }
        .onReceive(ActionHandler.shared.navigationSubject) { destinationId in
            navigationPath.append(destinationId)
        }
    }

    func loadUI() {
        // Your existing JSON loading logic...
        let jsonString = """
        {
          "id": "root",
          "type": "VStack", "properties": {"spacing": 20},
          "children": [
            {"id": "title", "type": "Text", "properties": {"text": "Welcome!", "fontSize": 24}},
            {
              "id": "nav_button", "type": "Button",
              "properties": {"label": {"id": "btn_label", "type": "Text", "properties": {"text": "Go to Details"}}},
              "actions": [{"trigger": "onClick", "type": "NAVIGATE", "payload": {"destination": "product_123"}}]
            }
          ]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        self.rootNode = try? JSONDecoder().decode(UINode.self, from: jsonData)
    }
}

// A simple detail view to navigate to
struct DynamicDetailView: View {
    let screenId: String
    
    var body: some View {
        Text("You have navigated to screen: \(screenId)")
            .font(.largeTitle)
            .navigationTitle(screenId)
    }
}

#Preview {
    ContentView()
}
