//
//  ChatsView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct ChatScreen: View {
    private let chatToUser: User?
    @ObservedObject var viewModel = ChatViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var messageText: String = ""
    @State private var selectedImage: UIImage?
    
    init(chatToUser: User?) {
        self.chatToUser = chatToUser
        //self.viewModel = ChatViewModel(user: user)
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                // Messages
                ScrollViewReader { value in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageView(
                                    message: message,
                                    isNewMessage: message.id == viewModel.newMessageId,
                                    isFromCurrentUser: true
                                )
                                .id(message.id)
                            }
                        }.padding(.top)
                    }
                    .onChange(of: viewModel.newMessageId) { _, id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
                
                // Input View
                CustomInputView(inputText: $messageText,
                                selectedImage: $selectedImage,
                                action: sendMessage)
                .padding()
            }
            //.navigationTitle(user.username)
            .navigationTitle(chatToUser?.username ?? "Chat View")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Custom back button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.customPrimary)
                        }
                    }
                }
            }
        }
    }
    
    func sendMessage() {
        viewModel.sendMessage(messageText)
        messageText = ""
    }
}

#Preview {
    NavigationView {
        ChatScreen(chatToUser: MOCK_USER)
    }
}
