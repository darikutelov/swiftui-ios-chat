//
//  AuthViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 6.10.24.
//

import FirebaseAuth
import UIKit
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    
    @Published var hasRegistered = false
    @Published var showAlert = false
    @Published var authError: AuthError?
    @Published var isLoading = false
    
    var userManager: UserManager
    
    init(userManager: UserManager) {
        self.userManager = userManager
    }
    
    func login() async {
        isLoading = true
        do {
            try await userManager.login(email: email, password: password)
            isLoading = false
        } catch {
            let authError = AuthErrorCode(rawValue: (error as NSError).code)
            self.showAlert = true
            isLoading = false
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
        }
    }
    
    func createUser() async {
        isLoading = true
        do {
            try await userManager.createUser(email: email, password: password,
                                         username: username, fullname: fullname)
            isLoading = false
            hasRegistered = true
        } catch {
            let authErrorCode = AuthErrorCode(rawValue: (error as NSError).code)
            showAlert = true
            isLoading = false
            authError = AuthError(authErrorCode: authErrorCode ?? .userNotFound)
        }
    }
    
    func uploadProfigeImage(_ image: UIImage) async {
        do {
            try await userManager.uploadAvatar(image)
        } catch {
            showAlert = true
            authError = .unknown
        }
    }
    
    func signout() {
        email = ""
        password = ""
        fullname = ""
        username = ""
        showAlert = false
        authError = nil
        hasRegistered = false
        userManager.signout()
    }
}
