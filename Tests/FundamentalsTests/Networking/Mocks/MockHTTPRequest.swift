//
//  MockHTTPRequest.swift
//  FundamentalsTests
//
//  Created by jabari on 11/6/20.
//

import Foundation

@testable import Fundamentals

struct MockHTTPRequest<T: Decodable>: HTTPRequest {
    typealias ResponseBody = T
    
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
    static func mock<T: Decodable>(
        url: URL = URL(string: "https://google.com")!,
        method: HTTPMethod = .GET,
        headers: [String: String] = [:],
        parameters: [String: String] = [:],
        body: AnyEncodable? = nil,
        cachePolicy: NSURLRequest.CachePolicy? = nil,
        timeoutInterval: TimeInterval? = nil,
        supportsBodyForAllMethods: Bool = false
    ) -> MockHTTPRequest<T> {
        
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
