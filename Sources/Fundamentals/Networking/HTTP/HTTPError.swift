//
//  HTTPError.swift
//  FundamentalsTests
//
//  Created by jabari on 11/6/20.
//

import Foundation

// MARK: - HTTPError

/// Types of failures that can occur when executing an `HTTPRequest`.
public enum HTTPError: LocalizedError {
    /// Encoding the HTTP request body failed.
    case encodingFailure(_ error: Error)
    
    /// Decoding the HTTP response body failed.
    case decodingFailure(_ error: Error)
    
    /// No data was returned in the `URLResponse`.
    case noDataReturned
    
    /// An error occured when executing the `URLSessionDataTask`.
    case urlSession(_ error: Error)
    
    /// No values were found for `Data`, `URLResponse`, or `Error`.
    case invalidResponse
    
    /// An invalid `URL` object was found when creating `URLComponents`.
    case invalidURLComponentsURL
    
    /// HTTP status code was 1XX.
    case informational(_ response: HTTPURLResponse, data: Data)
    
    /// HTTP status code was 3XX.
    case redirection(_ response: HTTPURLResponse, data: Data)
    
    /// HTTP status code was 4XX.
    case clientError(_ response: HTTPURLResponse, data: Data)
    
    /// HTTP status code was 5XX.
    case serverError(_ response: HTTPURLResponse, data: Data)
    
    /// HTTP status code was unrecognized.
    case unrecognizedStatusCode(_ response: HTTPURLResponse, data: Data)
    
    /// Describes the type of error that occured.
    public var message: String {
        switch self {
        case .encodingFailure(let error):
            return "Encoding failure: \(error)"
        case .decodingFailure(let error):
            return "Decoding failure: \(error)"
        case .noDataReturned:
            return "No data was return in HTTP response body"
        case .urlSession(let error):
            return "URLSession Error: \(error)"
        case .invalidResponse:
            return "Could not cast URLResponse to HTTPURLResponse"
        case .invalidURLComponentsURL:
            return "Could not properly build URLRequest from Request"
        case .informational(let response, _):
            return statusCodeErrorMessage(message: "Informational", statusCode: response.statusCode)
        case .redirection(let response, _):
            return statusCodeErrorMessage(message: "Redirect", statusCode: response.statusCode)
        case .clientError(let response, _):
            return statusCodeErrorMessage(message: "Client Error", statusCode: response.statusCode)
        case .serverError(let response, _):
            return statusCodeErrorMessage(message: "Server Error", statusCode: response.statusCode)
        case .unrecognizedStatusCode(let response, _):
            return statusCodeErrorMessage(message: "Unrecognized", statusCode: response.statusCode)
        }
    }
    
    /// Creates an error message based on a prefix and an HTTP status code.
    /// - Parameters:
    ///   - message: Specified prefix.
    ///   - statusCode: Specified HTTP status code.
    /// - Returns: Composed message containing the specified prefix and HTTP status code.
    private func statusCodeErrorMessage(message: String, statusCode: Int) -> String {
        return "Non 2XX status code - \(message): \(statusCode)"
    }
}

// MARK: - Conform HTTPError to Equatable

extension HTTPError: Equatable {
    public static func == (lhs: HTTPError, rhs: HTTPError) -> Bool {
        return lhs.message == rhs.message
    }
}
