//
//  HTTPConfigurations.swift
//  Fundamentals
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - HTTPConfigurations

/// Contains concrete implementations of `HTTPConfiguration` for easy reuse.
public enum HTTPConfigurations {
    // MARK: - HTTPConfigurations.Default

    /// An implementation of `HTTPConfiguration` that uses all of the default values.
    public struct Default: HTTPConfiguration {}
    
    // MARK: - HTTPConfigurations.Baisc

    /// An implementation of `HTTPConfiguration` that uses none of the default values. All properties'
    /// values must be explicitly specified in the initializer.
    public struct BasicHTTPConfiguration: HTTPConfiguration {
        public let cachePolicy: NSURLRequest.CachePolicy?
        public let defaultHeaders: [String: String]
        public let defaultParameters: [String: String]
        public let jsonDecoder: JSONDecoder
        public let jsonEncoder: JSONEncoder
        public let shouldHandleStatusCode: Bool
        public let timeoutInterval: TimeInterval?
    }
}
