//
//  UserDefault.swift
//  Fundamentals
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - UserDefaultKey

/// Used with `UserDefault` for reading and writing to `UserDefaults` without directly exposing "stringly" typed keys.
public struct UserDefaultKey {
    
    /// Name of value that will be used for lookup and writing values in `UserDefaults`.
    public let name: String
}

// MARK: - UserDefault

/// Property wrapper that allows a property on an object to be backed by `UserDefaults` or some
/// implementation of `UserDefaultsProtocol`. This object accomplishes two tasks. First, it abstracts
/// away the calls to `data()` and `set()`. Secondly, it enforces the user to use a `Key` to lookup and
/// update values in `UserDefaults`. This has the advantage of directly exposing read and write operations
/// via strings because typos can no longer cause a read or write to the wrong value. The compiler will
/// make sure that a `Key` exists. A `Key` can be created by simply adding an extension to `UserDefault.Key`
/// with a static property of type `Key`.
///
///An example follows:
/// ```
///extension UserDefaultKey {
///    static let hasSeenOnboarding = UserDefaultKey(name: "has-seen-onboarding")
///    static let hasSeenNotification = UserDefaultKey(name: "has-seen-notification")
///    static let favoriteNumbers = UserDefaultKey(name: "favorite-numbers")
///}
///
///final class SomeClass {
///    @UserDefault(.hasSeenOnboarding)
///    var hasSeenOnboarding: Bool
///
///    @UserDefault(.hasSeenNotification, defaultValue: false)
///    var hasSeenNotification: Bool
///
///    @UserDefault(.favoriteNumbers, defaultValue: [1], userDefaults: UserDefaults.standard)
///    var favoriteNumbers: [Int]
///}
///```
///
@propertyWrapper
public struct UserDefault<T: Codable> {
    private let key: UserDefaultKey
    private let userDefaults: UserDefaults
    
    /// The default value to be used if no value is found in `UserDefaults`.
    public let defaultValue: T

    /// Initializes a value without a specified `defaultValue`. The default value that
    /// will be used will be taken from the underlying type's `defaultValue`.
    /// - Parameters:
    ///   - key: Key that correspondes to the underlying user default value.
    ///   - defaultValue: Initial value that will be used if no value is present.
    ///   - userDefaults: Instance of `UserDefaults` where wrapped value will be stored.
    public init(_ key: UserDefaultKey, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    /// Reads and writes the value to `UserDefaults`.
    public var wrappedValue: T {
        get {
            guard let data = userDefaults.object(forKey: key.name) as? Data else {
                return defaultValue
            }
            
            return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
        }
        
        set {
            let value = try? JSONEncoder().encode(newValue)
            userDefaults.set(value, forKey: key.name)
        }
    }
}

// MARK: - Additional initializers for convenience

public extension UserDefault where T: Defaultable {
    /// Initializes a value without a specified `defaultValue`. The default value that
    /// will be used will be taken from the underlying type's `defaultValue`.
    /// - Parameter key: Key that correspondes to the underlying user default value.
    init(_ key: UserDefaultKey) {
        self.init(key, defaultValue: T.defaultValue)
    }
    
    /// Initializes a value without a specified `defaultValue`. The default value that
    /// will be used will be taken from the underlying type's `defaultValue`.
    /// - Parameters:
    ///   - key: Key that correspondes to the underlying user default value.
    ///   - userDefaults: Instance of `UserDefaults` where wrapped value will be stored.
    init(_ key: UserDefaultKey, userDefaults: UserDefaults = .standard) {
        self.init(key, defaultValue: T.defaultValue, userDefaults: userDefaults)
    }
}
