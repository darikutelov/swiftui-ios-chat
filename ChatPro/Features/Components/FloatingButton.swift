//
//  FloatingButton.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI

struct FloatingButton: View {
    @Binding var show: Bool
    
    var body: some View {
        Button(action: { show.toggle() }, label: {
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding()
                .offset(x: 2, y: -2)
        })
        .background(Color(.customPrimaryBackground))
        .foregroundColor(.white)
        .clipShape(Circle())
        .padding()
        
    }
}

#Preview {
    FloatingButton(show: .constant(true))
}
