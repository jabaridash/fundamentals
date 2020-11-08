//
//  Defaulted.swift
//  CoreTests
//
//  Created by jabari on 11/7/20.
//

import Foundation
import Nimble
import Quick

@testable import Core

final class DefaultedSpec: QuickSpec {
    override func spec() {
        describe("Defaulted") {
            var someContainer: SomeContanier!
            
            beforeEach {
                someContainer = SomeContanier()
            }
            
            it("overrides default wrapped value for DefaultableType via property wrapper") {
                let someOtherContainer = SomeOtherContainer()
                
                expect(someOtherContainer.someDefaultableType.id) == 2
            }
            
            it("allows overriding instance of DefaultableType") {
                var someOtherContainer = SomeOtherContainer()
                
                precondition(someOtherContainer.someDefaultableType.id == 2)
                
                someOtherContainer.someDefaultableType = SomeDefaultableType(id: 3)
                
                expect(someOtherContainer.someDefaultableType.id) == 3
            }
            
            it("encodes and decodes properly") {
                let decoder = JSONDecoder()
                let encoder = JSONEncoder()
                            
                let json = """
                {
                    "someStruct": {
                        "int": 0,
                        "float": 0,
                        "double": 0,
                        "bool": false,
                        "array": [],
                        "dictionary": {}
                    }
                }
                """
                
                let actual = try! decoder.decode(SomeContanier.self, from: try! encoder.encode(someContainer))
                let expected = try! decoder.decode(SomeContanier.self, from: json.data(using: .utf8)!)
                
                expect(actual) == expected
                expect(actual) == someContainer
            }
            
            it("resolves default values properly") {
                expect(someContainer.someStruct) == .init()
                expect(someContainer.someStruct.int) == 0
                expect(someContainer.someStruct.float) == 0
                expect(someContainer.someStruct.double) == 0
                expect(someContainer.someStruct.bool) == false
                expect(someContainer.someStruct.string) == ""
                expect(someContainer.someStruct.array) == []
                expect(someContainer.someStruct.dictionary) == [:]
            }
        }
    }
}

private struct SomeOtherContainer {
    @Defaulted(value: .init(id: 2))
    var someDefaultableType: SomeDefaultableType
}

private struct SomeDefaultableType: DefaultableType {
    static var defaultValue: SomeDefaultableType = .init(id: 1)
    
    let id: Int
}

private struct SomeContanier: Codable, Equatable {
    @Defaulted var someStruct: SomeStruct
}

private struct SomeStruct: Codable, Equatable {
    @Defaulted var int: Int
    @Defaulted var float: Float
    @Defaulted var double: Double
    @Defaulted var bool: Bool
    @Defaulted var string: String
    @Defaulted var array: [Int]
    @Defaulted var dictionary: [Int: Int]
}

extension SomeStruct: DefaultableType {
    static var defaultValue: SomeStruct = .init()
}
