//
//  ChannelChatView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 17.10.24.
//

import SwiftUI

struct ChannelChatScreen: View {
    @ObservedObject var viewModel: ChannelChatScreenModel
    @Environment(\.presentationMode) var presentationMode
    let channelService: ChannelService
    init(
        channelService: ChannelService
    ) {
        self.channelService = channelService
        self.viewModel = ChannelChatScreenModel(
            channelService: channelService
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
                                    currentUser: channelService.currentUser
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
                
                CustomInputView(inputText: $viewModel.newMessageText,
                                selectedImage: $viewModel.selectedImage,
                                action: sendMessage)
                .padding()
            }
            .navigationTitle(channelService.channel?.name ?? "Neew Channel")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: T.IconNames.back)
                                .foregroundStyle(.customPrimary)
                        }
                    }
                }
            }
        }
    }
    
    func sendMessage() async {
        await viewModel.sendChannelMessage()
        viewModel.newMessageText = ""
    }
}

#Preview {
    ChannelChatScreen(
        channelService: ChannelService()
    )
}
