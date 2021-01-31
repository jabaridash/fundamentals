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

// MARK: - GitHub API

fileprivate typealias GitHubProfileTask = Task<(GitHubUser, UIImage), Error>

// MARK: GithubService

final class GitHubService: ObservableObject {
    @Inject private var httpService: HTTPServiceProtocol
    @Inject private var errorReporter: ErrorReporterProtocol
    @Inject private var imageService: ImageServiceProtocol
    @UserDefault(.user, defaultValue: nil) private var user: GitHubUser?
    @Published var profile: GithubProfile?
}

// MARK: Public API

extension GitHubService {
    func loadProfile(for username: String, completion: ((Bool) -> Void)? = nil) {
        GitHubProfileTask.join(getUserTask(for: username), getAvatarTask(for: username)).run { [weak self] result in
            switch result {
            case .success(let response):
                self?.profile = GithubProfile(response)
                completion?(true)
            case .failure(let error):
                self?.errorReporter.report(error)
                completion?(false)
            }
        }
    }
}

// MARK: - UserDefault keys

extension UserDefaultKey {
    fileprivate static let user = UserDefaultKey(name: "github.user")
}

// MARK: - Private helpers

extension GitHubService {
    private func getUserTask(for username: String) -> Task<GitHubUser, Error> {
        if let user = self.user, user.login == username { return .just(user) }
        
        self.user = nil // Invalidate previously cached values on cache misses
        
        let userTask = httpService.task(for: GitHubUserRequest(username: username))
        let reposTask = httpService.task(for: GitHubRepositoriesRequest(username: username))
        
        return async { [weak self] in
            var user = try await(userTask)
            user.repos = try await(reposTask)
            self?.user = user
            return user
        }
    }
    
    private func getAvatarTask(for username: String) -> Task<UIImage, Error> {
        return imageService.load(
            from: URL(string: "https://github.com/\(username).png?size=200")!
        )
        .mapError { return $0 as Error }
    }
}


// MARK: - Image Downloading

enum ImageDownloadError: LocalizedError {
    case failedToDownload(url: URL, error: Error?)
}

protocol ImageServiceProtocol {
    func load(from url: URL) -> Task<UIImage, ImageDownloadError>
}

final class ImageService: ImageServiceProtocol {
    @Inject private var errorReporter: ErrorReporterProtocol
    
    func load(from url: URL) -> Task<UIImage, ImageDownloadError> {
        return Task<UIImage, ImageDownloadError> { completion in
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    let downloadError = ImageDownloadError.failedToDownload(url: url, error: error)
                    self?.errorReporter.report(downloadError)
                    completion(.failure(downloadError))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            }.resume()
        }
    }
}

// MARK: - Error Reporting

protocol ErrorReporterProtocol {
    func report<E: Error>(_ error: E)
}

final class ErrorReporter: ErrorReporterProtocol {
    @Inject private var logger: LoggerProtocol
    
    func report<E: Error>(_ error: E) {
        logger.error(error)
    }
}
