//
//  MockHTTPConfiguration.swift
//  CoreTests
//
//  Created by jabari on 11/6/20.
//

import Foundation

@testable import Core

public struct MockHTTPConfiguration: HTTPConfiguration {
    public var cachePolicy: NSURLRequest.CachePolicy?
    public var defaultHeaders: [String: String]
    public var defaultParameters: [String: String]
    public var jsonDecoder: JSONDecoder
    public var jsonEncoder: JSONEncoder
    public var shouldHandleStatusCode: Bool
    public var timeoutInterval: TimeInterval?
}

public extension HTTPConfiguration {
    static func mock(
        cachePolicy: NSURLRequest.CachePolicy? = .reloadIgnoringLocalAndRemoteCacheData,
        defaultHeaders: [String: String] = [:],
        defaultParameters: [String: String] = [:],
        jsonDecoder: JSONDecoder = JSONDecoder(),
        jsonEncoder: JSONEncoder = JSONEncoder(),
        shouldHandleStatusCode: Bool = true,
        timeoutInterval: TimeInterval? = nil
    ) -> MockHTTPConfiguration {
        return MockHTTPConfiguration(
            cachePolicy: cachePolicy,
            defaultHeaders: defaultHeaders,
            defaultParameters: defaultParameters,
            jsonDecoder: jsonDecoder,
            jsonEncoder: jsonEncoder,
            shouldHandleStatusCode: shouldHandleStatusCode,
            timeoutInterval: timeoutInterval
        )
    }
}
