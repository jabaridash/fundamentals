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
            .mapError { $0 as! HTTPError }
            .flatMap(getDetails)
            .perform { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .failure(let error):
                    self.logger.error("Request failed: \(error)")
                case .success(let user):
                    self.logger.info("Request succeeded: \(user)")
                    self.user = user
                    self.usersLoaded += 1
                }
                
                completion(result)
            }
    }
}

// MARK: - Helper methods

private extension ExampleService {
    func getId() -> Task<Int, HTTPError> {
        logger.debug("Getting user id")
        
        return .init { completion in
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                
                let id: Int = 1
                
                self.logger.debug("Successfully fetched id: \(id)")
                
                completion(.success(id))
            }
        }
    }
    
    func getDetails(_ id: String) -> Task<User, HTTPError> {
        let task1 = httpService.task(for: UserRequest(id: id))
        let task2 = httpService.task(for: TransactionsRequest())
         
        return .init { completion in
            async {
                do {
                    var user = try await(task1)

                    user.transactions = try await(task2)

                    completion(.success(user))
                } catch {
                    completion(.failure(.invalidResponse))
                }
            }
        }
    }
}
