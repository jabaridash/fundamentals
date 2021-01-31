//
//  GitHubProfileViewModel.swift
//  SampleApplication
//
//  Created by jabari on 1/31/21.
//

import Fundamentals
import SwiftUI

fileprivate typealias GitHubProfileTask = Task<(GitHubUser, UIImage), Error>

final class GitHubProfileViewModel: ObservableObject {
    @Inject private var service: GitHubService
    @Published var profile: GithubProfile?
    @Published var username: String = .defaultUserName
    @Published var loadFailed: Bool = false
    
    func reload() {
        reset()
        loadFailed = false
        
        GitHubProfileTask.join(
            service.getUserTask(for: username),
            service.getAvatarTask(for: username)
        )
        .map { GithubProfile(user: $0.0, avatar: $0.1) }
        .complete { [weak self] in
            guard let profile = $0 else {
                self?.loadFailed = true
                return
            }
            
            self?.profile = profile
        }
    }
    
    func reset() {
        profile = nil
        loadFailed = false
    }
    
    func clearCache() {
        service.clearCache()
    }
}
