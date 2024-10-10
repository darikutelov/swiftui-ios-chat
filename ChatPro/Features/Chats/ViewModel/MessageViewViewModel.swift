//
//  MessageViewViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 10.10.24.
//

import Foundation

final class MessageViewViewModel: ObservableObject {
    let message: Message
    let currentUser: User
    @Published var isShowing = false
    
    var isFromCurrentUser: Bool {
        message.fromId == currentUser.id
    }
    
    init(message: Message, currentUser: User) {
        self.message = message
        self.currentUser = currentUser
    }
}
