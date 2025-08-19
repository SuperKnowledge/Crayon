//
//  Profile.swift
//  Crayon
//
//  Created by leetao on 2025/8/17.
//

import SwiftUI


struct Profile: View {
    @ObservedObject var authManager = AuthenticationManager()
    
    // MARK: - State Variables for UI
    @State private var isShowingLoginForm = false
    @State private var emailInput = ""

    var body: some View {
        NavigationView {
            Form {
                // MARK: - Section 1: User Info / Login
                Section {
                    if authManager.isLoggedIn, let email = authManager.userEmail {
                
                        HStack(spacing: 15) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                            
                            Text(email)
                                .font(.headline)
                        }
                        .padding(.vertical, 8)
                    } else {
                        VStack(alignment: .leading, spacing: 15) {
                            Button(action: {
                                withAnimation(.spring()) {
                                    isShowingLoginForm.toggle()
                                }
                            }) {
                                HStack(spacing: 15) {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.accentColor)
                                    
                                    Text("Login")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption.bold())
                                        .foregroundColor(.secondary)
                                        .rotationEffect(.degrees(isShowingLoginForm ? 90 : 0))
                                }
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                            if isShowingLoginForm {
                                TextField("Enter your email", text: $emailInput)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                
                                Button(action: {
                                    authManager.login(email: emailInput)
                                }) {
                                    Text("Confirm Login")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                                .disabled(emailInput.isEmpty)
                            }
                        }
                    }
                }
                
                // MARK: - Section 2: App Info
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion())
                            .foregroundColor(.secondary)
                    }
                }
                
                // MARK: - Section 3: Logout Button
                if authManager.isLoggedIn {
                    Section {
                        Button(action: {
                            authManager.logout()
                        }) {
                            Text("Logout")
                                .font(.headline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
    
    // MARK: - Helper Function
    private func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
}

// MARK: - Enhanced Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
            .previewDisplayName("Logged Out")

        Profile(authManager: {
            let manager = AuthenticationManager()
            manager.isLoggedIn = true
            manager.userEmail = "example@swiftui.com"
            return manager
        }())
        .previewDisplayName("Logged In")
    }
}
