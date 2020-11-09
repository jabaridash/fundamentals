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
    ///   - dispatchQueue: Specified `DispatchQueue` that completion handler will run on.
    func task<R: HTTPRequest>(for request: R, on dispatchQueue: DispatchQueue?) -> Task<R.ResponseBody, HTTPError>
}

// MARK: - Helper functions that provide default values

extension HTTPServiceProtocol {
    /// Returns a `Task` that will execute `HTTPRequest` and decode the response. This function
    /// does not specify which `DispatchQueue` to dispatch back to.
    /// - Parameter request: Specified request to execute.
    func task<R: HTTPRequest>(for request: R) -> Task<R.ResponseBody, HTTPError> {
        return self.task(for: request, on: nil)
    }
}
