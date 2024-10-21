//
//  RegisterView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Get Started".uppercased())
                        .headingStyle()
                    Text("Create your account")
                        .headingStyle()
                }
                CustomTextField(
                    iconName: "envelope",
                    label: "Email",
                    text: $viewModel.email
                )
                .padding(.top, 32)
                
                CustomTextField(
                    iconName: "person",
                    label: "Username",
                    text: $viewModel.username
                )
                
                CustomTextField(
                    iconName: "person",
                    label: "Full Name",
                    text: $viewModel.fullname
                )
                
                CustomTextField(
                    iconName: "lock",
                    label: "Password",
                    text: $viewModel.password,
                    isSecure: true
                )
            }
            .padding([.top, .horizontal], 32)
            
            StyledButton(
                text: "Sign Up",
                isLoading: viewModel.isLoading,
                formIsValid: formIsValid
            ) {
                if !formIsValid {
                    viewModel.authError = .invalidData
                    viewModel.showAlert = true
                    return
                }
                
                Task {
                    await viewModel.createUser()
                }
            }
            .padding(.top, 16)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                VStack {
                    HStack {
                        Text("Already have an account?")
                            .font(.custom("OpenSans-Regular", size: 14))
                        
                        Text("Sign In")
                            .font(.custom("OpenSans-SemiBold", size: 14))
                    }
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color(.custom7))
            }
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.authError?.description ?? ""))
        }
        .navigationDestination(isPresented: $viewModel.hasRegistered) {
            ProfilePhotoSelectorView(viewModel: viewModel)
        }
    }
}

#Preview {
    RegisterView(
        viewModel: AuthViewModel(
            userManager: UserManager(authService: AuthService(), userService: UserService())
        )
    )
}

// MARK: - Form Validation

extension RegisterView {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && !viewModel.fullname.isEmpty
        && !viewModel.username.isEmpty
        && viewModel.password.count > 5
    }
}
