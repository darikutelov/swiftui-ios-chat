//
//  ChannelCell.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 12.10.24.
//

import SwiftUI
import Kingfisher

struct ChannelCell: View {
    let channel: Channel
    let channelService: ChannelService
    
    let _imageSize = K.Space.base * 14
    let _corenerRadius = K.Space.base * 7
    
    init(channel: Channel, channelService: ChannelService) {
        self.channel = channel
        self.channelService = channelService
        self.channelService.channel = channel
    }
    
    var body: some View {
        NavigationLink {
            ChannelChatScreen(
                channelService: channelService
            )
        } label: {
            VStack(alignment: .leading) {
                HStack(alignment: .center, spacing: K.Space.base * 3) {
                    if let imageUrl = channel.imageUrl {
                        KFImage(URL(string: imageUrl))
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: _imageSize, height: _imageSize)
                            .cornerRadius(_corenerRadius)
                    } else {
                        Image(systemName: T.IconNames.person)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: _imageSize, height: _imageSize)
                            .cornerRadius(_corenerRadius)
                            .foregroundStyle(.customSecondary)
                    }
                    
                    VStack(alignment: .leading, spacing: K.Space.base) {
                        Text(channel.name)
                            .bodyText(weight: .semibold)
                            .foregroundStyle(.custom1)
                        Text(channel.lastMessage)
                            .bodyText(size: 15)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.75)
                            .foregroundColor(.customTerciary)
                    }
                    
                    Spacer()
                    
                    Button {
                        // TODO: - Menu with delete chat, leave chat, add people to chat
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.customPrimary)
                    }
                }
                
                Divider()
                    .foregroundStyle(.customPrimary)
            }
        }
    }
}

#Preview {
    ChannelCell(
        channel: MOCK_CHANNEL,
        channelService: ChannelService(channel: MOCK_CHANNEL)
    )
}
