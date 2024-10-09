//
//  User.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 7.10.24.
//

import Foundation
import FirebaseAuth

struct User: Identifiable, Codable {
    let id: String
    var username: String
    let email: String
    let fullname: String
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
    
    init(id: String, username: String, email: String, fullname: String, bio: String? = nil, profileImageUrl: String? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.fullname = fullname
        self.profileImageUrl = profileImageUrl
    }
}
