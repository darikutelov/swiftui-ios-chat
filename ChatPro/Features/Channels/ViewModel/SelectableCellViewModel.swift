//
//  SelectableCellViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 16.10.24.
//

import SwiftUI

struct SelectableCellViewModel {
    let selectableUser: SelectableUser
    
    var profileImageUrl: URL? {
        URL(string: selectableUser.user.profileImageUrl ?? "")
    }
    
    var username: String {
        selectableUser.user.username
    }
    
    var fullname: String {
        selectableUser.user.fullname
    }
    
    var selectedImageName: String {
        selectableUser.isSelected ?
            T.IconNames.checkmarkFill
            : T.IconNames.circle
    }
    
    var selectedImageColor: Color {
        selectableUser.isSelected ?
            Color(.customPrimaryBackground)
            : Color(.customPrimary)
    }
}
