//
//  ConversationCell.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI

struct ConversationCell: View {
    //let viewModel: MessageViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                Image("colin")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Test User")
                        .bodyText(weight: .semibold)
                    
                    Text("This is a test message. ")
                        .bodyText(size: 15)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                }
                .foregroundColor(.primary)
            }
            
            Divider()
        }
    }
}

#Preview {
    ConversationCell()
}
