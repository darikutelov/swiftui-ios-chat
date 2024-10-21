//
//  User.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 7.10.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var fullname: String
    var profileImageUrl: String?
 
    var isCurrentUser: Bool {
        return id == Auth.auth().currentUser?.uid
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.username = try container.decode(String.self, forKey: .username)
        self.email = try container.decode(String.self, forKey: .email)
        self.fullname = try container.decode(String.self, forKey: .fullname)
        self.profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl)
    }
    
    init(id: String, username: String, email: String, fullname: String, profileImageUrl: String? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.fullname = fullname
        self.profileImageUrl = profileImageUrl
    }
}


let MOCK_USER = User(id: "1234567890", 
                     username: "sarah1999",
                     email: "sarah.doe@example.com",
                     fullname: "Sarah Doe", 
                     profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/appstuffchatpro.appspot.com/o/avatars%2F00E59A09-8E82-4CD6-8533-F1562ECE0C32?alt=media&token=b2321786-7b11-4ccd-b3ea-5b79bca4089d")
