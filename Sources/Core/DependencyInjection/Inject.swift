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

    var wrappedValue: T { get { value } }
    
    init() {
        self.value = ServiceContainer.shared.get(T.self)
    }
}
