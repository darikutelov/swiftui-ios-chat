//
//  UserService.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 9.10.24.
//

import UIKit
import FirebaseFirestore

protocol UserServiceProtocol {
    func fetchUser(withUid uid: String) async throws -> User
    func fetchUsers() async throws -> [User]
    func createUser(id: String, username: String, email: String, fullname: String) async throws
    func saveUser(_ user: User) async throws
    func uploadUserAvatar(_ image: UIImage, userId: String) async throws
}

final class UserService: UserServiceProtocol {
    func fetchUser(withUid uid: String) async throws -> User {
        return try await FirestoreConstants.UserCollection.document(uid).getDocument(as: User.self)
    }
    
    func fetchUsers() async throws -> [User] {
        let snapshot = try await FirestoreConstants.UserCollection.getDocuments()
        
        let users = try snapshot.documents.compactMap { document in
            try document.data(as: User.self)
        }
        
        return users
    }
    
    func createUser(id: String, username: String, email: String, fullname: String) async throws {
        do {
            let user = User(id: id, username: username, email: email, fullname: fullname)
            let userData = try Firestore.Encoder().encode(user)
            
            try await FirestoreConstants.UserCollection.document(id).setData(userData)
        } catch {
            print("DEBUG: Profile image failed \(error.localizedDescription)")
            throw error
        }
    }
    
    func saveUser(_ user: User) async throws {
        guard let userId = user.id else {
            throw NSError(domain: "UserServiceError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is missing"])
        }
        
        var userData: [String: String] = [
            "fullname": user.fullname,
        ]
        
        if let profileImageUrl = user.profileImageUrl {
            userData["profileImageUrl"] = profileImageUrl
        }
        
        do {
            try await FirestoreConstants.UserCollection.document(userId).updateData(userData)
        } catch {
            print("DEBUG: Failed to update user: \(error.localizedDescription)")
            throw error
        }
    }
    
    func uploadUserAvatar(_ image: UIImage, userId: String) async throws {
        do {
            let profileImageUrl = try await ImageUploader.uploadImage(image: image, folderName: "avatars")
            try await FirestoreConstants.UserCollection.document(userId).updateData(["profileImageUrl": profileImageUrl])
        } catch {
            print("DEBUG: Profile image failed \(error.localizedDescription)")
            throw error
        }
    }
}
