//
//  MockDecoder.swift
//  FundamentalsTests
//
//  Created by jabari on 11/6/20.
//

import Foundation

final class MockJSONDecoder: JSONDecoder {
    var result: Result<Any, DecodeError> = .failure(.mockError)
    var decodeCallCount = 0
    
    override func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        decodeCallCount += 1
        
        switch result {
        case .failure(let error):
            throw error
        case .success(let value):
            if let value = value as? T {
                return value
            } else {
                throw DecodeError.cannotCastMockResultValue
            }
        }
    }
    
    enum DecodeError: Error {
        case cannotCastMockResultValue
        case mockError
    }
}
