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
    @Published var editableUser: EditableUser
    @Published var isAuthenticated: Bool?
    
    private let authService: AuthService
    private let userService: UserService
    
    struct EditableUser {
        var fullname: String
        var profileImageUrl: String?
    }
    
    init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService
        editableUser = EditableUser(fullname: "", profileImageUrl: "")
        
        Task {
            await loadUser()
        }
    }
    
    func login(email: String, password: String) async throws {
        do {
            let _ = try await authService.login(withEmail: email, password: password)
            self.isAuthenticated = true
            await loadUser()
        } catch {
            print("DEBUG: Login failed \(error.localizedDescription)")
            throw error
        }
    }
    
    func signout() {
        authService.signout()
        currentUser = nil
        self.isAuthenticated = false
    }
}


// MARK: - Current User Profile
extension UserManager {
    func loadUser() async {
        guard let userId = authService.userSession?.uid else {
            isAuthenticated = false
            return
        }
        self.isAuthenticated = true
        do {
            currentUser = try await userService.fetchUser(withUid: userId)
            editableUser.fullname = currentUser?.fullname ?? ""
            editableUser.profileImageUrl = currentUser?.profileImageUrl ?? ""
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createUser(email: String, password: String, username: String, fullname: String) async throws {
        do {
            let _ = try await authService.createUser(email: email, password: password, username: username, fullname: fullname)
            
            guard let userId = authService.userSession?.uid else { return }
            self.isAuthenticated = true
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
            print("DEBUG: Failed to upload user avatar with error: \(error.localizedDescription)")
            throw error
        }
        await loadUser()
    }
    
    func saveChanges() async throws {
        currentUser?.fullname = editableUser.fullname
        
        if editableUser.profileImageUrl != "" {
            currentUser?.profileImageUrl = editableUser.profileImageUrl
        }
        
        do {
            guard let user = currentUser else { return }
            let _ = try await userService.saveUser(user)
        } catch {
            print("DEBUG: Failed to save user with error: \(error.localizedDescription)")
            throw error
        }
    }
}


// MARK: - Users
extension UserManager {
    func fetchUsers() async throws -> [User] {
        guard let currentUserUid = currentUser?.id else { return [User]() }
        do {
            return try await userService.fetchUsers(currentUserUid: currentUserUid)
        } catch {
            print("DEBUG: Failed to fetch users with error: \(error.localizedDescription)")
            throw error
        }
    }
}
