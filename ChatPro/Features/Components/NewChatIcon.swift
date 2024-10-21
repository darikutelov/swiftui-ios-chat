//
//  NewChatIcon.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 12.10.24.
//

import SwiftUI

struct NewChatIcon: View {
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: T.IconNames.pencil)
                .resizable()
                .scaledToFit()
                .frame(width: K.Space.base * 4, height: K.Space.base * 4)
                .padding(K.Space.base)
                .offset(x: -K.Space.base/2, y: -K.Space.base/4)
        }
        .background(Color(.customSecondary))
        .foregroundColor(.white)
        .clipShape(Circle())
        .padding()
    }
}

#Preview {
    NewChatIcon() {
        //
    }
}
