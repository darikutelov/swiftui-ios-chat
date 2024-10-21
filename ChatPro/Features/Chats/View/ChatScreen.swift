//
//  ChatsView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct ChatScreen: View {
    private let chatPartner: User?
    private let currentUser: User?
    private let messageService: MessageService
    @ObservedObject var viewModel: ChatScreenViewModel
    @Environment(\.presentationMode) var presentationMode
    
    //TODO: - Move to viewModel
    @State private var selectedImage: UIImage?

    init(chatPartner: User?, currentUser: User?, messageService: MessageService) {
        self.chatPartner = chatPartner
        self.currentUser = currentUser
        self.messageService = messageService
        
        self._viewModel = ObservedObject(
            wrappedValue: ChatScreenViewModel(
                chatPartner: chatPartner,
                currentUser: currentUser,
                messageService: messageService
            )
        )
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollViewReader { value in
                    ScrollView {
                        VStack(alignment: .leading,
                               spacing: K.Space.base * 3) {
                            ForEach(viewModel.messages) { message in
                                MessageView(
                                    message: message,
                                    currentUser: currentUser
                                )
                                .id(message.id)
                            }
                        }.padding(.top)
                    }
                    .onReceive(
                        viewModel.$messageToSetVisible,
                        perform: { id in value.scrollTo(id) }
                    )
                }
                
                CustomInputView(inputText: $viewModel.messageText,
                                selectedImage: $selectedImage,
                                action: sendMessage)
                .padding()
            }
            .navigationTitle(chatPartner?.username ?? "Chat Messages")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
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
        await viewModel.sendMessage()
        viewModel.messageText = ""
    }
}

#Preview {
    NavigationView {
        ChatScreen(
            chatPartner: MOCK_USER,
            currentUser: MOCK_USER,
            messageService: MessageService()
        )
    }
}
