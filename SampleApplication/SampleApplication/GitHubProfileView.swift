//
//  GitHubProfileView.swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import SwiftUI

// MARK: - GitHubProfileView

struct GitHubProfileView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var viewModel: GitHubProfileViewModel
    
    var body: some View {
        Unwrap(viewModel.profile) { profile in
            VStack(alignment: .center, spacing: .headerVStackSpacing) {
                Image(uiImage: profile.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .shadow(radius: .imageShadowRadius)
                
                Text(profile.user.login).font(.title)
                Unwrap(profile.user.bio) { Text($0).fixedSize(horizontal: false, vertical: true) }
                Text(String.repositoriesTitle).bold()
            }
            
            Divider()
                .frame(height: .dividerHeight)
                .padding(.horizontal, .dividerPadding)
                .background(Color(.separator))
            
            List(profile.user.repos) { repo in
                VStack(alignment: .leading, spacing: .listItemVStackSpacing) {
                    Text(repo.name).bold()
                    Unwrap(repo.description, content: Text.init)
                }
            }
        }
        .navigationBarItems(trailing: Button(String.clearCacheButtonText, action: viewModel.clearCache))
        .onAppear(perform: viewModel.reload)
        .onDisappear(perform: viewModel.reset)
        .alert(isPresented: $viewModel.loadFailed) {
            Alert(
                title: Text(String.alertErrorTitle),
                message: Text(String.alertErrorMessagePrefix),
                dismissButton: .default(Text(String.ok), action: dismiss)
            )
        }
        
    }
}

// MARK: - GitHubProfileView helpers

private extension GitHubProfileView {
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
