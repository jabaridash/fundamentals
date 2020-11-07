//
//  MockHTTPRequest.swift
//  CoreTests
//
//  Created by jabari on 11/6/20.
//

import Foundation

@testable import Core

struct MockHTTPRequest: HTTPRequest {
    typealias ResponseBody = [Int]
    
    var url: URL
    var method: HTTPMethod
    var headers: [String : String]
    var parameters: [String : String]
    var body: AnyEncodable?
    var cachePolicy: NSURLRequest.CachePolicy?
    var timeoutInterval: TimeInterval?
    var supportsBodyForAllMethods: Bool
}

extension HTTPRequest {
    static func mock(
        url: URL = URL(string: "https://google.com")!,
        method: HTTPMethod = .GET,
        headers: [String: String] = [:],
        parameters: [String: String] = [:],
        body: AnyEncodable? = nil,
        cachePolicy: NSURLRequest.CachePolicy? = nil,
        timeoutInterval: TimeInterval? = nil,
        supportsBodyForAllMethods: Bool = false
    ) -> MockHTTPRequest {
        
        return MockHTTPRequest(
            url: url,
            method: method,
            headers: headers,
            parameters: parameters,
            body: body,
            cachePolicy: cachePolicy,
            timeoutInterval: timeoutInterval,
            supportsBodyForAllMethods: supportsBodyForAllMethods
        )
    }
}
