//
//  MainView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 8.10.24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    init() {
        authViewModel = AuthViewModel(service: AuthService())
    }

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView(authViewModel: authViewModel)
            } else {
                LoginView(viewModel: authViewModel)
            }
        }
    }
}

#Preview {
    MainView()
}
