//
//  SettingsHeader.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI
import Kingfisher

struct SettingsHeader: View {
    let userStatus: UserStatus
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        HStack {
            KFImage(URL(string: userManager.currentUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(userManager.currentUser?.fullname ?? "N/A")
                    .bodyText(size: 18)
                Text(userStatus.title)
                    .bodyText(size: 14)
                    .foregroundStyle(Color(.secondaryLabel))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 80,
               alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    SettingsHeader(
        userStatus: .available,
        userManager: UserManager(
            authService: AuthService(),
            userService: UserService()
        )
    )
}
