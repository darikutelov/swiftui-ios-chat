//
//  UsersService.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 9.10.24.
//

import FirebaseFirestore

final class UsersService {
    func fetchUsers() async throws -> [User] {
        let snapshot = try await FirestoreConstants.UserCollection.getDocuments()
        
        let users = try snapshot.documents.compactMap { document in
            try document.data(as: User.self)
        }

        return users
    }
}
