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
    @ObservedObject var channelsService: ChannelsService
    
    @State var users = [SelectableUser]()
    let channelService: ChannelService
    
    init(userManager: UserManager) {
        self.userManager = userManager
        let channelService = ChannelService(
            currentUser: userManager.currentUser
        )
        self._channelsService = ObservedObject(wrappedValue: ChannelsService(
            currentUser: userManager.currentUser
        ))
        
        self.viewModel = ChannelScreenViewModel(
            channelService: channelService,
            currentUser: userManager.currentUser
        )
        self.channelService = channelService
    }
    
    var body: some View {
        NavigationStack() {
            VStack {
                if channelsService.isLoading {
                    ProgressView()
                } else if channelsService.channels.isEmpty {
                    CustomContentUnavailableView(
                        title: "No Group Chats",
                        description: "Start A New Group Chat"
                    )
                } else {
                    ZStack {
                        ScrollViewReader { value in
                            ScrollView {
                                LazyVStack(alignment: .leading) {
                                    ForEach(channelsService.channels) { channel in
                                        ChannelCell(
                                            channel: channel,
                                            channelService: channelService
                                        )
                                        .id(channel.id)
                                        .onAppear {
                                            //let _ = print("item \(String(describing: channel.id)) appeared")
                                            if channel.id == channelsService.channels[safe: 2]?.id {
                                                channelsService.fetchChannels(
                                                    isInitialFetch: false
                                                )
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top)
                            }
                            .defaultScrollAnchor(.bottom)
                            .scrollIndicators(.hidden, axes: .vertical)
                            .onReceive(
                                viewModel.$channelToSetVisible,
                                perform: { id in value.scrollTo(id) }
                            )
                        }
                    }
                }
            }
            .sheet(
                isPresented: $viewModel.isShowingNewMessageView,
                content: {
                    SelectGroupMemberScreen(
                        users: $users,
                        show: $viewModel.isShowingNewMessageView,
                        channelToSetVisible: $viewModel.channelToSetVisible,
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
        .onReceive(channelsService.$channels) { _ in
            self.viewModel.channelToSetVisible = channelsService.channels.last?.id
        }
        .refreshable {
            channelsService.fetchChannels(isInitialFetch: true)
        }
        .onAppear {
            channelsService.fetchChannels(isInitialFetch: true)
        }
        .onDisappear {
            channelsService.cleanup()
        }
    }
}

#Preview {
    ChannelScreen(
        userManager: UserManager(authService: AuthService(),
                                 userService: UserService())
    )
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
