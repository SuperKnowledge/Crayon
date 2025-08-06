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
          "id": "vstack",
          "type": "VStack",
          "properties": {
            "spacing": 16
          },
          "children": [
            {
              "id": "vstack_2",
              "type": "VStack",
              "properties": {
                "spacing": 8
              },
              "children": [
                {
                  "id": "text",
                  "type": "Text",
                  "properties": {
                    "text": "Maximum Value:"
                  }
                },
                {
                  "id": "textfield",
                  "type": "TextField",
                  "properties": {
                    "value": "",
                    "placeholder": "Enter a number"
                  },
                  "actions": [
                    {
                      "trigger": "onChange",
                      "type": "ACTION",
                      "payload": {
                        "onChange.payload": "{{onChange.payload}}"
                      }
                    }
                  ]
                }
              ]
            },
            {
              "id": "vstack_3",
              "type": "VStack",
              "properties": {
                "spacing": 8
              },
              "children": [
                {
                  "id": "text_2",
                  "type": "Text",
                  "properties": {
                    "text": "Current Count: 0"
                  }
                },
                {
                  "id": "button",
                  "type": "Button",
                  "properties": {
                    "label": {
                      "id": "text_3",
                      "type": "Text",
                      "properties": {
                        "text": "Increment"
                      }
                    }
                  },
                  "actions": [
                    {
                      "trigger": "onClick",
                      "type": "INCREMENT",
                      "payload": {
                        "onClick.payload": "{{onClick.payload}}"
                      }
                    }
                  ]
                }
              ]
            }
          ]
        }
        """
            do {
            
            let jsonData = jsonString.data(using: .utf8)!
            self.rootNode = try JSONDecoder().decode(UINode.self, from: jsonData)
        } catch {
            Log.error("\(error)")
        }
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
