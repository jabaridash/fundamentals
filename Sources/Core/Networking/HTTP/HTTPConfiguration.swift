//
//  HTTPConfiguration.swift
//  Core
//
//  Created by jabari on 11/6/20.
//

import Foundation

// MARK: - HTTPServiceConfiguration

/// Provides information that helps determine how to encode outgoing requests, and decode and handle incoming responses.
public protocol HTTPConfiguration {
    /// Specifies how to address HTTP caching.
    var cachePolicy: NSURLRequest.CachePolicy? { get }
    
    /// Default headers that will be used with all outgoing requests.
    var defaultHeaders: [String: String] { get }
    
    /// Default URL parameters that will be sent with every `HTTPRequest`.
    var defaultParameters: [String: String] { get }

    /// Decodes the HTTP body incoming responses.
    var jsonDecoder: JSONDecoder { get }
    
    /// Encodes the HTTP body outgoing requests.
    var jsonEncoder: JSONEncoder { get }
    
    /// Determines whether or not the status code of a response should be handled. If this value is `false`,
    /// all responses that come back with `Data` will be treated as a `.success` type. Otherwise, only responses
    /// with a `2XX` status code will be treated as `.success`. All other status codes will be considered a `.failure`,
    /// with an associated value that details the specified type of failure along with its status code.
    var shouldHandleStatusCode: Bool { get }
    
    /// Number of seconds before timing out.
    var timeoutInterval: TimeInterval? { get }
}

// MARK: - Default implementations for properties on `HTTPServiceConfiguration`.

public extension HTTPConfiguration {
    var cachePolicy: NSURLRequest.CachePolicy? { nil }
    var defaultHeaders: [String: String] { [:] }
    var defaultParameters: [String: String] { [:] }
    var jsonDecoder: JSONDecoder { JSONDecoder() }
    var jsonEncoder: JSONEncoder { JSONEncoder() }
    var shouldHandleStatusCode: Bool { true }
    var timeoutInterval: TimeInterval? { nil }
}
