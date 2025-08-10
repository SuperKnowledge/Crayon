//
//  ImageUploadProps.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import SwiftUI
import UIKit

struct ImageUploaderProps {
    let imageUrl: String?
    let placeholder: String
    let maxSize: Int?
    let allowedTypes: [String]
}

struct SduiImageUploader: View {
    let props: ImageUploaderProps
    @State private var showingImagePicker = false
    
    var body: some View {
        Button(action: { showingImagePicker = true }) {
            if let imageUrl = props.imageUrl, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: 200, maxHeight: 200)
            } else {
                VStack {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 40))
                    Text(props.placeholder)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                .frame(minWidth: 100, minHeight: 100)
                .border(Color.gray.opacity(0.3), width: 1)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            // Image picker implementation would go here
            Text("Image Picker Placeholder")
        }
    }
}
