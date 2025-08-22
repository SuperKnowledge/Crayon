//
//  AppsViewModel.swift
//  Crayon
//
//  Created by leetao on 2025/8/21.
//

import Foundation
import Combine

class AppsViewModel: ObservableObject {
    @Published var recentApps: [AppUsageResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showBookmarkedOnly: Bool = false
    @Published var useMockData: Bool = true // For development purposes
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchRecentApps(token: String) {
        isLoading = true
        errorMessage = nil
        
        // Use mock data for development
        if useMockData {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Simulate network delay
                self.isLoading = false
                self.recentApps = self.showBookmarkedOnly ? MockData.bookmarkedApps : MockData.sampleApps
            }
            return
        }
        
        AppApi.getAppsIUse(bookmarkedOnly: showBookmarkedOnly, token: token) { [weak self] data, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Failed to fetch apps: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(AppUsageListResponse.self, from: data)
                    self?.recentApps = response.apps
                } catch {
                    self?.errorMessage = "Failed to parse response: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func toggleBookmark(for app: AppUsageResponse, token: String) {
        if useMockData {
            // Simulate bookmark toggle for mock data
            if let index = recentApps.firstIndex(where: { $0.publicationId == app.publicationId }) {
                // Create a new instance with updated bookmark status
                let updatedApp = AppUsageResponse(
                    publicationId: app.publicationId,
                    shareToken: app.shareToken,
                    title: app.title,
                    description: app.description,
                    authorEmail: app.authorEmail,
                    firstUsedAt: app.firstUsedAt,
                    lastUsedAt: app.lastUsedAt,
                    useCount: app.useCount,
                    isBookmarked: !app.isBookmarked,
                    isForkable: app.isForkable
                )
                recentApps[index] = updatedApp
            }
            return
        }
        
        let newBookmarkState = !app.isBookmarked
        
        AppApi.toggleBookmark(
            publicationId: app.publicationId.uuidString,
            isBookmarked: newBookmarkState,
            token: token
        ) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to toggle bookmark: \(error.localizedDescription)"
                } else {
                    // Update the local state
                    if let index = self?.recentApps.firstIndex(where: { $0.publicationId == app.publicationId }) {
                        var updatedApp = app
                        // Note: Since AppUsageResponse properties are let constants, we need to fetch the data again
                        // or create a mutable version. For now, let's refresh the data
                        self?.fetchRecentApps(token: token)
                    }
                }
            }
        }
    }
    
    func removeApp(publicationId: UUID, token: String) {
        if useMockData {
            // Remove from mock data
            recentApps.removeAll { $0.publicationId == publicationId }
            return
        }
        
        AppApi.removeFromUsedApps(
            publicationId: publicationId.uuidString,
            token: token
        ) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Failed to remove app: \(error.localizedDescription)"
                } else {
                    // Remove from local array
                    self?.recentApps.removeAll { $0.publicationId == publicationId }
                }
            }
        }
    }
    
    func toggleBookmarkedFilter(token: String) {
        showBookmarkedOnly.toggle()
        if useMockData {
            recentApps = showBookmarkedOnly ? MockData.bookmarkedApps : MockData.sampleApps
        } else {
            fetchRecentApps(token: token)
        }
    }
}
