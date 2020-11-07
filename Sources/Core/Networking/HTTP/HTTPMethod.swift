//
//  HTTPMethod.swift
//  Core
//
//  Created by jabari on 11/6/20.
//

// MARK: - HTTPMethod

/// Represents the HTTP methods that are supported by the `HTTPService`.
public enum HTTPMethod: String {
    /// The `GET` method requests a representation of the specified resource. Requests using `GET`
    /// should only retrieve data.
    case GET
    
    /// The `HEAD` method asks for a response identical to that of a `GET` request, but without
    /// the response body.
    case HEAD
    
    /// The `POST` method is used to submit an entity to the specified resource, often causing a change in
    /// state or side effects on the server.
    case POST
    
    /// The `PUT` method replaces all current representations of the target resource with the request payload.
    case PUT
    
    /// The `DELETE` method deletes the specified resource.
    case DELETE
    
    /// The `CONNECT` method establishes a tunnel to the server identified by the target resource.
    case CONNECT
    
    /// The `OPTIONS` method is used to describe the communication options for the target resource.
    case OPTIONS
    
    /// The `TRACE` method performs a message loop-back test along the path to the target resource.
    case TRACE
    
    /// The `PATCH` method is used to apply partial modifications to a resource.
    case PATCH
    
    /// HTTP request bodies are theoretically allowed for all methods except `TRACE`, however they are not
    /// commonly used except in `PUT`, `POST` and `PATCH`. Because of this, they may not be supported properly
    /// by some client frameworks, and you should not allow request bodies for `GET`, `DELETE`, `TRACE`, `OPTIONS`
    /// and `HEAD` methods.
    var supportsBody: Bool {
        switch self {
        case .GET, .DELETE, .TRACE, .OPTIONS, .HEAD, .CONNECT:
            return false
        case .POST, .PUT, .PATCH:
            return true
        }
    }
}
