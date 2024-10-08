//
//  SettingsView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = StatusViewModel()
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color(.customBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                NavigationLink {
                    EditProfileView(viewModel: viewModel)
                } label: {
                    SettingsHeader(userStatus: viewModel.userStatus)
                        .padding()
                }
                
                // Options
                VStack(spacing: 0) {
                    ForEach(SettingsCellViewModel.allCases, id:\.self) { vm in
                        SettingsCell(
                            viewModel: vm,
                            isLast: SettingsCellViewModel.allCases.isLastItem(vm)
                        )
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding()
                
                Button {
                    authViewModel.signout()
                } label: {
                    Text("Sign Out")
                        .foregroundStyle(.red)
                        .bodyText(size: 16, weight: .semibold)
                        .frame(width: UIScreen.main.bounds.width - 32,
                               height: 50
                        )
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                
                Spacer()
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    SettingsView(authViewModel: AuthViewModel(service: AuthService()))
}
