//
//  View+Ext.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 8.10.24.
//

import SwiftUI

extension View {
    func headingStyle() -> some View {
        self.modifier(Heading())
    }
    
    func bodyText(size: CGFloat = 14, weight: CustomFontWeight = .regular) -> some View {
        self.modifier(BodyText(size: size, weight: weight))
    }

    func requiresAuthentication(userManager: UserManager) -> some View {
        self.modifier(RequiresAuthentication(userManager: userManager))
    }
    
    func roundedImage() -> some View {
        self.modifier(RoundedImage())
    }
}
