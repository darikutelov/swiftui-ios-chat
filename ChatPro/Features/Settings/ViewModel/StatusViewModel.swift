//
//  StatusViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

class StatusViewModel: ObservableObject {
    @Published var userStatus: UserStatus = .notConfigured
    
    @MainActor
    func updateStatus(_ status: UserStatus) {
        self.userStatus = status
    }
}
