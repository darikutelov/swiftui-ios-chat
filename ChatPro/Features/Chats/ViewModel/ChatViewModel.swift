//
//  ChatViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 6.10.24.
//

import Foundation

final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = [
        .init(isFromCurrentUser: true, messageText: "Hey, how's it going?"),
        .init(isFromCurrentUser: false, messageText: "Hey! I'm doing well, thanks for asking. How about you?"),
        .init(isFromCurrentUser: true, messageText: "I'm good too, just been working on a new app."),
        .init(isFromCurrentUser: false, messageText: "That sounds interesting! What's the app about?"),
        .init(isFromCurrentUser: true, messageText: "It's a food ordering app with Supabase and Stripe integration."),
        .init(isFromCurrentUser: false, messageText: "Wow, nice! Have you run into any challenges with it?"),
        .init(isFromCurrentUser: true, messageText: "Yeah, had some trouble with relative imports in Deno, but I figured it out."),
        .init(isFromCurrentUser: false, messageText: "Glad to hear! Good luck with the rest of it."),
        .init(isFromCurrentUser: true, messageText: "Thanks! Appreciate it."),
    ]
    
    var newMessageId: String = ""
    
    func sendMessage(_ messageText: String) {
        let message = Message(
            isFromCurrentUser: true,
            messageText: messageText
        )
        newMessageId = message.id
        
        messages.append(message)
        
        // Reset newMessageId after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.newMessageId = ""
        }
    }
}
