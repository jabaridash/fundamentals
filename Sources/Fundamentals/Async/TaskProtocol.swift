//
//  TaskProtocol.swift
//  Fundamentals
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - TaskProtocol

// TODO - Implement retry(), cancel(), recover(), zip() / merge(), timeout()

/// Protocol that describes the behavior of a task.
public protocol TaskProtocol {
    /// Type of value contained in the result's `.success` case if the task succeeds.
    associatedtype T
    
    /// Type of error contained in the result's `.failure` case if the task fails.
    associatedtype E: Error

    /// Executes the task on a specified `DispatchQueue`.
    /// - Parameters:
    ///   - dispatchQuque: Specified `DispatchQueue`.
    ///   - completion: Function that contains the work to be performed.
    @discardableResult func perform(on dispatchQuque: DispatchQueue, completion: @escaping (Result<T, E>) -> Void) -> Task<T, E>
    
    /// Map the result of a Task into another type.
    ///
    /// - Parameter transform: Function that transforms the Tasks result type into a new type.
    /// - Returns: A Task with the result as the new type.
    func map<U>(transform: @escaping (T) throws -> U) -> Task<U, Error>
    
    /// Maps this `Task` with one error type into a `Task` with another error type.
    /// - Parameter transform: A function that transforms this `Task`'s error type into another error type.
    func mapError<Y: Error>(transform: @escaping (E) -> Y) -> Task<T, Y>
    
    /// Returns a `Task` that always succeeds with a specified value.
    /// - Parameter value: The specified value.
    /// - Returns: A `Task` that succeeds with the specified value.
    static func just<R, M: Error>(_ value: R) -> Task<R, M>
    
    /// Returns `Task` that always fails with a specified error.
    /// - Parameter error: The specified error.
    /// - Returns: A `Task` that fails with the specified error.
    static func error<R, M: Error>(_ error: M) -> Task<R, M>
}

// MARK: - Helper methods

extension TaskProtocol {
    /// Executes the task on the main `DispatchQueue`.
    /// - Parameter completion: Function that contains the work to be performed.
    @discardableResult func perform(completion: @escaping (Result<T, E>) -> Void) -> Task<T, E> {
        return self.perform(on: .main, completion: completion)
    }
}
