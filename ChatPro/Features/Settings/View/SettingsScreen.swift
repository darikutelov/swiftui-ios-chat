//
//  SettingsView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct SettingsScreen: View {
    @StateObject var satusViewModel = StatusViewModel()
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.customBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    NavigationLink {
                        EditProfileView(
                            satusViewModel: satusViewModel,
                            userManager: userManager
                        )
                    } label: {
                        SettingsHeader(
                            userStatus: satusViewModel.userStatus,
                            userManager: userManager
                        )
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
                        userManager.signout()
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(T.Titles.settings)
                        .headingStyle()
                }
            }
            .tint(Color(.customPrimary))
        }
    }
}

#Preview {
    SettingsScreen(
        userManager: UserManager(authService: AuthService(), userService: UserService())
    )
}
