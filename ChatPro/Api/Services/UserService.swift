//
//  UserService.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 9.10.24.
//

import UIKit
import FirebaseFirestore

final class UserService {
    func fetchUser(withUid uid: String) async throws -> User {
        return try await FirestoreConstants.UserCollection.document(uid).getDocument(as: User.self)
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
