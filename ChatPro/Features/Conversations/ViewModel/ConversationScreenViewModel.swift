//
//  ConversationsViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 9.10.24.
//

import SwiftUI

@MainActor
final class ConversationScreenViewModel: ObservableObject {
    let currentUser: User?
    let messageService: MessageService
    
    @Published var recentMessages = [Message]()
    @Published var isShowingNewMessageView = false
    @Published var isLoading = true
    @Published var showChatView = false
    @Published var selectedUser: User?
    
    init(currentUser: User?, messageService: MessageService) {
        self.currentUser = currentUser
        self.messageService = messageService
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        guard let currentUserId = currentUser?.id else { return }
        isLoading = true
        messageService.fetchRecentMessage(userUid: currentUserId) { result in
            switch result {
            case .success(let messages):
                self.isLoading = false
                self.recentMessages = messages
            case .failure(let error):
                print("Error fetching messages with users: \(error.localizedDescription)")
            }
        }
    }
}
