//
//  ChannelMessage.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 17.10.24.
//

import Foundation
import FirebaseFirestore

struct ChannelMessage: Identifiable, Codable {
    @DocumentID var id: String?
    let fromId: String
    let timestamp: Timestamp
    let text: String
    var user: User?
    
    var encodedMessage: [String: Any] {
        return (try? Firestore.Encoder().encode(self)) ?? [:]
    }
}


let MOCK_CHANNEL_MESSAGE = ChannelMessage(
    fromId: "Em7beCNP9EOPjpXoyk1HZ6mNOT33",
    timestamp: Timestamp(date: Date()),
    text: "Hi, there",
    user: MOCK_USER
)
