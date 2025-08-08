//
//  SduiPicker.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//
import SwiftUI

struct PickerOption: Codable, Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

struct PickerProps: Codable {
    var selectedValue: String
    var options: [PickerOption]
}


struct SduiPicker: View {
    @State private var selectedValue: String
    let props: PickerProps
    let action: Action?
    
    init(props: PickerProps, action: Action?) {
        self.props = props
        self.action = action
        _selectedValue = State(initialValue: props.selectedValue)
    }
    
    var body: some View {
        Picker(selection: $selectedValue, label: Text("Select")) {
            ForEach(props.options) { option in
                Text(option.label).tag(option.value)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: selectedValue) { newValue in
            guard var payload = action?.payload else { return }
                payload["selectedValue"] = AnyCodable(newValue)
                var newAction = action!
                newAction.payload = payload
                ActionInterpreter.shared.handle(newAction)
        }
    }
}
