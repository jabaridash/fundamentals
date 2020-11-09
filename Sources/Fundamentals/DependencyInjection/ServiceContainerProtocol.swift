//
//  ServiceContainerProtocol.swift
//  Fundamentals
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - ServiceContainerProtocol

/// Defines the contract of a service container.
public protocol ServiceContainerProtocol {
    /// Indicates whether or not any services are in the container.
    var isEmpty: Bool { get }
    
    /// Registers a service with the service container
    /// with a specified type.
    ///
    /// - Parameters:
    ///   - service: Instance of service to register.
    ///   - type: Type to register the service as.
    func register<T>(_ service: T, as type: T.Type)
    
    /// Retrieves a service from the container. If the container
    /// cannot resolve the service, the app will hard crash.
    ///
    /// - Parameter type: Specified type of service that should be retrieved.
    /// - Returns: An instance of the specified service type.
    func get<T>(_ type: T.Type) -> T
    
    /// Unregisters the instance of the service by the specified type.
    ///
    /// - Parameter type: Specified type of the service to unregister.
    func remove<T>(_ type: T.Type)
    
    /// Determines if the service container contains an instance
    /// of a specified service by type.
    ///
    /// - Parameter type: Specified service type to check for.
    /// - Returns: `Boolean` value indicating whether or not the service is present.
    func contains<T>(_ type: T.Type) -> Bool
    
    /// Resets the service container to its empty state.
    func clear()
}
