//
//  ChannelScreenViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 12.10.24.
//

import Foundation

final class ChannelScreenViewModel: ObservableObject {
    let channelService: ChannelService
    let currentUser: User?
    
    @Published var channels: [Channel] = []// [MOCK_CHANNEL, MOCK_CHANNEL, MOCK_CHANNEL]
    @Published var isShowingNewMessageView = false
    @Published var showChatView = false
    @Published var isLoading = false
    @Published var channelToSetVisible: String?
    
    init(channelService: ChannelService, currentUser: User?) {
        self.channelService = channelService
        self.currentUser = currentUser
    }
}
