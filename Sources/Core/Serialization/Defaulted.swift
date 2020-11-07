//
//  Defaults.swift
//  Core
//
//  Created by jabari on 11/6/20.
//

import Foundation

// MARK: - DefaultableType

protocol DefaultableType {
    static var defaultValue: Self { get }
}

// MARK: - Defaulted

@propertyWrapper
struct Defaulted<T: DefaultableType> {
    var wrappedValue: T
    
    init() {
        self.wrappedValue = T.defaultValue
    }
    
    fileprivate init(value: T) {
        self.wrappedValue = value
    }
}

// MARK: - Decodable onformance

extension Defaulted: Decodable where T: Decodable {
    init(from decoder: Decoder) throws {
        wrappedValue = try T.init(from: decoder)
    }
}

// MARK: - Encodable conformance

extension Defaulted: Encodable where T: Encodable {
    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

// MARK: - Equatable conformance

extension Defaulted: Equatable where T: Equatable {}

extension Defaulted: Hashable where T: Hashable {}

// MARK: - DefaultableType conformance for common types

extension Dictionary: DefaultableType {
    static var defaultValue: [Key: Value] { [:] }
}

extension Array: DefaultableType {
    static var defaultValue: [Element] { [] }
}

extension Bool: DefaultableType {
    static var defaultValue: Bool { false }
}

extension Double: DefaultableType {
    static var defaultValue: Double { 0 }
}

extension Int: DefaultableType {
    static var defaultValue: Int { 0 }
}

extension String: DefaultableType {
    static var defaultValue: String { "" }
}

extension UserDefault where T: DefaultableType {
    init(_ key: UserDefaultKey) {
        self.init(key, defaultValue: T.defaultValue)
    }
}

extension KeyedDecodingContainer {
    func decode<T: Decodable>(_ type: Defaulted<T>.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Defaulted<T> {
        return try decodeIfPresent(type, forKey: key) ?? Defaulted(value: T.defaultValue)
    }
}
