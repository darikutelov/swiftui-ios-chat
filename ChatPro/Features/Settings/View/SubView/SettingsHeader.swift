//
//  SettingsHeader.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct SettingsHeader: View {
    let userStatus: UserStatus
    
    var body: some View {
        HStack {
            Image("wasp")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .padding(.leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Test User 2")
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
    SettingsHeader(userStatus: .available)
}
