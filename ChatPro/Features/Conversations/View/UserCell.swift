//
//  UserCell.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI
//import Kingfisher

struct UserCell: View {
    //let user: User
    
    var body: some View {
        HStack {
            //KFImage(URL(string: user.profileImageUrl))
            Image("colin")
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                //Text(user.username)
                Text("Test")
                    .bodyText(weight: .semibold)
                
                //Text(user.fullname)
                Text("Test User 1")
                    .bodyText()
            }
            .foregroundColor(.primary)
            
            Spacer()
        }
    }
}
