//
//  ConversationsScreen.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI

struct ConversationsScreen: View {
    @State var isShowingNewMessageView = false
    @State var showChatView = false
    @State private var path = NavigationPath()
    let currentUser: User?
    @State var selectedUser: User?
    //    @ObservedObject var viewModel = ConversationsViewModel()
    //    
    var body: some View {
        NavigationStack() {
            ZStack(alignment: .bottomTrailing) {
                
                // Chats
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(1...15, id: \.self) { _ in
                            // TODO: - Remove Divider from the last cell
                            NavigationLink {
                                ChatScreen(chatToUser: selectedUser)
                            } label: {
                                ConversationCell()
                                    .padding(.horizontal)
                            }
                            
                        }
                    }
                    .padding(.top)
                }
                
                // Floating button - new chat
                HStack {
                    Spacer()
                    FloatingButton(show: $isShowingNewMessageView)
                        .sheet(
                            isPresented: $isShowingNewMessageView,
                            content: {
                                NewMessageUsersScreen(
                                    showChatView: $showChatView,
                                    chatToUser: $selectedUser,
                                    currentUserId: currentUser?.id! ?? ""
                                )
                        })
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showChatView) {
                LazyView(
                    ChatScreen(chatToUser: selectedUser)
                )
            }
        }
    }
}


#Preview {
    ConversationsScreen(
        currentUser: UserManager(
            authService: AuthService(),
            userService: UserService()).currentUser
    )
}
