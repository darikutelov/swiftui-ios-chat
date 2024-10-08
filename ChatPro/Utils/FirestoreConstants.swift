//
//  FirestoreConstants.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 7.10.24.
//

import Firebase

struct FirestoreConstants {
    private static let Root = Firestore.firestore()
    static let UserCollection = Root.collection("users")
}
