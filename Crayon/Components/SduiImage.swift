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
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            ProgressView()
        }
        .font(style.fontSize.map { .system(size: CGFloat($0)) } ?? .body)
               .foregroundColor(style.foregroundColor ?? .primary)
               .padding(CGFloat(style.padding ?? 0))
   
    }
}
