//
//  CustomContentUnavailableView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.10.24.
//

import SwiftUI


struct CustomContentUnavailableView: View {
    let title: String
    let description: String
    var body: some View {
        ContentUnavailableView {
            Label {
                Text(title)
                    .bodyText(size: K.Space.base * 6, weight: .bold)
                    .foregroundStyle(.customPrimary)
            } icon: {
                Image(systemName: T.IconNames.trayFill)
            }
        } description: {
            Text(description)
                .bodyText(size: K.Space.base * 4, weight: .semibold)
                .foregroundStyle(.customTerciary)
        }
    }
}

#Preview {
    CustomContentUnavailableView(
        title: "No Chats",
        description: "Start A New Chat"
    )
}
