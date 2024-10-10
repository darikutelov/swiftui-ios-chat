//
//  ConversationsViewModel.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 9.10.24.
//

import SwiftUI

final class ConversationsViewModel: ObservableObject {
    @Published var recentMessages = [Message]()
    private var recentMessagesDictionary = [String: Message]()
    
    init() {
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        //guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
//        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages")
//        query.order(by: "timestamp", descending: true)
//        
//        query.getDocuments { snapshot, _ in
//            guard let documents = snapshot?.documents else { return }
//            
//            documents.forEach { document in
//                let uid = document.documentID
//                guard var message = try? document.data(as: Message.self) else { return }
//                
//                COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
//                    guard let user = try? snapshot?.data(as: User.self) else { return }
//                    message.user = user
//                    self.recentMessagesDictionary[uid] = message
//                    self.recentMessages = Array(self.recentMessagesDictionary.values)
//                        .sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
//                }
//            }
//        }
    }
}
