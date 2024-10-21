//
//  ChannelService.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 16.10.24.
//

import SwiftUI
import FirebaseFirestore

protocol ChannelServiceProtocol {
    var currentUser: User? { get set }
    var channel: Channel? { get set }
    func createChannel(channel: Channel) async throws -> Void
    //func fetchChannels() async throws -> [Channel]?
    func saveChannelMessage(message: ChannelMessage) async throws -> String
    func updateLastMessage(text: String) async throws -> Void
}

final class ChannelService: ChannelServiceProtocol {
    var currentUser: User?
    var channel: Channel?
    
    init(currentUser: User? = nil, channel: Channel? = nil) {
        self.currentUser = currentUser
        self.channel = channel
    }
    
    private var collectionRef: CollectionReference {
        FirestoreConstants.ChannelsCollection
    }
    
    func createChannel(channel: Channel) async throws -> Void {
        let channelRef = collectionRef.document()
        
        do {
            try await channelRef.setData(channel.encodedChannel)
            self.channel = channel
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func deleteChannel(channel: Channel) async throws -> Void {
        guard let channelId = channel.id else {
            throw NSError(domain: "No Channel ID Found", code: -1)
        }
        
        let channelRef = collectionRef.document(channelId)
        
        do {
            try await channelRef.delete()
        } catch {
            print("Error deleting channel: \(error.localizedDescription)")
            throw error
        }
    }
    
//    func fetchChannels() async throws -> [Channel]? {
//        guard let currentUserId = currentUser?.id else { return nil }
//        do {
//            let snapshot = try await collectionRef
//                .whereField("uids", arrayContains: currentUserId)
//                .getDocuments()
//            
//            return snapshot.documents
//                .compactMap { try? $0.data(as: Channel.self) }
//            
//        } catch {
//            print(error.localizedDescription)
//            throw error
//        }
//    }
    
    func fetchChannels(
        completion: @escaping (Result<[Channel], Error>) -> Void
    ) {
        guard let currentUserId = currentUser?.id else { return }
        print("DEBUG - User id: \(currentUserId)")
        let query =  collectionRef
            .whereField("uids", arrayContains: currentUserId)
//            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print(
                    "Error fetching channels for group chat: \(error?.localizedDescription ?? "Unknown error")"
                )
                completion(.failure(error ?? NSError()))
                return
            }

            let channels = documents.compactMap { document -> Channel? in
                try? document.data(as: Channel.self)
            }
            print("DEBUG - Channels: \(channels)")
            completion(.success(channels))
        }
    }
    
    func saveChannelMessage(message: ChannelMessage) async throws -> String {
        guard let channelId = channel?.id else {
            throw NSError(domain: "No Channel Selected", code: -1)
        }
        
        do {
            let channelRef = collectionRef
                .document(channelId)
                .collection("messages")
                .document()
            let newMessageId: String = channelRef.documentID
            
            try await channelRef.setData(message.encodedMessage)
            
            return newMessageId
        } catch {
            print("DEBUG: Message service failed to save message to db: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateLastMessage(text: String) async throws -> Void {
        guard let channelId = channel?.id else {
            throw NSError(domain: "No Channel Selected", code: -1)
        }
        
        let channelRef = collectionRef.document(channelId)
        
        do {
            try await channelRef.updateData(["lastMessage": text])
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func fetchChannelMessages(
            completion: @escaping (Result<[ChannelMessage], Error>) -> Void
    ) -> Void {
        guard let channelId = channel?.id else {
            completion(.failure(NSError(domain: "No Channel Selected", code: -1)))
            return
        }
        
        let query = collectionRef
            .document(channelId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else {
                completion(.failure(NSError(domain: "Error in getting changes", code: -1, userInfo: nil)))
                return
            }
            
            let messages = changes.compactMap({ try? $0.document.data(as: ChannelMessage.self) })
            completion(.success(messages))
        }
    }
}
