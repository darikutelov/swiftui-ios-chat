//
//  ChannelChatViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 17.10.24.
//

import Foundation
import UIKit
import FirebaseFirestore

@MainActor
final class ChannelChatScreenModel: ObservableObject {
    private var users = [User]()

    @Published var messages = [Message]()
    @Published var messageToSetVisible: String?
    
    @Published var newMessageText = ""
    @Published var selectedImage: UIImage?
    
    private let channelService: ChannelService
    
    init(channelService: ChannelService) {
        self.channelService = channelService
        Task {
            await fetchChennelMessages()
        }
    }
    
    func fetchChennelMessages() async {
        guard let currentUserId = channelService.currentUser?.id else { return }
        
        channelService.fetchChannelMessages() { result in
            switch result {
            case .success(let messages):
                for (index, message) in self.messages.enumerated() where message.fromId != currentUserId {
        
                    if let index = self.users.firstIndex(where: { $0.id == message.fromId }) {
                        print("DEBUG: Found user \(self.users[index].username)")
                        self.messages[index].user = self.users[index]
                    } else {
//                        UserService.fetchUser(withUid: message.fromId) { user in
//                            print("DEBUG: Did fetch user \(user)")
//                            self.users.append(user)
//                            self.messages[index].user = user
//                            self.messageToSetVisible = self.messages.last?.id
//                        }
                    }
                }
            case .failure(let error):
                print("DEBUG: Error in getting messages from channel serivice: \(error.localizedDescription)")
            }
        }
        


    }
    
    func sendChannelMessage() async {
        //TODO: - validate message text & disable button
        
        guard let currentUser = channelService.currentUser else { return }
        guard let currentUserId = currentUser.id else { return }
 
        let text = "\(currentUser.fullname): \(newMessageText))"
        
        let newMessage = ChannelMessage(
            fromId: currentUserId,
            timestamp: Timestamp(date: Date()),
            text: newMessageText
        )
        
        do {
            let newMessageId = try await channelService
                .saveChannelMessage(message: newMessage)
            
            self.messageToSetVisible = newMessageId
            try await channelService.updateLastMessage(text: text)
        } catch {
            print("DEBUG: Failed to save message or update channel: \(error.localizedDescription)")
        }
    }
}
