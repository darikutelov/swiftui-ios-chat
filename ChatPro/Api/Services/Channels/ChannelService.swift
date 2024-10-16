//
//  ChannelService.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 16.10.24.
//

import SwiftUI

protocol ChannelServiceProtocol {
    func createChannel(channel: Channel) async throws -> Void
}

final class ChannelService {
    func createChannel(channel: Channel) async throws -> Void {
        let channelRef = FirestoreConstants
            .ChannelsCollection
            .document()
        
        do {
            try await channelRef.setData(channel.encodedChannel)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
