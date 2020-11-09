//
//  Inject.swift
//  Fundamentals
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - @Inject

/// Property wrapper that allows a dependency to be resolved via a specified instance
/// of `ServiceContainer`. If no container is specified, the `shared` instance will be
/// used for resolving dependencies.
@propertyWrapper
struct Inject<T> {
    private var value: T

    var wrappedValue: T {
        get { value }
    }
    
    init(container: ServiceContainerProtocol = ServiceContainer.shared) {
        self.value = container.get(T.self)
    }
}
