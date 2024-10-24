//
//  File.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 16.10.24.
//

import SwiftUI
import Firebase

@MainActor
final class CreateChannelViewModel: ObservableObject {
    let users: [User]
    private let currentUser: User?
    private let channelService: ChannelService
        
    @Published var didCreateChannel = 0
    @Published var isSaving = false
    
    init(users: [User], currentUser: User?, channelService: ChannelService) {
        self.users = users
        self.currentUser = currentUser
        self.channelService = channelService
    }
    
    func createChannel(name: String, image: UIImage?) async -> String? {
        guard let currentUserId = currentUser?.id,
              let currentUserFullname = currentUser?.fullname else { return nil }
        
        var uids = users.map({ $0.id ?? NSUUID().uuidString })
        uids.append(currentUserId)
        
        var channel = Channel(
            name: name,
            uids: uids,
            lastMessage: "\(currentUserFullname) created a channel",
            updatedAt: Timestamp(date: Date())
        )
        
        isSaving = true
        
        if let image = image {
            do {
                let imageUrl = try await ImageUploader.uploadImage(image: image, type: .channel)
                channel.imageUrl = imageUrl
            } catch {
                isSaving = false
                print(error.localizedDescription)
            }
            return await saveNewChannel(channel: channel)
        } else {
            return await saveNewChannel(channel: channel)
        }
    }
    
    private func saveNewChannel(channel: Channel) async -> String? {
        do {
            let channelId = try await channelService.createChannel(channel: channel)
            isSaving = false
            self.didCreateChannel = 1
            return channelId
        } catch {
            isSaving = false
            self.didCreateChannel = 2
            print(error.localizedDescription)
            return nil
        }
    }
}
