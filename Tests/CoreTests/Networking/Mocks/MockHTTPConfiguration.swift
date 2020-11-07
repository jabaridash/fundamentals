//
//  MockHTTPConfiguration.swift
//  CoreTests
//
//  Created by jabari on 11/6/20.
//

import Foundation

@testable import Core

struct MockHTTPConfiguration: HTTPConfiguration {
    var cachePolicy: NSURLRequest.CachePolicy?
    var defaultHeaders: [String: String]
    var defaultParameters: [String: String]
    var jsonDecoder: JSONDecoder
    var jsonEncoder: JSONEncoder
    var shouldHandleStatusCode: Bool
    var timeoutInterval: TimeInterval?
}

extension HTTPConfiguration {
    static func mock(
        cachePolicy: NSURLRequest.CachePolicy? = .reloadIgnoringLocalAndRemoteCacheData,
        defaultHeaders: [String: String] = [:],
        defaultParameters: [String: String] = [:],
        jsonDecoder: JSONDecoder = JSONDecoder(),
        jsonEncoder: JSONEncoder = JSONEncoder(),
        shouldHandleStatusCode: Bool = false,
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
