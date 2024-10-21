//
//  MessageViewViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 10.10.24.
//

import Foundation

struct MessageViewViewModel {
    let message: Message
    let currentUser: User?
    
    var isFromCurrentUser: Bool {
        message.fromId == currentUser?.id
    }
    
    var profileImageUrl: URL? {
        guard let profileImageUrl = message.user?.profileImageUrl else { return nil }
        return URL(string: profileImageUrl)
    }
}
