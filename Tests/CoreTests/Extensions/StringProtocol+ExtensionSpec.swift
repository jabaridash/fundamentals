//
//  StringProtocol+ExtensionSpec.swift
//  CoreTests
//
//  Created by jabari on 11/7/20.
//

import Nimble
import Quick

@testable import Core

final class StringProtocolExtensionSpec: QuickSpec {
    override func spec() {
        describe("StringProtocol") {
            context("when counting based on predicate") {
                let alphabet = Set("abcdefghijklmnopqrstuvwzyz")
                
                it("behaves as expected when some resolve to true") {
                    let string = "i was 10 when i left home."
                    
                    expect(string.count(where: alphabet.contains)) == 17
                }
                
                it("behaves as expected when none resolve to true") {
                    let string = "12345678910"
                    
                    expect(string.count(where: alphabet.contains)) == 0
                }
                
                it("behaves as expected when all resolve to true") {
                    let string = "abc"
                    
                    expect(string.count(where: alphabet.contains)) == 3
                }
            }
            
            context("when counting occurences of a character") {
                it("counts zero properly") {
                    expect("".occurences(of: "_")) == 0
                }
                
                it("counts one properly") {
                    expect("a".occurences(of: "a")) == 1
                    expect("abcdefg".occurences(of: "a")) == 1
                }
                
                it("counts many properly") {
                    expect("aaaaaa".occurences(of: "a")) == 6
                    expect("aaaaaabcdefg".occurences(of: "a")) == 6
                }
            }
        }
    }
}
