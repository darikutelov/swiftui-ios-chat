//
//  NewMessageViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 9.10.24.
//

import SwiftUI

@MainActor
final class SelectChatPartnerScreenViewModel: ObservableObject {
    @Published var users = [User]()
    private let userManager: UserManager
    
    init(userManager: UserManager) {
        self.userManager = userManager
        
        Task {
            await fetchUsers()
        }
    }
    
    func fetchUsers() async {
        do {
            self.users = try await userManager.fetchUsers()
        } catch {
            print(error.localizedDescription)
        }
    }
}
