//
//  ConversationCell.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI
import Kingfisher

struct ConversationCell: View {
    let viewModel: ConversationCellViewModel
    let currentUser: User?
    let messageService: MessageService
    
    var body: some View {
        if let chatPartner = viewModel.message.user {
            NavigationLink {
                ChatScreen(
                    chatPartner: chatPartner,
                    currentUser: currentUser,
                    messageService: messageService
                )
            } label: {
                ConversaionCellView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ConversationCell(
        viewModel: ConversationCellViewModel(message: MOCK_MESSAGE),
        currentUser: MOCK_USER,
        messageService: MessageService()
    )
}

struct ConversaionCellView: View {
    let viewModel: ConversationCellViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                KFImage(viewModel.chatPartnerImageUrl)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.chatPartnerFullname)
                        .bodyText(weight: .semibold)
                        .foregroundStyle(.custom1)
                    
                    Text(viewModel.message.text)
                        .bodyText(size: 15)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.75)
                        .foregroundColor(.customTerciary)
                }
                
                
                Spacer()
            }
            
            Divider()
        }
    }
}
