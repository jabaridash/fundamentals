//
//  MockEncoder.swift
//  CoreTests
//
//  Created by jabari on 11/6/20.
//

import Foundation

final class MockJSONEncoder: JSONEncoder {
    var encodeCallCount = 0
    var result: Result<Data, Error> = .success(Data([1, 2, 3]))
    
    override func encode<T>(_ value: T) throws -> Data {
        encodeCallCount += 1
        
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    enum EncodeError: Error, Equatable {
        case mockError
    }
}
