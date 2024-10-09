//
//  MainView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 8.10.24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var userManager: UserManager
    
    init() {
        userManager = UserManager(
            authService: AuthService(),
            userService: UserService()
        )
    }

    var body: some View {
        Group {
            if userManager.currentUser == nil {
                LoginView(userManager: userManager)
            } else {
                MainTabView(userManager: userManager)
            }
        }
    }
}

#Preview {
    MainView()
}
