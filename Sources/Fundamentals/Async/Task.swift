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
    public func perform(on queue: DispatchQueue, completion: @escaping (Result<T, E>) -> Void) -> Task<T, E> {
        
        // TODO - Figure out how to make cancellable
        
//        queue.async(execute: .init {
//            work(completion)
//        })
        
        queue.async {
            work(completion)
        }
        
        return self
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
