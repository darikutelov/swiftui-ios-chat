//
//  StyledButton.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 7.10.24.
//

import SwiftUI

struct StyledButton: View {
    let text: String
    var isLoading: Bool = false
    var formIsValid: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(isLoading ? "" : text)
                .font(.custom("OpenSans-SemiBold", size: 16, relativeTo: .headline))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(.customPrimaryBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
                .overlay {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
        }
        .shadow(
            color: Color.gray.opacity(0.3),
            radius: 5,
            x: 0.0, y: 0.0
        )
        .disabled(isLoading)
    }
}


#Preview {
    StyledButton(text: "Sign Up") {
        print("Styled button tapped")
    }
}
