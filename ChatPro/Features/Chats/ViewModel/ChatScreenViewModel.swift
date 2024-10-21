//
//  ChatViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 6.10.24.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ChatScreenViewModel: ObservableObject {
    let chatPartner: User?
    let currentUser: User?
    let messageService: MessageService
    
    @Published var messages = [Message]()
    @Published var messageText: String = ""
    @Published var messageToSetVisible: String?
    
    init(chatPartner: User?, currentUser: User?, messageService: MessageService) {
        self.chatPartner = chatPartner
        self.currentUser = currentUser
        self.messageService = messageService
        
        Task {
            await fetchMessages()
        }
    }
    
    func fetchMessages() async {
        guard let currentUid = currentUser?.id else { return }
        guard let chatPartnerId = chatPartner?.id else { return }
        
        messageService.fetchMessages(currentUserId: currentUid, chatPartnerId: chatPartnerId) { messages in
            var messages = messages
            for (index, message) in messages.enumerated() where message.fromId != currentUid {
                messages[index].user = self.chatPartner
            }
            self.messages = messages
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.messageToSetVisible = self.messages.last?.id
            }
        }
    }
    
    func sendMessage() async {
        guard let currentUserId = currentUser?.id else { return }
        guard let chatPartnerId = chatPartner?.id else { return }
        
        do {
            let _ = try await messageService
                .saveMessage(
                    currentUserId: currentUserId,
                    chatPartnerId: chatPartnerId,
                    text: self.messageText
                )
        } catch {
            print(error.localizedDescription)
        }
    }
}
