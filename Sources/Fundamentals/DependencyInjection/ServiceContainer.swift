//
//  ServiceContainer.swift
//  Fundamentals
//
//  Created by jabari on 11/3/20.
//

import Foundation

// MARK: - ServiceContainer

/// Default implementation of the `ServiceContainer`.
public final class ServiceContainer {
    /// Shared singleton instance of `ServiceContainer`.
    public static let shared = ServiceContainer()
    
    /// Map that stores the instances of the services
    private var services: [AnyHashable : Any] = [:]
    
    /// Initializes a `ServiceContainer`.
    public init() {}
}

// MARK: - Conformance to ServiceContainerProtocol

extension ServiceContainer: ServiceContainerProtocol {
    public var isEmpty: Bool { services.isEmpty }
    
    public func register<T>(_ service: T, as type: T.Type) {
        services[id(for: type)] = service
    }
    
    public func get<T>(_ type: T.Type) -> T {
        if let service = services[id(for: type)] as? T {
            return service
        } else {
            fatalError("No service registered for type: \(String(describing: T.Type.self))")
        }
    }
    
    public func remove<T>(_ type: T.Type) {
        services[id(for: type)] = nil
    }
    
    public func contains<T>(_ type: T.Type) -> Bool {
        services[id(for: type)] != nil
    }
    
    public func clear() {
        services = [:]
    }
}

// MARK: - Private extensions for ServiceContainer

private extension ServiceContainer {
    /// Provides a `HashableType` key for the type.
    ///
    /// - Parameter type: Generic type of the service.
    /// - Returns: Lookup key for the service type.
    func id<T>(for type: T.Type) -> AnyHashable { ObjectIdentifier(type) }
}
