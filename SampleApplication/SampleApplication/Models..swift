//
//  Models..swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import Foundation
import Fundamentals
import UIKit

// MARK: - In-app models

struct GithubProfile {
    let user: GitHubUser
    let avatar: UIImage
    
    init(_ tuple: (GitHubUser, UIImage)) {
        self.user = tuple.0
        self.avatar = tuple.1
    }
}

// MARK: - HTTPRequest.ResponseBody models

struct GitHubUser: Codable {
    let login: String
    let id: Int
    let avatarUrl: URL
    let htmlUrl: URL
    let reposUrl: URL
    let bio: String?
    @Defaulted var repos: [GitHubRepository]
}

struct GitHubRepository: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let htmlUrl: URL
    let description: String?
    let language: String?
}

// MARK: - HTTPRequest models

struct GitHubUserRequest: HTTPRequest {
    typealias ResponseBody = GitHubUser
    
    let url: URL
    
    init(username: String) {
        self.url = URL(string: "https://api.github.com/users/\(username)")!
    }
}

struct GitHubRepositoriesRequest: HTTPRequest {
    typealias ResponseBody = [GitHubRepository]
    
    let url: URL
    
    init(username: String) {
        self.url = URL(string: "https://api.github.com/users/\(username)/repos")!
    }
}
