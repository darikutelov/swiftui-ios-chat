//
//  MessageService.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 10.10.24.
//

import Foundation
import FirebaseFirestore

protocol MessageServiceProtocol {
    func fetchMessages(currentUserId: String, chatPartnerId: String, completion: @escaping ([Message]) -> Void)
    func fetchRecentMessage(userUid uid: String, completion: @escaping (Result<[Message], Error>) -> Void)
    func saveMessage(currentUserId: String, chatPartnerId: String , text: String) async throws -> String
}

final class MessageService: MessageServiceProtocol {
    func fetchMessages(currentUserId: String,
                       chatPartnerId: String,
                       completion: @escaping ([Message]) -> Void) {
        let query = FirestoreConstants.MessagesCollection
            .document(currentUserId)
            .collection(chatPartnerId)
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let messages = documents.compactMap { document -> Message? in
                try? document.data(as: Message.self)
            }
            
            completion(messages)
        }
    }
    
    func fetchRecentMessage(userUid uid: String,
                            completion: @escaping (Result<[Message], Error>) -> Void) {
        let query = FirestoreConstants.MessagesCollection
            .document(uid)
            .collection("recent-messages")
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let messages = documents.compactMap { document -> Message? in
                try? document.data(as: Message.self)
            }
            
            self.fetchUsersForMessages(messages: messages, currentUserUid: uid) { result in
                switch result {
                case .success(let messagesWithUsers):
                    completion(.success(messagesWithUsers))
                case .failure(let error):
                    print("Error fetching messages with users: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func saveMessage(currentUserId: String, chatPartnerId: String , text: String) async throws -> String {
        let currentUserRef = FirestoreConstants.MessagesCollection
            .document(currentUserId)
            .collection(chatPartnerId)
            .document()
        let recentCurrentRef = FirestoreConstants.MessagesCollection
            .document(currentUserId)
            .collection("recent-messages")
            .document(chatPartnerId)
        
        let chatPartnerRef = FirestoreConstants.MessagesCollection
            .document(chatPartnerId)
            .collection(currentUserId)
        let recentPartnerRef = FirestoreConstants.MessagesCollection
            .document(chatPartnerId)
            .collection("recent-messages")
            .document(currentUserId)
        
        let messageId = currentUserRef.documentID
        let message = Message(fromId: currentUserId, toId: chatPartnerId, read: false,
                              text: text, timestamp: Timestamp(date: Date()))
        
        do {
            try await currentUserRef.setData(message.encodedMessage)
            try await chatPartnerRef.document(messageId).setData(message.encodedMessage)
            try await recentCurrentRef.setData(message.encodedMessage)
            try await recentPartnerRef.setData(message.encodedMessage)
            return messageId
            
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    private func fetchUsersForMessages(messages: [Message],
                                       currentUserUid: String,
                                       completion: @escaping (Result<[Message], Error>) -> Void) -> Void {
        var messagesWithUsers: [Message] = []
        let group = DispatchGroup()
        
        for message in messages {
            group.enter()
            
            let userUid = message.fromId == currentUserUid ? message.toId : message.fromId
            fetchUser(uid: userUid) { result in
                switch result {
                case .success(let user):
                    var mutableMessage = message
                    mutableMessage.user = user
                    messagesWithUsers.append(mutableMessage)
                    
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(.success(messagesWithUsers))
        }
    }
    
    private func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        FirestoreConstants.UserCollection.document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                if let document = snapshot {
                    let user = try document.data(as: User.self)
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "User not found", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Async await alternative of fetchRecentMassages w/o listener for automatic refresh
    //    func fetchRecentMessage(userUid uid: String) async throws -> [Message] {
    //        let query = FirestoreConstants.MessagesCollection
    //            .document(uid)
    //            .collection("recent-messages")
    //            .order(by: "timestamp", descending: true)
    //
    //        do {
    //            let snapshot = try await query.getDocuments()
    //
    //            let messages = try snapshot.documents.compactMap { document in
    //                try document.data(as: Message.self)
    //            }
    //
    //            let messagesWithUsers = try await fetchUsersForMessages(messages, currentUserUid: uid)
    //            return messagesWithUsers
    //        } catch {
    //            print("Error fetching recent messages: \(error.localizedDescription)")
    //            throw error
    //        }
    //    }
    //
    //    private func fetchUsersForMessages(_ messages: [Message], currentUserUid: String) async throws -> [Message] {
    //        return try await withThrowingTaskGroup(of: (Message, User).self) { group in
    //            for message in messages {
    //                group.addTask {
    //                    let userUid = message.fromId == currentUserUid ? message.toId : message.fromId
    //                    let user = try await self.fetchUser(uid: userUid)
    //                    return (message, user)
    //                }
    //            }
    //
    //            var messagesWithUsers: [Message] = []
    //            for try await (message, user) in group {
    //                var mutableMessage = message
    //                mutableMessage.user = user
    //                messagesWithUsers.append(mutableMessage)
    //            }
    //
    //            return messagesWithUsers
    //        }
    //    }
    //
    //    private func fetchUser(uid: String) async throws -> User {
    //        let userDocument = try await FirestoreConstants.UserCollection.document(uid).getDocument()
    //        return try userDocument.data(as: User.self)
    //    }
}
