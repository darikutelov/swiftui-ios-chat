//
//  CreateGroupScreen.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.10.24.
//

import SwiftUI

struct SelectGroupMemberScreen: View {
    @Environment(\.presentationMode) var mode
    @Binding var show: Bool
    let channelService: ChannelService
    let currentUser: User?
    
    @ObservedObject var viewModel: SelectGroupMemberScreenViewModel
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var showCreateChannelScreen = false
    
    init(users: Binding<[SelectableUser]>,
         show: Binding<Bool>,
         userManager: UserManager,
         channelService: ChannelService
    ) {
        self._show = show
        self.channelService = channelService
        self.currentUser = userManager.currentUser
        self._viewModel = ObservedObject(
            wrappedValue: SelectGroupMemberScreenViewModel(
                userManager: userManager
            )
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: K.Space.base * 8) {
                SearchBar(text: $searchText,
                          isEditing: $isEditing)
                .onTapGesture {
                    isEditing.toggle()
                }
                
                if !viewModel.selectedUsers.isEmpty {
                    SelectedGroupMembersListView(viewModel: viewModel)
                }
                
                ScrollView {
                    LazyVStack {
                        ForEach(searchText.isEmpty ? 
                                viewModel.selectableUsers :
                                viewModel.filteredUsers(searchText)
                        ) { user in
                            Button {
                                viewModel.selectUser(
                                    user,
                                    isSelected: !user.isSelected
                                )
                            } label: {
                                SelectableUserCell(
                                    viewModel: SelectableCellViewModel(
                                        selectableUser: user)
                                )
                            }
                        }
                    }
                }
                
            }
            .sheet(isPresented: $showCreateChannelScreen) {
                CreateChannelScreen(
                    users: viewModel.selectedUsers.map { $0.user },
                    show: $show,
                    currentUser: currentUser,
                    channelService: channelService
                )
                .presentationDetents([.medium, .medium])
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    nextButton
                }
            }
            .navigationTitle(T.Titles.newRoom)
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    var nextButton: some View {
        Button {
            showCreateChannelScreen.toggle()
        } label: {
            Text(T.ButtonText.next)
                .bold()
        }
        .disabled(viewModel.selectedUsers.isEmpty)
        .foregroundStyle(viewModel.selectedUsers.isEmpty ?
                         Color(.secondaryLabel)
                         : Color(.customPrimaryBackground)
        )
    }
    
    var cancelButton: some View {
        Button {
            mode.wrappedValue.dismiss()
        } label: {
            Text(T.ButtonText.cancel)
                .bold()
        }
    }
}

#Preview {
    SelectGroupMemberScreen(
        users: .constant([SelectableUser(user: MOCK_USER, isSelected: true)]),
        show: .constant(false),
        userManager: UserManager(
            authService: AuthService(),
            userService: UserService()
        ),
        channelService: ChannelService()
    )
}
