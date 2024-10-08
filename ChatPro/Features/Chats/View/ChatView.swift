//
//  ChatsView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct ChatView: View {
    //let user: User
    @ObservedObject var vm = ChatViewModel()
    @State private var messageText: String = ""
    @State private var selectedImage: UIImage?
    
    //    init(user: User) {
    //        self.user = user
    //        self.viewModel = ChatViewModel(user: user)
    //    }
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                // Messages
                ScrollViewReader { value in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(vm.messages) { message in
                                MessageView(
                                    message: message,
                                    isNewMessage: message.id == vm.newMessageId
                                )
                                .id(message.id)
                            }
                        }.padding(.top)
                    }
                    .onChange(of: vm.newMessageId) { _, id in
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
            .navigationTitle("Barbara")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func sendMessage() {
        vm.sendMessage(messageText)
        messageText = ""
    }
}

#Preview {
    NavigationView {
        ChatView(vm: ChatViewModel())
    }
}
