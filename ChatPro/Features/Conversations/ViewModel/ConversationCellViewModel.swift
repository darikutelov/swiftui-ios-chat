//
//  ConversationCellViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 11.10.24.
//

import Foundation

final class ConversationCellViewModel: ObservableObject {
    let message: Message
    
    init(message: Message) {
        self.message = message
    }
    
    var chatPartnerFullname: String {
        return message.user?.fullname ?? ""
    }
    
    var chatPartnerImageUrl: URL? {
        guard let profileImageUrl = message.user?.profileImageUrl else { return nil }
        return URL(string: profileImageUrl)
    }
}
