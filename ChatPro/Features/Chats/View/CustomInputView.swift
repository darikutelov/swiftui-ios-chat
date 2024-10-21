//
//  CustomInputView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 14.12.23.
//

import SwiftUI

struct CustomInputView: View {
    @Binding var inputText: String
    @Binding var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var image: Image?
    
    var action: () async -> Void
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color(.separator))
                .frame(width: UIScreen.main.bounds.width, height: 0.75)
                .padding(.bottom, 8)
            
            HStack {
                if let image = image, selectedImage != nil {
                    ZStack(alignment: .topTrailing) {
                        image
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 68, height: 68)
                            .cornerRadius(8)
                        
                        Button(action: {
                            selectedImage = nil
                        }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                                .padding(8)
                        })
                        .background(Color(.gray))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .offset(x: -4, y: 4)
                    }
                    
                    Spacer()
                } else {
                    Button {
                        showImagePicker.toggle()
                    } label: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.primary)
                            .padding(.trailing, 4)
                    }
                    .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
                        ImagePicker(image: $selectedImage)
                    })
                    
                    TextField("Message..", text: $inputText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .bodyText(size: 16)
                        .frame(minHeight: 30)
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.secondarySystemBackground))
                        }
                        .onSubmit {
                            UIApplication.shared.endEditing()
                        }
                }
                
                Button {
                    Task {
                        hideKeyboard()
                        await action()
                    }
                } label: {
                    Image(systemName: "paperplane.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.primary)
                }
            }
            .padding(.bottom, 8)
        }
    }
    
    private func loadImage() {
        guard let selectedImage = selectedImage else { return }
        image = Image(uiImage: selectedImage)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    CustomInputView(
        inputText: .constant("Type Something"), 
        selectedImage: .constant(nil)
    ) {
        
    }
}
