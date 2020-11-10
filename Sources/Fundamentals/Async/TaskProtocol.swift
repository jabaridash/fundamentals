//
//  TaskProtocol.swift
//  Fundamentals
//
//  Created by jabari on 11/7/20.
//

import Foundation

// MARK: - TaskProtocol

// TODO - Implement retry(), cancel(), timeout()

/// Protocol that describes the behavior of a task.
public protocol TaskProtocol {
    /// Type of value contained in the result's `.success` case if the task succeeds.
    associatedtype T
    
    /// Type of error contained in the result's `.failure` case if the task fails.
    associatedtype E: Error

    /// Executes the task on a specified `DispatchQueue`.
    /// - Parameters:
    ///   - queue: Specified `DispatchQueue`.
    ///   - completion: Function that contains the work to be performed.
    func perform(queue: DispatchQueue?, completion: @escaping (Result<T, E>) -> Void)
    
    /// Map the result of a `Task` into another type.
    ///
    /// - Parameter transform: Function that transforms the Tasks result type into a new type.
    /// - Returns: A Task with the result as the new type.
    func map<U>(_ transform: @escaping (T) -> U) -> Task<U, E>
    
    /// Enables chaining of dependent asynchronous tasks.
    /// - Parameter transform: Asynchronous body of work that depends on this task's completion.
    func flatMap<U>(_ transform: @escaping (T) -> Task<U, E>) -> Task<U, E>
    
    /// Maps this `Task` with one error type into a `Task` with another error type.
    /// - Parameter transform: A function that transforms this `Task`'s error type into another error type.
    func mapError<Y: Error>(_ transform: @escaping (E) -> Y) -> Task<T, Y>
    
    /// Allows a failed `Task` to recover based on a supplied recovery closure.
    /// - Parameter recovery: Specified closure that allows the `Task` to recover from failure.
    func recover(_ recovery: @escaping (E) -> T) -> Task<T, E>
    
    /// Returns a `Task` that always succeeds with a specified value.
    /// - Parameter value: The specified value.
    /// - Returns: A `Task` that succeeds with the specified value.
    static func just<R, M: Error>(_ value: R) -> Task<R, M>
    
    /// Returns `Task` that always fails with a specified error.
    /// - Parameter error: The specified error.
    /// - Returns: A `Task` that fails with the specified error.
    static func error<R, M: Error>(_ error: M) -> Task<R, M>
    
    /// Merges the results of two `Task`s into a single `Task`. Each `Task` will be executed concurrently.
    /// if one task fails, the entire task will fail and resolve the first encountered error.
    /// - Parameters:
    ///   - task1: The first task.
    ///   - task2: The second task.
    static func all<T1, T2>(_ task1: Task<T1, Error>, _ task2: Task<T2, Error>) -> Task<(T1, T2), Error>
    
    /// Merges the results of three `Task`s into a single `Task`. Each `Task` will be executed concurrently.
    /// if one task fails, the entire task will fail and resolve the first encountered error.
    /// - Parameters:
    ///   - task1: The first task.
    ///   - task2: The second task.
    ///   - task3: The third task.
    static func all<T1, T2, T3>(_ task1: Task<T1, Error>, _ task2: Task<T2, Error>, _ task3: Task<T3, Error>) -> Task<(T1, T2, T3), Error>
    
    /// Merges the results of four `Task`s into a single `Task`. Each `Task` will be executed concurrently.
    /// if one task fails, the entire task will fail and resolve the first encountered error.
    /// - Parameters:
    ///   - task1: The first task.
    ///   - task2: The second task.
    ///   - task3: The third task.
    ///   - task4: The fourth task.
    static func all<T1, T2, T3, T4>(_ task1: Task<T1, Error>, _ task2: Task<T2, Error>, _ task3: Task<T3, Error>,  _ task4: Task<T4, Error>) -> Task<(T1, T2, T3, T4), Error>
    
    /// Merges the results of an array of tasks into a single task. Each task will be executed concurrently,
    /// assuming that the supplied workload is an asynchronous workload. If one of the tasks fails, the resolved
    /// result type will be `.failure` with a generic `Error`. The error is the first error that was encounted, and
    /// must be casted in order to perform logic on it. After the first error is encountered, the remaining results
    /// will be omitted.
    /// - Parameters:
    ///   - tasks: Specified array of tasks to execute.
    ///   - queue: DispatchQueue on which the final completion handler will be executed. By default, an instance of `DispatchQueue.global()` will be used.
    static func merge(_ tasks: [Task<T, Error>], on queue: DispatchQueue) -> Task<[T], Error>
}

// MARK: - Helper methods

public extension TaskProtocol {
    /// Executes the completion on `DispatchQueue.main`.
    /// - Parameter completion: Function that contains the work to be performed.
    func perform(completion: @escaping (Result<T, E>) -> Void) {
        self.perform(queue: .main, completion: completion)
    }
}
