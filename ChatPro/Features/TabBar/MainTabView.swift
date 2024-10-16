//
//  MainTabView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

enum AppTabs: Hashable, Identifiable, CaseIterable {
    case conversations
    case channels
    case settings
    
    var id: AppTabs { self }
    
    var tag: Int {
        switch self {
        case .conversations: return 0
        case .channels: return 1
        case .settings: return 2
        }
    }
}

extension AppTabs {
    @ViewBuilder
    var label: some View {
        switch self {
        case .conversations:
            Label("Chats", systemImage: "bubble.left")
        case .channels:
            Label("Rooms", systemImage: "bubble.left.and.bubble.right")
        case .settings:
            Label("Settings", systemImage: "gear")
        }
    }
    
    @MainActor @ViewBuilder
    func destination(userManager: UserManager) -> some View {
        switch self {
        case .conversations:
            ConversationScreen(userManager: userManager)
        case .channels:
            ChannelScreen(userManager: userManager)
        case .settings:
            SettingsScreen(userManager: userManager)
        }
    }
}

struct MainTabView: View {
    @ObservedObject var userManager: UserManager
    @State private var selectedIndex = 0
    
    let tabs: [AppTabs] = [.conversations, .channels, .settings]
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(tabs) { tab in
                tab.destination(userManager: userManager)
                    .tabItem {
                        tab.label
                    }
                    .tag(tab.tag)
            }
        }
        .tint(Color(.customPrimary))
     }
}

#Preview {
    MainTabView(
        userManager: UserManager(authService: AuthService(), userService: UserService())
    )
}
