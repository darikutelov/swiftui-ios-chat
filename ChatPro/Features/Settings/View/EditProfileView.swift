//
//  EditProfileView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI
import Kingfisher

struct EditProfileView: View {
    @State private var fullname = ""
    @State private var profileImage: Image?
    
    @ObservedObject var satusViewModel: StatusViewModel
    @ObservedObject var userManager: UserManager
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            Color(.customBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 44) {
                // Header
                VStack {
                    HStack {
                        VStack {
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                            }  else {
                                KFImage(URL(string: userManager.currentUser?.profileImageUrl ?? ""))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                                    .padding(.leading)
                            }
                            Button {
                                showImagePicker.toggle()
                            } label: {
                                Text("Edit")
                                    .bodyText(size: 16)
                            }
                            .sheet(
                                isPresented: $showImagePicker,
                                onDismiss: loadImage,
                                content: {
                                    ImagePicker(image: $selectedImage)
                                }
                            )
                        }
                        .padding(.top)
                        
                        Text("Enter your name or change your profile photo")
                            .bodyText(size: 16)
                            .foregroundStyle(.gray)
                            .padding([.bottom, .horizontal])
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    TextField("", text: $userManager.editableUser.fullname)
                        .bodyText(size: 16)
                    
                    Button("Save Changes") {
                        Task {
                            try await userManager.saveChanges()
                        }
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding()
                
                // Status
                VStack(alignment: .leading) {
                    Text("Status")
                        .foregroundStyle(Color(.secondaryLabel))
                        .bodyText(size: 16)
                        .padding()
                    
                    NavigationLink {
                        StatusSelectorView(viewModel: satusViewModel)
                    } label: {
                        HStack {
                            Text(satusViewModel.userStatus.title)
                                .bodyText(size: 16)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.gray)
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding()
                    }
                }
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Edit Profile")
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        profileImage = Image(uiImage: selectedImage)
    }
}

#Preview {
    EditProfileView(
        satusViewModel: StatusViewModel(),
        userManager: UserManager(
            authService: AuthService(),
            userService: UserService()
        )
    )
}
