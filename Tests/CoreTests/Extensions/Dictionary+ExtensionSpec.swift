//
//  Dictionary+ExtensionSpec.swift
//  CoreTests
//
//  Created by jabari on 11/7/20.
//

import Nimble
import Quick

@testable import Core

final class DictionaryExtensionSpec: QuickSpec {
    override func spec() {
        describe("DictionaryExtension") {
            context("when creating copy via merged()") {
                it("returns empty dictionary when merging two empty dictionaries") {
                    let one: [Int: Int] = [:]
                    let two: [Int: Int] = [:]
                    
                    expect(one.merged(with: two)) == [:]
                }
                
                it("returns second dictionary when merging non-empty dictionary into empty dictionary") {
                    let one: [Int: Int] = [:]
                    let two: [Int: Int] = [1:1]
                    
                    expect(one.merged(with: two)) == [1:1]
                }
                
                it("returns first dictionary when merging empty dictionary into non-empty dictionary") {
                    let one: [Int: Int] = [1:1]
                    let two: [Int: Int] = [:]
                    
                    expect(one.merged(with: two)) == [1:1]
                }
                
                it("returns union of two non-dictionaries with no conflicting keys") {
                    let one = [1:1]
                    let two = [2:2]
                    
                    let expected = [1:1, 2:2]
                    let actual = one.merged(with: two)
                    
                    expect(actual) == expected
                }
                
                it("overrides values from passed dictionary for conflicting keys") {
                    let one = [1:1, 2:1]
                    let two = [2:2]
                    
                    let expected = [1:1, 2:2]
                    let actual = one.merged(with: two)

                    expect(actual) == expected
                }
            }
            
            context("when merging dictionary into existing dictionary") {
                it("empty dictionary remains empty when merging with another empty dictionary") {
                    var one: [Int: Int] = [:]
                    
                    one.merge(with: [:])
                    
                    expect(one.isEmpty) == true
                }
                
                it("first dictionary becomes second dictionary when merging non-empty dictionary into empty dictionary") {
                    var one: [Int: Int] = [:]
                    let two: [Int: Int] = [1:1]
                    
                    one.merge(with: two)
                    
                    expect(one) == two
                }
                
                it("dictionary remains unchanged when merging empty dictionary into non-empty dictionary") {
                    var one: [Int: Int] = [1:1]
                    
                    one.merge(with: [:])
                    
                    expect(one) == [1:1]
                }
                
                it("dictionary becomes union when other dictionary has no conflicting keys") {
                    var one = [1:1]
                    let two = [2:2]
                    
                    let expected = [1:1, 2:2]
                    
                    one.merge(with: two)
                    
                    expect(one) == expected
                }
                
                it("overrides values from passed dictionary for conflicting keys") {
                    var one = [1:1, 2:1]
                    let two = [2:2]
                    
                    let expected = [1:1, 2:2]
                    one.merge(with: two)

                    expect(one) == expected
                }
            }
        }
    }
}
