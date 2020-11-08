//
//  MockURLSession.swift
//  CoreTests
//
//  Created by jabari on 11/6/20.
//

import Foundation

@testable import Core

// MARK: - MockURLSession

final class MockURLSession: URLSession {
    var dispatchQueue = DispatchQueue(label: "mock-url-queue")
    
    var data: Data? = try? JSONEncoder().encode([1, 2, 3])
    
    var response: HTTPURLResponse? = HTTPURLResponse()
    
    var error: Error?
    
    var requests: [URLRequest] = []
    
    var dataTaskCallCount = 0
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCallCount += 1
        requests.append(request)
        
        return MockURLSessionDataTask { [weak self] in
            self?.dispatchQueue.async { [weak self] in
                guard let self = self else { return }
                
                completionHandler(self.data, self.response, self.error)
            }
        }
    }

    private override init() {
        let key = DispatchSpecificKey<String>()
        
        dispatchQueue.setSpecific(key: key, value: "mock-url-queue-key")
    }
    
    static func mock() -> MockURLSession {
        return .init()
    }
}

extension HTTPURLResponse {
    convenience init?(url: URL = URL(string: "https://ask.com")!, statusCode: Int = 200) {
        self.init(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }
}
