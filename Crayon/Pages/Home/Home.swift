//
//  Home.swift
//  Crayon
//
//  Created by leetao on 2025/8/17.
//

import SwiftUI

struct Home: View {
    @StateObject private var appsViewModel = AppsViewModel()
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var showingAlert = false
    @State private var showValidationTest = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Content
                if appsViewModel.isLoading {
                    loadingView
                } else if appsViewModel.recentApps.isEmpty {
                    EmptyAppsView(showBookmarkedOnly: appsViewModel.showBookmarkedOnly)
                } else {
                    appsListView
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadApps()
            }
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { appsViewModel.errorMessage = nil }
            } message: {
                Text(appsViewModel.errorMessage ?? "Unknown error")
            }
            .onChange(of: appsViewModel.errorMessage) { _, newError in
                showingAlert = newError != nil
            }
            .sheet(isPresented: $showValidationTest) {
                ValidationTestView()
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome back!")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if let email = authManager.userEmail {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    // Debug/Test button
                    Button(action: {
                        showValidationTest = true
                    }) {
                        Image(systemName: "testtube.2")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                    
                    Button(action: {
                        loadApps()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                    .disabled(appsViewModel.isLoading)
                }
            }
            
            // Filter Toggle
            HStack {
                Button(action: {
                    appsViewModel.toggleBookmarkedFilter(token: getToken())
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: appsViewModel.showBookmarkedOnly ? "bookmark.fill" : "bookmark")
                        Text(appsViewModel.showBookmarkedOnly ? "Bookmarked Only" : "All Apps")
                    }
                    .font(.subheadline)
                    .foregroundColor(appsViewModel.showBookmarkedOnly ? .white : .accentColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(appsViewModel.showBookmarkedOnly ? Color.accentColor : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.accentColor, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .disabled(appsViewModel.isLoading)
                
                Spacer()
                
                Text("\(appsViewModel.recentApps.count) apps")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading your apps...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Apps List View
    private var appsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(appsViewModel.recentApps, id: \.publicationId) { app in
                    AppCardView(
                        appUsage: app,
                        onBookmarkToggle: {
                            appsViewModel.toggleBookmark(for: app, token: getToken())
                        },
                        onRemove: {
                            appsViewModel.removeApp(publicationId: app.publicationId, token: getToken())
                        }
                    )
                }
            }
            .padding()
        }
        .refreshable {
            loadApps()
        }
    }
    
    // MARK: - Helper Methods
    private func loadApps() {
        appsViewModel.fetchRecentApps(token: getToken())
    }
    
    private func getToken() -> String {
        // TODO: Get actual token from AuthenticationManager or secure storage
        // For now, using the default empty token from ApiProtocol
        return AppApi.token
    }
}

#Preview {
    Home()
        .environmentObject(AuthenticationManager())
}
