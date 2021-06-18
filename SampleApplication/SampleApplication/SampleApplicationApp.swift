//
//  SampleApplicationApp.swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import Fundamentals
import SwiftUI

@main
struct SampleApplicationApp: App {
    private let container = ServiceContainer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GitHubProfileViewModel())
        }
    }

    // MARK: - App Startup Logic

    init() {
        var httpConfiguration = HTTPConfiguration.default
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        httpConfiguration.jsonDecoder = jsonDecoder
        let httpService = HTTPService(session: .shared, httpConfiguration: httpConfiguration)

        container.register(httpService, as: HTTPService.self)
        container.register(Logger(), as: Logger.self)
        container.register(ImageService(), as: ImageService.self)
        container.register(GitHubService(), as: GitHubService.self)
    }
}
