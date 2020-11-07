//
//  AnyDecodable.swift
//  Core
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - AnyEncodable

/// Wrapper that erases the underly type of an `Encodable` object.
public struct AnyEncodable: Encodable {
    /// Calls the actual encoder.
    private let _encode: (Encoder) throws -> Void

    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
    
    public init<T: Encodable>(_ wrapped: T) {
        _encode = wrapped.encode
    }
}
