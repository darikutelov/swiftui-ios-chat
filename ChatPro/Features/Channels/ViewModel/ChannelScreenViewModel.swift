//
//  ChannelScreenViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 12.10.24.
//

import Foundation

final class ChannelScreenViewModel: ObservableObject {
    @Published var channels: [Channel] = [
        MOCK_CHANNEL,
        MOCK_CHANNEL,
        MOCK_CHANNEL,
        MOCK_CHANNEL,
        MOCK_CHANNEL,
    ]
    @Published var isShowingNewMessageView = false
}
