//
//  ConversationsView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI

struct ConversationsView: View {
    @State var isShowingNewMessageView = false
    @State var showChatView = false
    //    @State var user: User?
    //    @ObservedObject var viewModel = ConversationsViewModel()
    //    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottomTrailing) {
                
                // Chats
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(1...15, id: \.self) { _ in
                            // TODO: - Remove Divider from the last cell
                            NavigationLink {
                                ChatView()
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
                        .sheet(isPresented: $isShowingNewMessageView, content: {
                            NewMessageView(showChatView: $showChatView)
                        })
                }
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showChatView) {
                LazyView(ChatView())
            }
        }
    }
}

#Preview {
    ConversationsView()
}
