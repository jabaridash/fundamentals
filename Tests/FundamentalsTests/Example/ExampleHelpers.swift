//
//  ExampleHelpers.swift
//  FundamentalsTests
//
//  Created by jabari on 11/9/20.
//

import Foundation
import Fundamentals

// MARK: - UserRequest

struct UserRequest: HTTPRequest {
    typealias ResponseBody = User
 
    var url: URL { URL(string: "http://localhost:3000/users")! }
    
    let headers: [String : String] = [
        "Authorization": "Bearer id-token",
        "X-API-TOKEN": "api-token"
    ]
    
    let parameters: [String : String] = [
        "language": "en",
    ]
    
    let method: HTTPMethod = .GET
    
    let body: AnyEncodable? = nil
    
    let id: String
}

struct TransactionsRequest: HTTPRequest {
    typealias ResponseBody = [Transaction]
    
    let url = URL(string: "http://localhost:3000/transactions")!
}

// MARK: - User

public struct User: Codable, Defaultable, Equatable {
    public static let defaultValue: User = .init()
    
    @Defaulted public var id: String
    @Defaulted public var name: String
    public var transactions: [Transaction]?
}

public struct Transaction: Codable, Equatable {
    let id: Int
    let description: String
}

// MARK: - UserDefaultKey.user

extension UserDefaultKey {
    static let user: UserDefaultKey = .init(name: "user")
}

// MARK: - ServiceContainer.example

public extension ServiceContainer {
    static let example = ServiceContainer()
}

// MARK: - UserDefaults.example

public extension UserDefaults {
    static let example = UserDefaults(suiteName: "example")!
}
