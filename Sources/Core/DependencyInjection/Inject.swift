//
//  Inject.swift
//  Core
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - @Inject

@propertyWrapper
struct Inject<T> {
    private var value: T

    var wrappedValue: T {
        get { value }
    }
    
    init(container: ServiceContainer = .shared) {
        self.value = container.get(T.self)
    }
}
