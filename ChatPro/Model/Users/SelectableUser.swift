//
//  SelectableUser.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.10.24.
//

import Foundation

struct SelectableUser: Identifiable {
    var user: User
    var isSelected: Bool
    
    var id: String { return user.id ?? NSUUID().uuidString }
}
