//
//  ContentView.swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @EnvironmentObject private var viewModel: GitHubProfileViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text(String.titleText)
                    .font(.title)
                
                TextField(String.textFieldPlaceholder, text: $viewModel.username)
                    .frame(minHeight: .minTextFieldHeight)
                    .font(.largeTitle)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .border(Color(.separator))
                    .padding(.all)
                    
                NavigationLink(destination: GitHubProfileView()) {
                    Text(String.buttonText)
                        .font(.title)
                        .padding(.all)
                        .background(Color.primary)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .cornerRadius(.buttonCornerRadius)
                        .clipped()
                }
            }
        }
    }
}
