//
//  SearchBar.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
                .onTapGesture {
                    isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    withAnimation {
                        isEditing = false
                        text = ""
                        // Hide keyboad on Cancel press
                        UIApplication.shared.endEditing()
                    }
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.primary)
                })
                .padding(.trailing, 8)
                .transition(
                    .move(edge: .trailing)
                )
            }
        }
    }
}

#Preview {
    SearchBar(text: .constant("Search..."), isEditing: .constant(true))
}
