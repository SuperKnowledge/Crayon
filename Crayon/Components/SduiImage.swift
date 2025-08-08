//
//  SduiImage.swift
//  Crayon
//
//  Created by leetao on 2025/8/8.
//

import SwiftUI

struct SduiImage: View {
    let url: String
    let style: StyleProps
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(style.cornerRadius ?? 0)
        } placeholder: {
            ProgressView()
        }
    }
}
