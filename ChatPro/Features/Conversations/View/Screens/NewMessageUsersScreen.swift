//
//  NewMessageView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI

struct NewMessageUsersScreen: View {
    @Environment(\.presentationMode) var mode
    @Binding var showChatView: Bool
    @Binding var chatToUser: User?
    let currentUserId: String
    
    @ObservedObject var viewModel = NewMessageScreenViewModel(
                                        userService: UserService())
    @State var searchText = ""
    @State var isEditing = false
    
    var body: some View {
        ScrollView {
            SearchBar(text: $searchText, isEditing: $isEditing)
                .onTapGesture { isEditing.toggle() }
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                ForEach(viewModel.users.filter {$0.id != currentUserId }) { user in
                    Button {
                        showChatView.toggle()
                        self.chatToUser = user
                        mode.wrappedValue.dismiss()
                    } label: {
                        UserCell(user: user)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    NewMessageUsersScreen(
        showChatView: .constant(true),
        chatToUser: .constant(MOCK_USER),
        currentUserId: "123",
        viewModel: NewMessageScreenViewModel(userService: UserService())
    )
}
