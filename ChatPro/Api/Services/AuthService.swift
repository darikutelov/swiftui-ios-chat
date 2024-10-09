//
//  AuthService.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 7.10.24.
//


import FirebaseAuth
import FirebaseFirestore

protocol AuthServiceProtocol {
    func createUser(email: String, password: String, username: String, fullname: String) async throws
    func login(withEmail email: String, password: String) async throws
    func signout() async
}

@MainActor
final class AuthService: AuthServiceProtocol {
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        updateUserSession()
    }
    
    func updateUserSession() {
        self.userSession = Auth.auth().currentUser
    }
    
    func createUser(email: String, password: String, username: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = User(id: result.user.uid, username: username, email: email, fullname: fullname)
            let userData = try Firestore.Encoder().encode(user)

            try await FirestoreConstants.UserCollection.document(result.user.uid).setData(userData)
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("DEBUG: Login failed \(error.localizedDescription)")
            throw error
        }
    }
    
    func sendResetPasswordLink(toEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signout() {
        self.userSession = nil
        try? Auth.auth().signOut()
    }
}

