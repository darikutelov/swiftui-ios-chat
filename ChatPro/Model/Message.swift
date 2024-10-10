//
//  Message.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 6.10.24.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Equatable, Decodable {
    @DocumentID var id: String?
    let fromId: String
    let toId: String
    var read: Bool
    let text: String
    let timestamp: Timestamp
}

let MOCK_MESSAGE = Message(fromId: "Em7beCNP9EOPjpXoyk1HZ6mNOT33",
                           toId: "FOWOuSVFnOXAtAXAJ62Q0SduR6i2",
                           read: false,
                           text: "Hi, there",
                           timestamp: Timestamp(date: Date()))
