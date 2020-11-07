//
//  AnyDecodableSpec.swift
//  CoreTests
//
//  Created by jabari on 11/7/20.
//

import Foundation
import Nimble
import Quick

@testable import Core

final class AnyEncodableSpec: QuickSpec {
    override func spec() {
        describe("An AnyEncodable") {
            var subject: AnyEncodable!
            var encoder: JSONEncoder!
            
            beforeEach {
                encoder = JSONEncoder()
            }
            
            it("encodes ints properly from primitive") {
                subject = AnyEncodable(1)
                
                let actual = try? encoder.encode(subject)
                let expected = try? encoder.encode(1)
                
                expect(actual) == expected
            }
            
            it("encodes strings properly from primitive") {
                subject = AnyEncodable("1")
                
                let actual = try? encoder.encode(subject)
                let expected = try? encoder.encode("1")
                
                expect(actual) == expected
            }
            
            it("encodes arrays properly from primitive") {
                subject = AnyEncodable([1, 2, 3])
                
                let actual = try? encoder.encode(subject)
                let expected = try? encoder.encode([1, 2, 3])
                
                expect(actual) == expected
            }
            
            it("encodes dictionaries properly from primitive") {
                subject = AnyEncodable(["key": "value"])
                
                let actual = try? encoder.encode(subject)
                let expected = try? encoder.encode(["key": "value"])
                
                expect(actual) == expected
            }
            
            it("encodes dictionaries properly from primitive") {
                subject = AnyEncodable(CustomEncodable(id: 1))
                
                let actual = try? encoder.encode(subject)
                let expected = try? encoder.encode(CustomEncodable(id: 1))
                
                expect(actual) == expected
            }
        }
    }
}

private struct CustomEncodable: Encodable {
    let id: Int
}
