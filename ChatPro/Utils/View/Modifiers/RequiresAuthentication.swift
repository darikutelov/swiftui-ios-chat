//
//  RequiresAuthentication.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.10.24.
//

import Foundation
import SwiftUI

struct RequiresAuthentication: ViewModifier {
    @ObservedObject var userManager: UserManager
    
    func body(content: Content) -> some View {
        Group {
            if userManager.isAuthenticated == nil {
                ProgressView()
            } else if userManager.isAuthenticated == true {
                content
            } else {
                LoginView(userManager: userManager)
            }
        }
    }
}
