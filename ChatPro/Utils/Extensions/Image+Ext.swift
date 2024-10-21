//
//  Image+Extension.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 16.10.24.
//

import SwiftUI

extension Image {
    func roundedImage() -> some View {
        self
            .resizable()
            .scaledToFill()
            .modifier(RoundedImage())
    }
}
