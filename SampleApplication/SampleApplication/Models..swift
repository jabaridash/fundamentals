//
//  Models..swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import Foundation
import Fundamentals
import UIKit

// MARK: - GithubProfile

struct GithubProfile {
    let user: GitHubUser
    let avatar: UIImage
}

// MARK: - GitHubUser

struct GitHubUser: Codable {
    let login: String
    let id: Int
    let avatarUrl: URL
    let htmlUrl: URL
    let reposUrl: URL
    let bio: String?
    @Defaulted var repos: [GitHubRepository]
}

// MARK: - GitHubRepository

struct GitHubRepository: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let htmlUrl: URL
    let description: String?
    let language: String?
}

// MARK: - GitHubUserRequest

struct GitHubUserRequest: HTTPRequest {
    typealias ResponseBody = GitHubUser
    
    let url: URL
    
    init(username: String) {
        self.url = URL(string: "https://api.github.com/users/\(username)")!
    }
}

// MARK: - GitHubRepositoriesRequest

struct GitHubRepositoriesRequest: HTTPRequest {
    typealias ResponseBody = [GitHubRepository]
    
    let url: URL
    
    init(username: String) {
        self.url = URL(string: "https://api.github.com/users/\(username)/repos")!
    }
}
