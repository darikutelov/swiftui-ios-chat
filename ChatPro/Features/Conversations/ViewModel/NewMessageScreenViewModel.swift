//
//  NewMessageViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 9.10.24.
//

import SwiftUI

@MainActor
final class NewMessageScreenViewModel: ObservableObject {
    @Published var users = [User]()
    let usersService = UsersService()
    
    init() {
        Task {
            await fetchUsers()
        }
    }
    
    func fetchUsers() async {
        do {
            users = try await usersService.fetchUsers()
        } catch {
            print(error.localizedDescription)
        }
    }
}
