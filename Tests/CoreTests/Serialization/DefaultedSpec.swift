//
//  Defaulted.swift
//  CoreTests
//
//  Created by jabari on 11/7/20.
//

import Nimble
import Quick

@testable import Core

final class DefaultedSpec: QuickSpec {
    override func spec() {
        describe("Defaulted") {
            var somecontainer: SomeContanier!
            
            beforeEach {
                somecontainer = SomeContanier()
            }
            
            it("decodes properly") {
            
            }
            
            it("resolves default values properly") {
                expect(somecontainer.someStruct) == .init()
                expect(somecontainer.someStruct.int) == 0
                expect(somecontainer.someStruct.float) == 0
                expect(somecontainer.someStruct.double) == 0
                expect(somecontainer.someStruct.bool) == false
                expect(somecontainer.someStruct.string) == ""
                expect(somecontainer.someStruct.array) == []
                expect(somecontainer.someStruct.dictionary) == [:]
            }
        }
    }
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
