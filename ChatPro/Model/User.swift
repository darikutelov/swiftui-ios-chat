//
//  User.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 7.10.24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var username: String
    let email: String
    let fullname: String
    var profileImageUrl: String?
    
}
