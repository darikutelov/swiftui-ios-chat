//
//  CustomTextField.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct CustomTextField: View {
    let iconName: String
    let label: String
    @Binding var text: String
    var isSecure = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.gray)
                
                if isSecure {
                    SecureField(label, text: $text)
                        .textInputAutocapitalization(.never)
                        .font(.custom("OpenSans-Regular", size: 14))
                } else {
                    TextField(label, text: $text)
                        .font(.custom("OpenSans-Regular", size: 14))
                        .textInputAutocapitalization(.never)
                }
            }
            Divider()
                .background(Color(.darkGray))
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(
            iconName: "envelope",
            label: "Email",
            text: .constant("text")
        )
    }
}
