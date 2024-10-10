//
//  MessageService.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 10.10.24.
//

import Foundation
import FirebaseFirestore

protocol MessageServiceProtocol {
    func fetchMessages(currentUserId: String, chatPartnerId: String ) async throws -> [Message]
    func saveMessage(currentUserId: String, chatPartnerId: String , text: String) async throws -> String
}

final class MessageService: MessageServiceProtocol {

    func fetchMessages(currentUserId: String, chatPartnerId: String ) async throws -> [Message] {
        let snapshot = try await FirestoreConstants.MessagesCollection
            .document(currentUserId)
            .collection(chatPartnerId)
            .getDocuments()
        
        let messages = try snapshot.documents.compactMap { document in
            try document.data(as: Message.self)
        }
        
        return messages
    }
    
    func saveMessage(currentUserId: String, chatPartnerId: String , text: String) async throws -> String {
        let currentUserRef = FirestoreConstants.MessagesCollection
            .document(currentUserId)
            .collection(chatPartnerId)
            .document()
        
        let chatPartnerRef = FirestoreConstants.MessagesCollection
            .document(chatPartnerId)
            .collection(currentUserId)
        
        let messageId = currentUserRef.documentID
        
        let data: [String: Any] = ["text": text,
                                   "fromId": currentUserId,
                                   "toId": chatPartnerId,
                                   "read": false,
                                   "timestamp": Timestamp(date: Date())
        ]
        
        do {
            try await currentUserRef.setData(data)
            try await chatPartnerRef.document(messageId).setData(data)
            return messageId
            
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
