//
//  Services.swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import Foundation
import Fundamentals
import SwiftUI
import UIKit

// MARK: GithubService

final class GitHubService {
    @Inject private var httpService: HTTPService
    @Inject private var imageService: ImageService
    @Inject private var logger: Logger
    
    @UserDefault(.init(name: "github.users"))
    private var users: [String: GitHubUser]
    
    func clearCache() {
        logger.debug("Clearing cache (\(users.count) entries)")
        users = [:]
    }
    
    func getUserTask(for username: String) -> Task<GitHubUser, Error> {
        let lowercasedUsername = username.lowercased()
        
        logger.info("Loading details for user: '\(lowercasedUsername)'")

        if let user = users[lowercasedUsername] {
            logger.debug("Cache hit for \(lowercasedUsername)")
            return .just(user)
        }
        
        logger.debug("Cache miss for \(lowercasedUsername)")
        
        let task: Task<GitHubUser, Error> = httpService
            .task(for: GitHubUserRequest(username: lowercasedUsername))
            .flatMap(hydrate)
            .mapError { [weak self] error in
                self?.logger.error("Failed to load user \(lowercasedUsername)")
                self?.logger.error(error)
                return error as Error
            }
        
        return async { [weak self] in
            let user = try await(task)
            
            self?.logger.info("Successfully loaded details for user: \(lowercasedUsername)")
            self?.logger.debug("Caching user for \(lowercasedUsername)")
            self?.users[lowercasedUsername] = user
            
            return user
        }
    }
    
    func hydrate(_ user: GitHubUser) -> Task<GitHubUser, HTTPError> {
        logger.info("Loading repositories for \(user.login)")
        
        return httpService
            .task(for: GitHubRepositoriesRequest(username: user.login))
            .map {
                var u = user
                u.repos = $0
                return u
            }
    }
    
    func getAvatarTask(for username: String) -> Task<UIImage, Error> {
        return imageService
            .load(from: URL(string: "https://github.com/\(username).png?size=200")!)
            .mapError { return $0 as Error }
    }
}

// TODO - Move to Fundamentals

extension Result {
    var didSucceed: Bool {
        return value != nil
    }
    
    var value: Success? {
        switch self {
        case .success(let value): return value
        case .failure(_): return nil
        }
    }
}

extension TaskProtocol {
    func complete(_ completion: @escaping (T?) -> Void) {
        self.run {
            completion($0.value)
        }
    }
}
