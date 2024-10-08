//
//  MainTabView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var sectedIndex = 0
    
    private var tabTitle: String {
        switch sectedIndex {
        case 0: return "Chats"
        case 1: return "Channels"
        case 2: return "Settings"
        default: return ""
        }
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $sectedIndex) {
                ConversationsView()
                    .tabItem {
                        Image(systemName: "bubble.left")
                    }
                    .onTapGesture {
                        sectedIndex = 0
                    }
                    .tag(0)
                
                ChannelsView()
                    .tabItem {
                        Image(systemName: "bubble.left.and.bubble.right")
                    }
                    .onTapGesture {
                        sectedIndex = 1
                    }
                    .tag(1)
                
                SettingsView(authViewModel: authViewModel)
                    .tabItem {
                        Image(systemName: "gear")
                    }
                    .onTapGesture {
                        sectedIndex = 2
                    }
                    .tag(2)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(tabTitle)
                        .headingStyle()
                }
            }
            .tint(Color(.customPrimary))
        }
    }
}

#Preview {
    MainTabView(authViewModel: AuthViewModel(service: AuthService()))
}
