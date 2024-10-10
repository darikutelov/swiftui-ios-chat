//
//  MessageView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 5.10.24.
//

import SwiftUI

struct MessageView: View {
    let isNewMessage: Bool
    let currentUser: User
    
    @ObservedObject var viewModel: MessageViewViewModel
    
    init(message: Message, isNewMessage: Bool, currentUser: User) {
        self.isNewMessage = isNewMessage
        self.currentUser = currentUser
        self._viewModel = ObservedObject(wrappedValue: MessageViewViewModel(message: message, currentUser: currentUser))
    }
    
    var body: some View {
        HStack {
            if viewModel.isFromCurrentUser {
                Spacer()
                
                MessageText(
                    text: viewModel.message.text,
                    isCurrentUser: viewModel.isFromCurrentUser
                )
                .padding(.leading, 40)
                
            } else {
                HStack(alignment: .bottom) {
                    Image(.wasp)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                        .scaleEffect(viewModel.isShowing ? 1 : 0)
                        .opacity(viewModel.isShowing ? 1 : 0)
                    
                    MessageText(
                        text: viewModel.message.text,
                        isCurrentUser: viewModel.isFromCurrentUser
                    )
                    .padding(.trailing, 40)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
        .modifier(
            SlideInEffect(
                isShowing: isNewMessage ? viewModel.isShowing : true,
                isFromCurrentUser: viewModel.isFromCurrentUser
            )
        )
        .onAppear {
            if isNewMessage {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    viewModel.isShowing = true
                }
            } else {
                viewModel.isShowing = true
            }
        }
    }
}

#Preview {
    MessageView(
        message: MOCK_MESSAGE,
        isNewMessage: true,
        currentUser: MOCK_USER
    )
}

struct MessageText: View {
    var text: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(text)
            .padding(12)
            .background(
                isCurrentUser ? Color(.customPrimaryBackground) : Color(.secondarySystemBackground)
            )
            .bodyText(size: 16)
            .foregroundStyle(isCurrentUser ? .white : .primary)
            .clipShape(
                ChatBubble(isFromCurrentUser: isCurrentUser)
            )
    }
}

struct SlideInEffect: ViewModifier {
    let isShowing: Bool
    let isFromCurrentUser: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(x: isShowing ? 0 : (isFromCurrentUser ? 100 : -100))
            .opacity(isShowing ? 1 : 0)
            .scaleEffect(isShowing ? 1 : 0.8, anchor: isFromCurrentUser ? .trailing : .leading)
    }
}
