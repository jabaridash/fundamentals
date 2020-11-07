//
//  MockURLSessionDataTask.swift
//  CoreTests
//
//  Created by jabari on 11/7/20.
//

import Foundation

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
