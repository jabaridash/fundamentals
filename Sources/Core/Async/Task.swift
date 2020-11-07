//
//  Task.swift
//  Core
//
//  Created by jabari on 11/3/20.
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
    func perform(on dispatchQuque: DispatchQueue, completion: @escaping (Result<T, E>) -> Void)
    
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

extension TaskProtocol {
    func perform(completion: @escaping (Result<T, E>) -> Void) {
        self.perform(on: .main, completion: completion)
    }
}

// MARK: - Task

/// Default implementation of the `TaskProtocol`. A `Task` contains the logic for encapsulating async work.
public struct Task<T, E: Error> {
    private let work: ((_ completion: @escaping (Result<T, E>) -> Void) -> Void)

    public init(work: @escaping (_ completion: @escaping (Result<T, E>) -> Void) -> Void) {
        self.work = work
    }
}

// MARK: - TaskProtocol conformance

extension Task: TaskProtocol {
    public func perform(on queue: DispatchQueue, completion: @escaping (Result<T, E>) -> Void) {
        queue.async {
            work(completion)
        }
    }

    public func map<U>(transform: @escaping (T) throws -> U) -> Task<U, Error> {
        return .init { completion in
            self.work { result in
                switch result {
                case .success(let value):
                    do {
                        completion(.success(try transform(value)))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func mapError<Y: Error>(transform: @escaping (E) -> Y) -> Task<T, Y> {
        return .init { completion in
            self.work { result in
                switch result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(transform(error)))
                }
            }
        }
    }
    
    public static func just<R, M: Error>(_ value: R) -> Task<R, M> {
        .init { $0(.success(value)) }
    }
    
    public static func error<R, M: Error>(_ error: M) -> Task<R, M> {
        .init { $0(.failure(error)) }
    }
}
