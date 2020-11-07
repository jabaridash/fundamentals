//
//  MockURLSession.swift
//  CoreTests
//
//  Created by jabari on 11/6/20.
//

import Foundation

@testable import Core

// MARK: - MockURLSessionDataTask

final class MockURLSessionDataTask: URLSessionDataTask {
    private let work: () -> Void
        
    override func resume() {
        work()
    }
    
    init(completion: @escaping () -> Void) {
        self.work = completion
    }
}

// MARK: - MockURLSession

final class MockURLSession: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    var requests: [URLRequest] = []
    var dataTaskCallCount = 0
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCallCount += 1
        requests.append(request)
        
        return MockURLSessionDataTask { [weak self] in
            guard let self = self else { return }
            completionHandler(self.data, self.response, self.error)
        }
    }

    private override init() {}
    
    static func mock() -> MockURLSession {
        return .init()
    }
}
