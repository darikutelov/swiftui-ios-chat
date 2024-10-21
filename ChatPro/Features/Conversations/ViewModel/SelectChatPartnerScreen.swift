//
//  NewMessageView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI

struct SelectChatPartnerScreen: View {
    @Environment(\.presentationMode) var mode
    @Binding var showChatView: Bool
    @Binding var chatToUser: User?
    
    @ObservedObject var viewModel: SelectChatPartnerScreenViewModel
    @State var searchText = ""
    @State var isEditing = false
    
    init(showChatView: Binding<Bool>,
         chatToUser: Binding<User?>,
         userManager: UserManager
    ) {
        self._showChatView = showChatView
        self._chatToUser = chatToUser
        self._viewModel = ObservedObject(
            wrappedValue: SelectChatPartnerScreenViewModel(userManager: 
                                                        userManager)
        )
    }
    
    var body: some View {
        ScrollView {
            SearchBar(text: $searchText, isEditing: $isEditing)
                .onTapGesture { isEditing.toggle() }
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                ForEach(viewModel.users) { user in
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
    SelectChatPartnerScreen(
        showChatView: .constant(true),
        chatToUser: .constant(MOCK_USER),
        userManager: UserManager(authService: AuthService(), userService: UserService())
    )
}
