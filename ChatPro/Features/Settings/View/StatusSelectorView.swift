//
//  StatusSelectorView.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 13.12.23.
//

import SwiftUI

struct StatusSelectorView: View {
    @ObservedObject var viewModel: StatusViewModel
    
    var body: some View {
        ZStack {
            Color(.customBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("CURRENTLY SET TO")
                        .foregroundStyle(.primary)
                        .bodyText(size: 16)
                        .padding(.vertical)
                    
                    StatusCell(
                        status: viewModel.userStatus,
                        isLast: true
                    )
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    Text("SELECT YOUT STATUS")
                        .foregroundStyle(.primary)
                        .bodyText(size: 16)
                        .padding(.vertical)
                    
                    VStack(spacing: 0) {
                        ForEach(UserStatus.statusDisplayList, id: \.self) { status in
                            Button {
                                viewModel.updateStatus(status)
                            }
                            label: {
                                StatusCell(
                                    status: status,
                                    isLast: UserStatus.allCases.isLastItem(status)
                                )
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .padding()
            }
        }
    }
}

#Preview {
    StatusSelectorView(viewModel: StatusViewModel())
}

struct StatusCell: View {
    let status: UserStatus
    let isLast: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(status.title)
                    .foregroundStyle(.primary)
                    .bodyText(size: 16)
                    .padding()
                Spacer()
            }
            
            if !isLast {
                Divider()
                    .padding(.leading)
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
    }
}
