//
//  ImageUploadProps.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import SwiftUI
import UIKit

struct ImageUploadProps: Codable {
    var imageUrl: String?
    var placeholderImageName: String? // 占位图
}

struct SduiImageUpload: View {
    @State private var image: UIImage?
    let props: ImageUploadProps
    let action: Action?
    @State private var showingPicker = false
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image).resizable().scaledToFit()
            } else if let url = props.imageUrl, let uiImage = loadImageFromURL(url) {
                Image(uiImage: uiImage).resizable().scaledToFit()
            } else if let placeholder = props.placeholderImageName {
                Image(placeholder).resizable().scaledToFit()
            }
            
            Button("Upload") {
                showingPicker = true
            }
        }
        .sheet(isPresented: $showingPicker) {
            ImagePicker(sourceType: .photoLibrary) { pickedImage in
                image = pickedImage
                if let action = action {
                    // 假设 ActionInterpreter 支持 image 上传处理
                    ActionInterpreter.shared.handle(action)
                }
            }
        }
    }
    

    func loadImageFromURL(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }

}
