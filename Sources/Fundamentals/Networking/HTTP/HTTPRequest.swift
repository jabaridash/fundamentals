//
//  HTTPRequest.swift
//  Fundamentals
//
//  Created by jabari on 11/6/20.
//

import Foundation

// MARK: - HTTPRequest

/// Protocol that defines the values that a request must have for use with the `HTTPService`.
public protocol HTTPRequest {
    // Data type of the HTTP response body.
    associatedtype ResponseBody: Decodable
    
    /// Data type of the HTTP request body.
    associatedtype RequestBody: Encodable = AnyEncodable
    
    /// The URL that the request will be sent to.
    var url: URL { get }
    
    /// The specified HTTP method for the request.
    var method: HTTPMethod { get }
    
    /// The specified HTTP headers for the request.
    var headers: [String: String] { get }
    
    /// The specified paramters for the request.
    var parameters: [String: String] { get }
    
    /// The specified HTTP body for the request.
    var body: RequestBody? { get }
    
    /// The specified caching policy for the request.
    var cachePolicy: NSURLRequest.CachePolicy? { get }
    
    /// The specified timeout limit for the request in seconds.
    var timeoutInterval: TimeInterval? { get }
    
    /// Indicates whether or not the service should allow an HTTP body for all methods. Typically,
    /// the HTTP body is only used for the `POST`, `PUT`, and `PATCH` methods. Therefore, by default,
    /// this value is set to `false` such that the `body` field will only be used with `POST`, `PUT`,
    /// and `PATCH`. This behavior can be overriden to allow the body to be used with **any** method
    /// by returning `true` for this property.
    var supportsBodyForAllMethods: Bool { get }
}

// MARK: - Default implementations for properties on `HTTPService`

public extension HTTPRequest {
    var method: HTTPMethod { .GET }
    var headers: [String: String] { [:] }
    var parameters: [String: String] { [:] }
    var body: RequestBody? { nil }
    var cachePolicy: NSURLRequest.CachePolicy? { nil }
    var timeoutInterval: TimeInterval? { nil }
    var supportsBodyForAllMethods: Bool { false }
}
