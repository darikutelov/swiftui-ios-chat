//
//  ChannelsView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct ChannelScreen: View {
    @ObservedObject var userManager: UserManager
    @ObservedObject var viewModel: ChannelScreenViewModel
    
    @State var users = [SelectableUser]()
    let channelService: ChannelService
    
    init(userManager: UserManager) {
        let channelService = ChannelService(
            currentUser: userManager.currentUser
        )
        self.userManager = userManager
        self.viewModel = ChannelScreenViewModel(
            channelService: channelService,
            currentUser: userManager.currentUser
        )
        self.channelService = channelService
    }
    
    var body: some View {
        NavigationStack() {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.channels.isEmpty {
                    CustomContentUnavailableView(
                        title: "No Group Chats",
                        description: "Start A New Group Chat"
                    )
                } else {
                    // TODO: - go to last channel
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.channels) { channel in
                                ChannelCell(
                                    channel: channel,
                                    channelService: channelService
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .scrollIndicators(.hidden, axes: .vertical)
                }
            }
            .sheet(
                isPresented: $viewModel.isShowingNewMessageView,
                content: {
                    SelectGroupMemberScreen(
                        users: $users,
                        show: $viewModel.isShowingNewMessageView,
                        userManager: userManager,
                        channelService: channelService
                    )
                })
            .navigationDestination(isPresented: $viewModel.showChatView) {
                LazyView(
                    ChannelChatScreen(
                        channelService: channelService
                    )
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(T.Titles.channels)
                        .headingStyle()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    GeometryReader { geometry in
                        NewChatIcon {
                            viewModel.isShowingNewMessageView.toggle()
                        }
                        .position(
                            x: geometry.size.width - K.Space.base*4,
                            y: geometry.size.height / 2
                        )
                    }
                    .frame(
                        width: K.Space.base*11,
                        height: K.Space.base*11
                    )
                }
            }
        }
    }
}

#Preview {
    ChannelScreen(
        userManager: UserManager(authService: AuthService(),
                                 userService: UserService())
    )
}
