//
//  Defaults.swift
//  Fundamentals
//
//  Created by jabari on 11/6/20.
//

import Foundation

// MARK: - DefaultableType

/// A type that can be used with the `Defaulted` property wrapper.
public protocol DefaultableType {
    
    /// Default value that will be used if the wrapped value is not initially supplied.
    static var defaultValue: Self { get }
}

// MARK: - Defaulted

/// Allows values to be supplied a default value. This is useful when an object is `Decodable`.
@propertyWrapper
public struct Defaulted<T: DefaultableType> {
    /// The underlying value.
    public var wrappedValue: T
    
    /// Initialzes the underlying value to its `defaultValue`.
    public init() {
        self.wrappedValue = T.defaultValue
    }
    
    /// Initialzes the underly value with a specified initiak value.
    /// - Parameter value: The specified initial value.
    public init(value: T) {
        self.wrappedValue = value
    }
}

// MARK: - Decodable onformance

extension Defaulted: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        wrappedValue = try T.init(from: decoder)
    }
}

// MARK: - Encodable conformance

extension Defaulted: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

// MARK: - Equatable & Hashable conformance

extension Defaulted: Equatable where T: Equatable {}

extension Defaulted: Hashable where T: Hashable {}

// MARK: - DefaultableType conformance for common types

extension Dictionary: DefaultableType {
    public static var defaultValue: [Key: Value] { [:] }
}

extension Array: DefaultableType {
    public static var defaultValue: [Element] { [] }
}

extension Bool: DefaultableType {
    public static var defaultValue: Bool { false }
}

extension Double: DefaultableType {
    public static var defaultValue: Double { 0 }
}

extension Float: DefaultableType {
    public static var defaultValue: Float { 0 }
}


extension Int: DefaultableType {
    public static var defaultValue: Int { 0 }
}

extension String: DefaultableType {
    public static var defaultValue: String { "" }
}

public extension KeyedDecodingContainer {
    func decode<T: Decodable>(_ type: Defaulted<T>.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Defaulted<T> {
        return try decodeIfPresent(type, forKey: key) ?? Defaulted(value: T.defaultValue)
    }
}
