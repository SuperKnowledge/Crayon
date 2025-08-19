//
//  ContentView.swift
//  Crayon
//
//  Created by leetao on 2025/8/3.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabItem = .home
    @State private var showInputDialog = false;
    @State private var userInput:String = "";

    var body: some View {
        ZStack(alignment: .bottom) {
            mainContentView
            HStack(alignment:.center, spacing: 32){
                    CustomBottomNavBar(
                        items: TabItem.allCases,
                        selectedTab: $selectedTab
                    )
            
                    PrimaryActionBtn {
                        showInputDialog.toggle()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 8)
                .buttonStyle(.plain)
        }
        .onChange(of: selectedTab) { newTab in
            print("Tab changed to: \(newTab)")
        }.sheet(isPresented:$showInputDialog) {
            UserInputTextField(text: $userInput) { description in
                
            }
        }
    }
    
    @ViewBuilder
    private var mainContentView: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            switch selectedTab {
            case .home:
                Home()
                    .navigationTitle("Home")
            case .apps:
                 Apps()
                    .navigationTitle("App")
            case .profile:
                Profile()
                    .navigationTitle("Profile")
            }
        }
    }
    
}


#Preview {
    ContentView()
}
