//
//  MessageView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 5.10.24.
//

import SwiftUI

struct MessageView: View {
    let message: Message
    // For animation
    @State private var isShowing = false
    let isNewMessage: Bool
    let isFromCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isFromCurrentUser {
                Spacer()
                
                MessageText(
                    text: message.text,
                    isCurrentUser: isFromCurrentUser
                )
                .padding(.leading, 40)
                
            } else {
                HStack(alignment: .bottom) {
                    Image(.wasp)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                        .scaleEffect(isShowing ? 1 : 0)
                        .opacity(isShowing ? 1 : 0)
                    
                    MessageText(
                        text: message.text,
                        isCurrentUser: isFromCurrentUser
                    )
                    .padding(.trailing, 40)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
        .modifier(
            SlideInEffect(
                isShowing: isNewMessage ? isShowing : true,
                isFromCurrentUser: isFromCurrentUser
            )
        )
        .onAppear {
            if isNewMessage {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isShowing = true
                }
            } else {
                isShowing = true
            }
        }
    }
}

#Preview {
    MessageView(
        message: MOCK_MESSAGE,
        isNewMessage: true,
        isFromCurrentUser: true
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
