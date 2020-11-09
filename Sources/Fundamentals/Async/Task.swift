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

    public init(work: @escaping (_ completion: @escaping (Result<T, E>) -> Void) -> Void) {
        self.work = work
    }
}

// MARK: - TaskProtocol conformance

extension Task: TaskProtocol {
    public func perform(on queue: DispatchQueue, completion: @escaping (Result<T, E>) -> Void) {
        work { result in
            queue.async {
                completion(result)
            }
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

public func async<T>(_ work: @escaping () throws -> T) -> Task<T, Error> {
    return .init { completion in
        DispatchQueue.global(qos: .default).async {
            do {
                completion(.success(try work()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

public func async(_ work: @escaping () throws -> Void) {
    async(work).perform { _ in }
}

public func await<T>(_ task: Task<T, Error>) throws -> T {
    let semaphore = DispatchSemaphore(value: 0)
    
    var result: Result<T, Error>!
    
    task.perform {
        result = $0
        semaphore.signal()
    }
    
    semaphore.wait()
    
    return try result.get()
}
