//
//  SettingsCellViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

enum SettingsCellViewModel: Int, CaseIterable {
    case account
    case notification
    case starredMessage
    
    var title: String {
        switch self {
        case .account:
            return "Account"
        case .notification:
            return "Notifications"
        case .starredMessage:
            return "Starred Images"
        }
    }
    
    var imageName: String {
        switch self {
        case .account:
            return "key.fill"
        case .notification:
            return "bell.badge.fill"
        case .starredMessage:
            return "star.fill"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .account:
            return .blue
        case .notification:
            return .red
        case .starredMessage:
            return .yellow
        }
    }
}
