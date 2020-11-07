//
//  Defaults.swift
//  Core
//
//  Created by jabari on 11/6/20.
//

import Foundation

// MARK: - DefaultableType

public protocol DefaultableType {
    static var defaultValue: Self { get }
}

// MARK: - Defaulted

@propertyWrapper
public struct Defaulted<T: DefaultableType> {
    public var wrappedValue: T
    
    public init() {
        self.wrappedValue = T.defaultValue
    }
    
    fileprivate init(value: T) {
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

// MARK: - Equatable conformance

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

extension UserDefault where T: DefaultableType {
    init(_ key: UserDefaultKey) {
        self.init(key, defaultValue: T.defaultValue)
    }
}

extension KeyedDecodingContainer {
    public func decode<T: Decodable>(_ type: Defaulted<T>.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Defaulted<T> {
        return try decodeIfPresent(type, forKey: key) ?? Defaulted(value: T.defaultValue)
    }
}
