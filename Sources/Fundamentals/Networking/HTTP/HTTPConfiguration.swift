//
//  HTTPConfiguration.swift
//  Fundamentals
//
//  Created by jabari on 11/6/20.
//

import Foundation

// MARK: - HTTPServiceConfigurationProtocol

/// Provides information that helps determine how to encode outgoing requests, and decode and handle incoming responses.
public struct HTTPConfiguration {
    public static let `default`: HTTPConfiguration = .init()
    
    /// Specifies how to address HTTP caching.
    public var cachePolicy: NSURLRequest.CachePolicy? = nil
    
    /// Default headers that will be used with all outgoing requests.
    public var defaultHeaders: [String: String] = [:]
    
    /// Default URL parameters that will be sent with every `HTTPRequest`.
    public var defaultParameters: [String: String] = [:]

    /// Decodes the HTTP body incoming responses.
    public var jsonDecoder: JSONDecoder = JSONDecoder()
    
    /// Encodes the HTTP body outgoing requests.
    public var jsonEncoder: JSONEncoder = JSONEncoder()
    
    /// Determines whether or not the status code of a response should be handled. If this value is `false`,
    /// all responses that come back with `Data` will be treated as a `.success` type. Otherwise, only responses
    /// with a `2XX` status code will be treated as `.success`. All other status codes will be considered a `.failure`,
    /// with an associated value that details the specified type of failure along with its status code.
    public var shouldHandleStatusCode: Bool = true
    
    /// Number of seconds before timing out.
    public var timeoutInterval: TimeInterval? = nil
}
