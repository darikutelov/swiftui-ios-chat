//
//  CreateChannelScreen.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 16.10.24.
//

import SwiftUI

struct CreateChannelScreen: View {
    @Environment(\.presentationMode ) private var mode
    @Binding var show: Bool
    let currentUser: User?
    let channelService: ChannelService
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var channelImage: Image?
    @State private var channelName = ""
    
    @ObservedObject var viewModel: CreateChannelViewModel
    
    init(
        users: [User],
        show: Binding<Bool>,
        currentUser: User?,
        channelService: ChannelService
    ) {
        self._show = show
        self.currentUser = currentUser
        self.channelService = channelService
        self.viewModel = CreateChannelViewModel(
            users: users,
            currentUser: currentUser,
            channelService: channelService
        )
    }
    
    var inputValid: Bool {
        !channelName.isEmpty && channelImage != nil
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: K.Space.base * 8) {
                Button {
                    showImagePicker.toggle()
                } label: {
                    if let channelImage = channelImage {
                        channelImage
                            .roundedImage()
                    } else {
                        Image(systemName: T.IconNames.photoInFrame)
                            .roundedImage()
                            .foregroundStyle(.customTerciary)
                    }
                }
                .sheet(
                    isPresented: $showImagePicker,
                    onDismiss: loadImage, 
                    content: {
                        ImagePicker(image: $selectedImage)
                    }
                )
                
                VStack(
                    alignment: .leading,
                    spacing: K.Space.base * 3
                ) {
                    TextField(T.Rooms.enterMessage, text: $channelName)
                        .bodyText(size: 15)
                    
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color(.separator))
                }.padding(.trailing)
            }
            .padding()
            
            Spacer()
  
            StyledButton(
                text: T.ButtonText.create,
                isLoading: viewModel.isSaving,
                disabled: !inputValid
            ) {
                Task {
                    await viewModel.createChannel(
                        name: channelName,
                        image: selectedImage
                    )
                }
            }
        }
        .onReceive(viewModel.$didCrateChannel, perform: { completed in
            if completed {
                mode.wrappedValue.dismiss()
                show.toggle()
            }
        })
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        channelImage = Image(uiImage: selectedImage)
    }
}

#Preview {
    CreateChannelScreen(
        users: [],
        show: .constant(false),
        currentUser: MOCK_USER,
        channelService: ChannelService()
    )
}
