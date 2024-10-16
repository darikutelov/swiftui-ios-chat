//
//  SelectableUserCell.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.10.24.
//

import SwiftUI
import Kingfisher

struct SelectableUserCell: View {
    let viewModel: SelectableCellViewModel
    
    var body: some View {
        HStack {
            KFImage(viewModel.profileImageUrl)
                .resizable()
                .scaledToFill()
                .frame(width: K.Space.base * 12,
                       height: K.Space.base * 12)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(viewModel.username)
                    .bodyText(weight: .semibold)
                
                Text(viewModel.fullname)
                    .bodyText()
            }
            .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: viewModel.selectedImageName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(viewModel.selectedImageColor)
                .frame(width: K.Space.base * 5,
                       height: K.Space.base * 5)
                .padding(.trailing)
        }
    }
}

#Preview {
    SelectableUserCell(
        viewModel: SelectableCellViewModel(
            selectableUser: SelectableUser(user: MOCK_USER,
                                           isSelected: true)
        )
    )
}
