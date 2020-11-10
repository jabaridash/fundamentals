//
//  ExampleService.swift
//  FundamentalsTests
//
//  Created by jabari on 11/9/20.
//

import Foundation
import Fundamentals

// MARK: - ExampleServiceProtocol

protocol ExampleServiceProtocol {
    func load(_ completion: @escaping (Result<User, HTTPError>) -> Void)
}

// MARK: - ExampleService

final class ExampleService {
    @Inject(from: .example)
    private var logger: LoggerProtocol
    
    @Inject
    private var httpService: HTTPService
    
    @Defaulted
    var usersLoaded: Int
    
    @UserDefault(.user)
    var user: User
}

// MARK: - Conform ExampleService to ExampleServiceProtocol

extension ExampleService: ExampleServiceProtocol {
    func load(_ completion: @escaping (Result<User, HTTPError>) -> Void) {
        getId()
            .map(String.init)
            .flatMap(getDetails)
            .recover { _ in .placeholder() }
            .perform { [weak self] result in
                self?.handle(result)
                completion(result)
            }
    }
}

// MARK: - Helper methods

private extension ExampleService {
    func handle(_ result: Result<User, HTTPError>) {
        switch result {
        case .failure(let error):
            logger.error("Request failed: \(error)")
        case .success(let user):
            logger.info("Request succeeded: \(user)")
            self.user = user
            usersLoaded += 1
        }
    }
    
    func getId() -> Task<Int, HTTPError> {
        logger.debug("Getting user id")
        
        return .init { completion in
            DispatchQueue.global(qos: .background).async {
                completion(.success(1))
            }
        }
    }
    
    func getDetails(_ id: String) -> Task<User, HTTPError> {
        let t1 = httpService.task(for: UserRequest(id: id))
        let t2 = httpService.task(for: TransactionsRequest())
        
        return async { () -> User in
            var user = try await(t1)
            
            user.transactions = try await(t2)
            
            return user
        }.mapError { _ in .invalidResponse }
    }
}
