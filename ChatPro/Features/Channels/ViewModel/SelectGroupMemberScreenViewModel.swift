//
//  SelectGroupMemberScreenViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.10.24.
//

import Foundation

@MainActor
final class SelectGroupMemberScreenViewModel: ObservableObject {
    var userManager: UserManager
    
    @Published var selectableUsers = [SelectableUser]()
    @Published var selectedUsers = [SelectableUser]()
    
    init(userManager: UserManager) {
        self.userManager = userManager
        Task {
            await fetchUsers()
        }
    }
    
    func fetchUsers() async {
        do {
            let users = try await userManager.fetchUsers()
            self.selectableUsers = users.map {
                SelectableUser(user: $0, isSelected: false)
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func selectUser(_ user: SelectableUser, isSelected: Bool) {
        guard let index = selectableUsers
            .firstIndex(where: { $0.id == user.id }) else { return }
        
        selectableUsers[index].isSelected = isSelected
        
        if isSelected {
            selectedUsers.append(selectableUsers[index])
        } else {
            selectedUsers
                .removeAll(where: { $0.id == user.user.id })
        }
    }
    
    func filteredUsers(_ query: String) -> [SelectableUser] {
        let lowercasedQuery = query.lowercased()
        return selectableUsers.filter({
            $0.user.fullname.lowercased().contains(lowercasedQuery)
            || $0.user.username.contains(lowercasedQuery)
        })
    }
}
