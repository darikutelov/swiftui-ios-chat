//
//  ProfilePhotoSelectorView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 7.10.24.
//

import SwiftUI

struct ProfilePhotoSelectorView: View {
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @ObservedObject var viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Button {
                imagePickerPresented.toggle()
            } label: {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo.circle")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFill()
                        .frame(width: 180, height: 180)
                        .clipped()
                        .padding(.top, 44)
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }
            .sheet(
                isPresented: $imagePickerPresented,
                onDismiss: loadImage,
                content: {
                    ImagePicker(image: $selectedImage)
                }
            )
            
            Text(profileImage == nil ? "Select a profile photo"
                 : "Great! Tab below to continue"
            )
            .font(.custom("OpenSans-SemiBold", size: 20))
            .foregroundStyle(Color(.secondaryLabel))
            .padding(.top, 12)
            
            if let selectedImage = selectedImage {
                StyledButton(text: "Continue") {
                    Task {
                        await viewModel.uploadProfigeImage(selectedImage)
                    }
                }
                .padding(.top, 24)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
}

#Preview {
    ProfilePhotoSelectorView(viewModel: AuthViewModel(service: AuthService()))
}
