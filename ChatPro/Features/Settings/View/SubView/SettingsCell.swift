//
//  SettingsCell.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct MenuOption: Hashable, Codable, Identifiable {
    let iconName: String
    let iconColor: String
    let label: String
    var id: String {
        return label
    }
}

struct SettingsCell: View {
    let viewModel: SettingsCellViewModel
    let isLast: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: viewModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .padding(6)
                    .background(viewModel.backgroundColor)
                    .foregroundStyle(.white)
                    .cornerRadius(6)
                
                Text(viewModel.title)
                    .bodyText(size: 16)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            .padding()
            
            if !isLast {
                Spacer()
                    .frame(height: 0.3)
                    .frame(maxWidth: .infinity)
                    .overlay {
                        Rectangle()
                            .fill(Color(.secondaryLabel))
                    }
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    SettingsCell(viewModel: SettingsCellViewModel.starredMessage, isLast: false)
}
