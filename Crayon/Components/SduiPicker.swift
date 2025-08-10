//
//  SduiPicker.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//
import SwiftUI



struct PickerOption {
    let label: String
    let value: String
}

struct PickerProps {
    let selectedValue: String
    let options: [PickerOption]
    let placeholder: String?
}


struct SduiPicker: View {
    let props: PickerProps
    
    var body: some View {
        Picker(props.placeholder ?? "Select", selection: .constant(props.selectedValue)) {
            ForEach(props.options, id: \.value) { option in
                Text(option.label).tag(option.value)
            }
        }
        .pickerStyle(MenuPickerStyle())
    }
}

