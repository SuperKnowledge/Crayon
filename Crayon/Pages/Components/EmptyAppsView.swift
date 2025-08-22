//
//  EmptyAppsView.swift
//  Crayon
//
//  Created by leetao on 2025/8/21.
//

import SwiftUI

struct EmptyAppsView: View {
    let showBookmarkedOnly: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            // Icon
            Image(systemName: showBookmarkedOnly ? "bookmark.slash" : "app.dashed")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            // Title and Message
            VStack(spacing: 8) {
                Text(showBookmarkedOnly ? "No Bookmarked Apps" : "No Recent Apps")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(showBookmarkedOnly 
                     ? "You haven't bookmarked any apps yet. Browse and bookmark apps you love!"
                     : "You haven't used any apps yet. Start exploring to see your recent apps here!")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Action Button
            Button(action: {
                // TODO: Navigate to app store or apps list
            }) {
                HStack {
                    Image(systemName: "plus.app")
                    Text("Explore Apps")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    Group {
        EmptyAppsView(showBookmarkedOnly: false)
            .previewDisplayName("No Recent Apps")
        
        EmptyAppsView(showBookmarkedOnly: true)
            .previewDisplayName("No Bookmarked Apps")
    }
}
