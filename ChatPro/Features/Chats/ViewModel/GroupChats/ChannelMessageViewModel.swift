//
//  ChannelMessageViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 17.10.24.
//

import Foundation

struct ChannelMessageViewModel {
    let message: ChannelMessage
    let currentUser: User?
    
    var isFromCurrentUser: Bool { return message.fromId == currentUser?.id }
    
    var fullname: String {
        return message.user?.fullname ?? ""
    }
}
