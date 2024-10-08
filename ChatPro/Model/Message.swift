//
//  Message.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 6.10.24.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id = UUID().uuidString
    let isFromCurrentUser: Bool
    let messageText: String
}
