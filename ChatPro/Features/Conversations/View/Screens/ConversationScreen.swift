//
//  ConversationsScreen.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI

struct ConversationScreen: View {
    @ObservedObject var userManager: UserManager
    @ObservedObject var viewModel: ConversationScreenViewModel
    let messageService = MessageService()
    
    init(userManager: UserManager) {
        self.userManager = userManager
        self._viewModel = ObservedObject(
            wrappedValue: ConversationScreenViewModel(
                currentUser: userManager.currentUser,
                messageService: messageService
            )
        )
    }
    
    var body: some View {
        NavigationStack() {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.recentMessages.isEmpty {
                    CustomContentUnavailableView(
                        title: "No Chats",
                        description: "Start A New Chat"
                    )
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.recentMessages) { message in
                                ConversationCell(
                                    viewModel: ConversationCellViewModel(message: message),
                                    currentUser: userManager.currentUser,
                                    messageService: messageService
                                )
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.top)
            .sheet(
                isPresented: $viewModel.isShowingNewMessageView,
                content: {
                    SelectChatPartnerScreen(
                        showChatView: $viewModel.showChatView,
                        chatToUser: $viewModel.selectedUser,
                        userManager: userManager
                    )
                }
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(T.Titles.chats)
                        .headingStyle()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    GeometryReader { geometry in
                        NewChatIcon {
                            viewModel.isShowingNewMessageView.toggle()
                        }
                        .position(x: geometry.size.width - 16, y: geometry.size.height / 2)
                    }
                    .frame(
                        width: K.Space.base * 11,
                        height: K.Space.base * 11
                    )
                }
            }
            .tint(Color(.customPrimary))
            .navigationDestination(isPresented: $viewModel.showChatView) {
                LazyView(
                    ChatScreen(
                        chatPartner: viewModel.selectedUser,
                        currentUser: userManager.currentUser,
                        messageService: messageService
                    )
                )
            }
        }
    }
}


#Preview {
    ConversationScreen(userManager: UserManager(authService: AuthService(),
                                                userService: UserService()))
}

