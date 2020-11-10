//
//  Task.swift
//  Fundamentals
//
//  Created by jabari on 11/3/20.
//

import Foundation

// MARK: - Task

/// Default implementation of the `TaskProtocol`. A `Task` contains the logic for encapsulating async work.
public struct Task<T, E: Error> {
    private let work: ((_ completion: @escaping (Result<T, E>) -> Void) -> Void)

    /// Initializes a task with a specified body of work to run at a later point in execution.
    /// - Parameter work: Specified body of work that will run upon invocation of the `perform()` method.
    public init(work: @escaping (_ completion: @escaping (Result<T, E>) -> Void) -> Void) {
        self.work = work
    }
}

// MARK: - TaskProtocol conformance

extension Task: TaskProtocol {
    public func perform(queue: DispatchQueue?, completion: @escaping (Result<T, E>) -> Void) {
        work { result in
            if let queue = queue {
                queue.async { completion(result) }
            } else {
                completion(result)
            }
        }
    }

    public func map<U>(_ transform: @escaping (T) throws -> U) -> Task<U, Error> {
        return .init { completion in
            work { result in
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
    
    public func flatMap<U>(_ transform: @escaping (T) -> Task<U, E>) -> Task<U, E> {
        return .init { completion in
            perform(queue: nil) { result in
                switch result {
                case .success(let value):
                    transform(value).perform(completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    public func mapError<Y: Error>(_ transform: @escaping (E) -> Y) -> Task<T, Y> {
        return .init { completion in
            work { result in
                switch result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(transform(error)))
                }
            }
        }
    }
    
    public func recover(_ recovery: @escaping (E) -> T) -> Task<T, E> {
        return .init { completion in
            perform(queue: nil) { result in
                switch result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.success(recovery(error)))
                }
            }
        }
    }
}

// MARK: - Static functions

public extension Task {
    static func just<R, M: Error>(_ value: R) -> Task<R, M> {
        .init { $0(.success(value)) }
    }
    
    static func error<R, M: Error>(_ error: M) -> Task<R, M> {
        .init { $0(.failure(error)) }
    }
    
    static func all<T1, T2>(_ task1: Task<T1, Error>, _ task2: Task<T2, Error>) -> Task<(T1, T2), Error> {
        return Task<Any, Error>.merge([
            task1.map { $0 as Any },
            task2.map { $0 as Any },
        ])
        .map {
            return (
                $0[0] as! T1,
                $0[1] as! T2
            )
        }
    }
    
    static func all<T1, T2, T3>(_ task1: Task<T1, Error>, _ task2: Task<T2, Error>, _ task3: Task<T3, Error>) -> Task<(T1, T2, T3), Error> {
        return Task<Any, Error>.merge([
            task1.map { $0 as Any },
            task2.map { $0 as Any },
            task3.map { $0 as Any },
        ])
        .map {
            return (
                $0[0] as! T1,
                $0[1] as! T2,
                $0[2] as! T3
            )
        }
    }
    
    static func all<T1, T2, T3, T4>(_ task1: Task<T1, Error>, _ task2: Task<T2, Error>, _ task3: Task<T3, Error>,  _ task4: Task<T4, Error>) -> Task<(T1, T2, T3, T4), Error> {
        return Task<Any, Error>.merge([
            task1.map { $0 as Any },
            task2.map { $0 as Any },
            task3.map { $0 as Any },
            task4.map { $0 as Any },
        ])
        .map {
            return (
                $0[0] as! T1,
                $0[1] as! T2,
                $0[2] as! T3,
                $0[3] as! T4
            )
        }
    }
    
    static func merge(_ tasks: [Task<T, Error>], on queue: DispatchQueue = .global()) -> Task<[T], Error> {
        return .init { completion in
            let group = DispatchGroup()
            
            // Synchronizes reads and write the non-thread-safe variables (values, taskError)
            let lock = NSRecursiveLock()
            
            var values: [T?] = .init(repeating: nil, count: tasks.count)
            var taskError: Error?

            for (index, task) in tasks.enumerated() {
                group.enter()
                
                task.perform(queue: nil) { result in
                    defer { group.leave() }
                    
                    guard taskError == nil else { return }
                    
                    lock.sync {
                        do {
                            values[index] = try result.get()
                        } catch {
                            taskError = error
                        }
                    }
                }
            }
            
            group.notify(queue: queue) {
                if let taskError = taskError {
                    completion(.failure(taskError))
                } else {
                    completion(.success(values.compactMap { $0 }))
                }
            }
        }
    }
}

// MARK: - Functions

public func async<T>(on queue: DispatchQueue = .global(qos: .default), _ work: @escaping () throws -> T) -> Task<T, Error> {
    return .init { completion in
        queue.async {
            do {
                completion(.success(try work()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

public func async(on queue: DispatchQueue = .global(qos: .default), _ work: @escaping () throws -> Void) {
    async(on: queue, work).perform { _ in }
}

@discardableResult public func await<T, E: Error>(_ task: Task<T, E>) throws -> T {
    let semaphore = DispatchSemaphore(value: 0)
    
    var result: Result<T, E>!
    
    task.perform(queue: nil) {
        defer { semaphore.signal() }
        result = $0
    }
    
    semaphore.wait()
    
    return try result.get()
}
