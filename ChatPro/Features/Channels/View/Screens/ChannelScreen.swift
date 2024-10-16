//
//  ChannelsView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct ChannelScreen: View {
    @ObservedObject var userManager: UserManager
    @ObservedObject var viewModel = ChannelScreenViewModel()
    
    @State var users = [SelectableUser]()
    let channelService = ChannelService()
    
    var body: some View {
        NavigationStack() {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.channels) { channel in
                        ChannelCell(channel: channel)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
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
            .tint(Color(.customPrimary))
        }
    }
}

#Preview {
    ChannelScreen(
        userManager: UserManager(authService: AuthService(), 
                                 userService: UserService())
    )
}
