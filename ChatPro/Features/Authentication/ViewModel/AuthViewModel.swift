//
//  AuthViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 6.10.24.
//

import FirebaseAuth
import UIKit

@MainActor
final class AuthViewModel: NSObject, ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var username = ""
    @Published var isAuthenticated = false
    @Published var showAlert = false
    @Published var authError: AuthError?
    @Published var isLoading = false
    
    private let service: AuthService
    
    init(service: AuthService) {
        self.service = service
        if service.userSession != nil {
            isAuthenticated = true
        }
    }
    
    func login() async {
        isLoading = true
        
        do {
            try await service.login(withEmail: email, password: password)
            isLoading = false
            isAuthenticated = service.userSession != nil
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
            try await service.createUser(email: email, password: password,
                                         username: username, fullname: fullname)
            isLoading = false
            isAuthenticated = service.userSession != nil
        } catch {
            let authErrorCode = AuthErrorCode(rawValue: (error as NSError).code)
            showAlert = true
            isAuthenticated = false
            isLoading = false
            authError = AuthError(authErrorCode: authErrorCode ?? .userNotFound)
        }
    }
    
    func uploadProfigeImage(_ image: UIImage) async {
        do {
            try await service.uploadUserAvatar(image)
        } catch {
            showAlert = true
            authError = .unknown
        }
    }
    
    func signout() {
        service.signout()
        isAuthenticated = service.userSession != nil
    }
}
