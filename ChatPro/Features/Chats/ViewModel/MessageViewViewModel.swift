//
//  MessageViewViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 10.10.24.
//

import Foundation

final class MessageViewViewModel: ObservableObject {
    let message: Message
    let currentUser: User?
    
    init(message: Message, currentUser: User?) {
        self.message = message
        self.currentUser = currentUser
    }
    
    var isFromCurrentUser: Bool {
        message.fromId == currentUser?.id
    }
    
    var profileImageUrl: URL? {
        guard let profileImageUrl = message.user?.profileImageUrl else { return nil }
        return URL(string: profileImageUrl)
    }
}
