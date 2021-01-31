//
//  SampleApplicationApp+ServiceContainer.swift
//  SampleApplication
//
//  Created by jabari on 1/30/21.
//

import Foundation
import Fundamentals
import SwiftUI

// TODO - Add to Fundamentals

extension View {
    func environmentObject<T: ObservableObject>(from container: ServiceContainer = .shared, for type: T.Type) -> some View {
        return environmentObject(container.get(type))
    }
}

// MARK: - ServiceContainer registration

extension SampleApplicationApp {
    static func registerServices() {
        ServiceContainer.shared.register(getLogger(), as: LoggerProtocol.self)
        ServiceContainer.shared.register(getHttpService(), as: HTTPServiceProtocol.self)
        ServiceContainer.shared.register(getErrorReporter(), as: ErrorReporterProtocol.self)
        ServiceContainer.shared.register(getImageService(), as: ImageServiceProtocol.self)
        ServiceContainer.shared.register(getGitHubService(), as: GitHubService.self)
    }
    
    fileprivate static func getLogger() -> LoggerProtocol {
        return Logger()
    }
    
    fileprivate static func getErrorReporter() -> ErrorReporterProtocol {
        return ErrorReporter()
    }
    
    fileprivate static func getImageService() -> ImageServiceProtocol {
        return ImageService()
    }
    
    fileprivate static func getHttpService() -> HTTPServiceProtocol {
        var httpConfiguration = HTTPConfiguration.default
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        httpConfiguration.jsonDecoder = jsonDecoder
        
        return HTTPService(session: .shared, httpConfiguration: httpConfiguration)
    }
    
    fileprivate static func getGitHubService() -> GitHubService {
        return GitHubService()
    }
}

