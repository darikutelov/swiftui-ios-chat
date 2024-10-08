//
//  NewMessageView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI

struct NewMessageView: View {
    @State var searchText = ""
    @State var isEditing = false
    @Binding var showChatView: Bool
    @Environment(\.presentationMode) var mode
    //    @Binding var user: User?
    //    @ObservedObject var viewModel = NewMessageViewModel(config: .chat)
    
    var body: some View {
        ScrollView {
            SearchBar(text: $searchText, isEditing: $isEditing)
                .onTapGesture { isEditing.toggle() }
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                ForEach(1...10, id: \.self) { _ in
                    Button {
                        showChatView.toggle()
                        mode.wrappedValue.dismiss()
                    } label: {
                        UserCell()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    NewMessageView(
        showChatView: .constant(true)
    )
}
