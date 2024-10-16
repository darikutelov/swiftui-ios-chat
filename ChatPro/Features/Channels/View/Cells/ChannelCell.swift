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
    
    let _imageSize = K.Space.base * 14
    let _corenerRadius = K.Space.base * 7
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: K.Space.base * 3) {
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
                }
                
                VStack(alignment: .leading, spacing: K.Space.base) {
                    Text(channel.name)
                        .bodyText(weight: .semibold)
                    Text(channel.lastMessage)
                        .bodyText(size: 15)
                        .lineLimit(2)
                }
                .padding(.trailing)
                
                Spacer()
            }
            Divider()
                .background(Color(.customPrimary))
        }
    }
}

#Preview {
    ChannelCell(channel: MOCK_CHANNEL)
}
