//
//  HTTPServiceProtocol.swift
//  Fundamentals
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - HTTPServiceProtocol

/// Defines the behavior of a service capable of making HTTP requests.
public protocol HTTPServiceProtocol {
    /// Returns a `Task` that will execute `HTTPRequest` and decode the response
    /// - Parameters:
    ///   - request: Specified request to execute.
    func task<R: HTTPRequest>(for request: R) -> Task<R.ResponseBody, HTTPError>
}
