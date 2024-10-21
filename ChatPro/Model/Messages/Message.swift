//
//  Message.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 6.10.24.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.timestamp.nanoseconds >= rhs.timestamp.nanoseconds
    }
    
    @DocumentID var id: String?
    let fromId: String
    let toId: String
    var read: Bool
    let text: String
    let timestamp: Timestamp
    
    var user: User?
    
    var encodedMessage: [String: Any] {
        return (try? Firestore.Encoder().encode(self)) ?? [:]
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromId
        case toId
        case read
        case text
        case timestamp
    }
    
    init(id: String? = nil, fromId: String, toId: String, read: Bool, text: String, timestamp: Timestamp) {
        self.id = id
        self.fromId = fromId
        self.toId = toId
        self.read = read
        self.text = text
        self.timestamp = timestamp
    }
}

let MOCK_MESSAGE = Message(fromId: "Em7beCNP9EOPjpXoyk1HZ6mNOT33",
                           toId: "FOWOuSVFnOXAtAXAJ62Q0SduR6i2",
                           read: false,
                           text: "Hi, there. How are you? Nice to talk to you. I feel awesome!",
                           timestamp: Timestamp(date: Date()))
