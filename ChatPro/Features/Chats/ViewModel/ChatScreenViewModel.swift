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
    let currentUser: User
    var newMessageId: String = ""
    let messageService = MessageService()

    @Published var messages = [Message]()
    
    init(chatPartner: User?, currentUser: User) {
        self.chatPartner = chatPartner
        self.currentUser = currentUser
        
        Task {
            await fetchMessages()
        }
    }
    
    func fetchMessages() async {
        guard let currentUid = currentUser.id else { return }
        guard let chatPartnerId = chatPartner?.id else { return }
        
        do {
            let messages = try await messageService.fetchMessages(currentUserId: currentUid, chatPartnerId: chatPartnerId)
            self.messages = messages
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func sendMessage(_ messageText: String) async {
        guard let currentUserId = currentUser.id else { return }
        guard let chatPartnerId = chatPartner?.id else { return }
        
        do {
            self.newMessageId = try await messageService
                .saveMessage(
                    currentUserId: currentUserId,
                    chatPartnerId: chatPartnerId,
                    text: messageText
                )
   
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.newMessageId = ""
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
