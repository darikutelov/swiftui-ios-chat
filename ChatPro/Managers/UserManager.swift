//
//  UserManager.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 9.10.24.
//

import UIKit

@MainActor
final class UserManager: ObservableObject {
    @Published var currentUser: User?
    
    private let authService: AuthService
    private let userService: UserService
    
    init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService
        Task {
            await updateUser()
        }
    }
    
    func updateUser() async {
        guard let userId = authService.userSession?.uid else { return }
        
        do {
            currentUser = try await userService.fetchUser(withUid: userId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func login(email: String, password: String) async throws {
        do {
            let _ = try await authService.login(withEmail: email, password: password)
            await updateUser()
        } catch {
            print("DEBUG: Login failed \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(email: String, password: String, username: String, fullname: String) async throws {
        do {
            let _ = try await authService.createUser(email: email, password: password, username: username, fullname: fullname)
            
            guard let userId = authService.userSession?.uid else { return }
            let _ = try await userService.createUser(id: userId, username: username, email: email, fullname: fullname)
          
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func uploadAvatar(_ image: UIImage) async throws {
        guard let userId = authService.userSession?.uid else { return }
        do {
            let _ = try await userService.uploadUserAvatar(image, userId: userId)
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
            throw error
        }
        await updateUser()
    }
    
    func signout() {
        authService.signout()
        currentUser = nil
    }
}
