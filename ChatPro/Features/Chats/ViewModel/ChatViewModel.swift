//
//  ChatViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 6.10.24.
//

import Foundation

final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = [
        MOCK_MESSAGE
    ]
    
    var newMessageId: String = ""
    
    func sendMessage(_ messageText: String) {
//        let message = Message(
//            isFromCurrentUser: true,
//            messageText: messageText
//        )
//        newMessageId = message.id
//        
//        messages.append(message)
//        
//        // Reset newMessageId after a delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.newMessageId = ""
//        }
    }
}
