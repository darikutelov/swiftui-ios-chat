//
//  ChatsView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct ChatScreen: View {
    private let chatPartner: User?
    private let currentUser: User
    @ObservedObject var viewModel: ChatScreenViewModel
    @Environment(\.presentationMode) var presentationMode
    
    //TODO: - Move to viewModel
    @State private var messageText: String = ""
    @State private var selectedImage: UIImage?

    init(chatPartner: User?, currentUser: User) {
        self.chatPartner = chatPartner
        self.currentUser = currentUser
        self._viewModel = ObservedObject(wrappedValue: ChatScreenViewModel(chatPartner: chatPartner,
                                                                     currentUser: currentUser))
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
                                    currentUser: currentUser
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
            .navigationTitle(chatPartner?.username ?? "Chat Messages")
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
    
    func sendMessage() async {
        await viewModel.sendMessage(messageText)
        messageText = ""
    }
}

#Preview {
    NavigationView {
        ChatScreen(
            chatPartner: MOCK_USER,
            currentUser: MOCK_USER
        )
    }
}
