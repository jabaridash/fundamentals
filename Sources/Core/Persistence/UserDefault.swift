//
//  UserDefault.swift
//  Core
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - UserDefault

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: Key
    let defaultValue: T
    let userDefaults: UserDefaults

    init(_ key: Key, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key.name) else {
                return defaultValue
            }
            
            return (try? PropertyListDecoder().decode(T.self, from: data)) ?? defaultValue
        }
        
        set {
            let value = try? PropertyListEncoder().encode(newValue)
            userDefaults.set(value, forKey: key.name)
        }
    }
    
    struct Key {
        let name: String
    }
}

// MARK: - DefaultableType conformance

extension UserDefault where T: DefaultableType {
    init(_ key: Key) {
        self.init(key, defaultValue: T.defaultValue)
    }
}
