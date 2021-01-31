//
//  ContentView.swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @EnvironmentObject private var service: GitHubService
    @State private var username = String.defaultUserName
    @State private var profileLoaded = false
    @State private var errorOccured = false
    
    var body: some View {
        Text(String.titleText)
            .font(.title)
        
        TextField(String.textFieldPlaceholder, text: $username, onCommit: load)
            .frame(minHeight: .minTextFieldHeight)
            .font(.largeTitle)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .border(Color(.separator))
            .padding(.all)
            .sheet(isPresented: $profileLoaded, content: GitHubProfileView.init)
            .alert(isPresented: $errorOccured, content: errorAlert)
        
        Button(action: load) {
            Text(String.buttonText)
                .font(.title)
                .padding(.all)
                .background(Color.primary)
                .foregroundColor(Color(UIColor.systemBackground))
        }
        .cornerRadius(.buttonCornerRadius)
        .clipped()
    }
}

// MARK: - Private Helper Functions

extension ContentView {
    fileprivate func load() {
        service.loadProfile(for: username) { didSucceed in
            self.errorOccured = !didSucceed
            self.profileLoaded = didSucceed
        }
    }
    
    fileprivate func errorAlert() -> Alert {
        Alert(
            title: Text(String.alertErrorTitle),
            message: Text("\(String.alertErrorMessagePrefix) \(username)")
        )
    }
}

// MARK: - Helper Views

fileprivate struct GitHubUserView: View {
    let profile: GithubProfile
    
    var body: some View {
        VStack(alignment: .center, spacing: .headerVStackSpacing) {
            Image(uiImage: profile.avatar)
                .clipShape(Circle())
                .shadow(radius: .imageShadowRadius)
                .padding(.all)
            
            Text(profile.user.login).font(.title)
            Unwrap(profile.user.bio) { Text($0).fixedSize(horizontal: false, vertical: true) }
            Text(String.repositoriesTitle).bold()
        }
    }
}

fileprivate struct GitHubProfileView: View {
    @EnvironmentObject private var service: GitHubService
    
    var body: some View {
        Unwrap(service.profile) { profile in
            GitHubUserView(profile: profile)
            
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
    }
}

// https://www.swiftbysundell.com/tips/optional-swiftui-views/
fileprivate struct Unwrap<Value, Content: View>: View {
    private let value: Value?
    private let contentProvider: (Value) -> Content

    init(_ value: Value?, @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.contentProvider = content
    }

    var body: some View {
        value.map(contentProvider)
    }
}

// MARK: - String Constants

extension String {
    fileprivate static let defaultUserName = "jabaridash"
    fileprivate static let titleText = "Search for GitHub users"
    fileprivate static let buttonText = "Find user"
    fileprivate static let textFieldPlaceholder = "Enter username"
    fileprivate static let alertErrorTitle = "Oops"
    fileprivate static let alertErrorMessagePrefix = "We were unable to find user"
    fileprivate static let repositoriesTitle = "Repositories:"
}

// MARK: - CGFloat Constants

extension CGFloat {
    fileprivate static let buttonCornerRadius: CGFloat = 8
    fileprivate static let minTextFieldHeight: CGFloat = 60
    fileprivate static let dividerHeight: CGFloat = 1
    fileprivate static let dividerPadding: CGFloat = 16
    fileprivate static let headerVStackSpacing: CGFloat = 16
    fileprivate static let listItemVStackSpacing: CGFloat = 8
    fileprivate static let imageShadowRadius: CGFloat = 10
}
