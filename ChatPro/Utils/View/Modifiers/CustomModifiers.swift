//
//  CustomModifiers.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 8.10.24.
//

import SwiftUI

struct Heading: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("SHRIMP", size: 32))
            .foregroundStyle(Color(.customPrimary))
            .lineLimit(2)
            .minimumScaleFactor(0.75)
    }
}

struct BodyText: ViewModifier {
    var size: CGFloat
    var weight: CustomFontWeight
    
    func body(content: Content) -> some View {
        content
            .font(.custom(weight.fontName, size: size))
            .minimumScaleFactor(0.75)
    }
}

enum CustomFontWeight {
    case bold
    case semibold
    case regular
    case medium
    
    var fontName: String {
        switch self {
        case .bold:
            return "OpenSans-Bold"
        case .semibold:
            return "OpenSans-SemiBold"
        case .regular:
            return "OpenSans-Regular"
        case .medium:
            return "OpenSans-Medium"
        }
    }
}

struct RoundedImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 64, height: 64)
            .clipShape(Circle())
    }
}

