//
//  SelectedGroupMembersListView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.10.24.
//

import SwiftUI
import Kingfisher

struct SelectedGroupMembersListView: View {
    @ObservedObject var viewModel: SelectGroupMemberScreenViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.selectedUsers) { selectedUser in
                    ZStack(alignment: .topTrailing) {
                        VStack() {
                            KFImage(URL(string: selectedUser.user.profileImageUrl ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: K.Space.base * 15,
                                       height: K.Space.base * 15)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: K.Space.base * 5)
                                )
                                .shadow(
                                    color: .customPrimary,
                                    radius: K.Space.base,
                                    x: 0, y: 2
                            )
                            
                            Text(selectedUser.user.fullname)
                                .bodyText(size: K.Space.base * 3,
                                          weight: .semibold)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .frame(
                            width: K.Space.base * 16,
                            height: K.Space.base * 28
                        )
                        
                        Button {
                            viewModel.selectUser(selectedUser, isSelected: false)
                        } label: {
                            Image(systemName: T.IconNames.xmark)
                                .resizable()
                                .scaledToFit()
                                .frame(
                                    width: K.Space.base * 2,
                                    height: K.Space.base * 2
                                )
                                .padding(K.Space.base)
                        }
                        .background(Color(.customTerciary))
                        .foregroundStyle(Color(.white))
                        .clipShape(Circle())
                        .offset(x: -1, y: 1)
                    }
                }
            }
        }
        .animation(.spring())
    }
}

#Preview {
    SelectedGroupMembersListView(
        viewModel: SelectGroupMemberScreenViewModel(
            userManager: UserManager(
                authService: AuthService(),
                userService: UserService()
            )
        )
    )
}
