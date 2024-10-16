//
//  Channel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 12.10.24.
//

import FirebaseFirestore

struct Channel: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var name: String
    var imageUrl: String?
    var uids: [String]
    var lastMessage: String
    
    var encodedChannel: [String: Any] {
        return (try? Firestore.Encoder().encode(self)) ?? [:]
    }
}


let MOCK_CHANNEL = Channel(id: "123", name: "Test Channel", imageUrl: "https://cdn.britannica.com/65/137465-050-0A58A7AB/Sade-album-cover-Soldier-of-Love.jpg", uids: ["123", "123"], lastMessage: "Hi, there")
