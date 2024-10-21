//
//  MessageView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 5.10.24.
//

import SwiftUI
import Kingfisher

struct MessageView: View {
    private let viewModel: MessageViewViewModel
    
    init(message: Message, currentUser: User?) {
        self.viewModel = MessageViewViewModel(
            message: message,
            currentUser: currentUser
        )
    }
    
    var body: some View {
        HStack {
            if viewModel.isFromCurrentUser {
                Spacer()
                
                MessageText(
                    text: viewModel.message.text,
                    isCurrentUser: viewModel.isFromCurrentUser
                )
                .padding(.leading, K.Space.base * 10)
                
            } else {
                HStack(alignment: .bottom) {
                    KFImage(viewModel.profileImageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: K.Space.base * 9,
                               height: K.Space.base * 9)
                        .clipShape(Circle())
                        .padding(.bottom, 2)
                    
                    MessageText(
                        text: viewModel.message.text,
                        isCurrentUser: viewModel.isFromCurrentUser
                    )
                    .padding(.trailing, K.Space.base * 10)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
}

#Preview {
    MessageView(
        message: MOCK_MESSAGE,
        currentUser: MOCK_USER
    )
}

struct MessageText: View {
    var text: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(text)
            .padding(K.Space.base * 3)
            .background(
                isCurrentUser ? 
                RadialGradient(
                    gradient: Gradient(colors: [Color(.secondarySystemBackground), Color(.secondarySystemBackground)]),
                    center: .center,
                    startRadius: 20,
                    endRadius: 200
                ) :
                RadialGradient(
                    gradient: Gradient(colors: [.customPrimary, .radient2]),
                    center: .center,
                    startRadius: 70,
                    endRadius: 200
                )
            )
            .bodyText(size: K.Space.base * 4)
            .foregroundStyle(isCurrentUser ? .primary : Color(.white) )
            .clipShape(
                ChatBubble(isFromCurrentUser: isCurrentUser)
            )
    }
}

