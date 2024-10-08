//
//  LoginView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hello".uppercased())
                            .headingStyle()
                        Text("Welcome Back")
                            .headingStyle()
                    }
                    CustomTextField(
                        iconName: "envelope",
                        label: "Email",
                        text: $viewModel.email
                    )
                    .padding(.top, 32)
                    
                    CustomTextField(
                        iconName: "lock",
                        label: "Password",
                        text: $viewModel.password,
                        isSecure: true
                    )
                }
                .padding([.top, .horizontal], 32)
                
                HStack {
                    Spacer()
                    
                    NavigationLink {
                        Text("Reset password")
                    } label: {
                        Text("Forgot Password?")
                            .font(.custom("OpenSans-SemiBold", size: 13))
                            .padding(.top)
                            .padding(.trailing, 28)
                            .foregroundStyle(Color(.custom7))
                    }
                }
                
                Spacer()
                
                StyledButton(
                    text: "Sign In",
                    isLoading: viewModel.isLoading,
                    formIsValid: formIsValid
                ) {
                    if !formIsValid {
                        viewModel.authError = .invalidData
                        viewModel.showAlert = true
                        return
                    }
                    
                    Task {
                        await viewModel.login()
                    }
                }
                
                Spacer()
                
                NavigationLink {
                    RegisterView(viewModel: viewModel)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    VStack {
                        HStack {
                            Text("Don't have an account?")
                                .font(.custom("OpenSans-Regular", size: 14))
                            
                            Text("Sign Up")
                                .font(.custom("OpenSans-SemiBold", size: 14))
                        }
                        .foregroundStyle(Color(.custom7))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 16)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .padding(.top, 80)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.authError?.description ?? ""))
            }
        }
    }
}

// MARK: - Form Validation

extension LoginView {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && !viewModel.password.isEmpty
        && viewModel.password.count > 5
    }
}


#Preview {
    LoginView(viewModel: AuthViewModel(service: AuthService()))
}

