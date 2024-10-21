//
//  UserCell.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI
import Kingfisher

struct UserCell: View {
    let user: User
    
    var body: some View {
        HStack {
            KFImage(URL(string: user.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: K.Space.base * 12,
                       height: K.Space.base * 12)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .bodyText(weight: .semibold)
                
                Text(user.fullname)
                    .bodyText()
            }
            .foregroundColor(.primary)
            
            Spacer()
        }
    }
}
