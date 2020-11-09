//
//  UserDefaultSpec.swift
//  FundamentalsTests
//
//  Created by jabari on 11/7/20.
//

import Foundation
import Nimble
import Quick

@testable import Fundamentals

final class UserDefaultSpec: QuickSpec {
    static var userDefaults: UserDefaults!
    
    override func spec() {
        describe("UserDefault") {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()
            let key = UserDefaultKey.username.name
            let suiteName = "UserDefaultSpec"
            
            var service: SomeService!
            
            beforeEach {
                Self.userDefaults = UserDefaults(suiteName: suiteName)!
            }
            
            afterEach {
                Self.userDefaults.removePersistentDomain(forName: suiteName)
                Self.userDefaults = nil
            }
            
            context("when working with custom types") {
                it("reads properly") {
                    service = SomeService()
                    
                    expect(service.customType) == .init(id: -1)
                }
                
                it("writes properly") {
                    service = SomeService()
                    
                    service.customType = CustomType(id: 2)
                                        
                    let data = Self.userDefaults.object(forKey: "custom-type") as? Data
                    
                    let actual = try? decoder.decode(CustomType.self, from: data!)
                    
                    expect(actual) == .init(id: 2)
                }
                
                it("overwrites properly") {
                    service = SomeService()
                    
                    service.customType = CustomType(id: 2)
                    service.customType = CustomType(id: 3)
                    
                    let data = Self.userDefaults.object(forKey: "custom-type") as? Data
                    let actual = try? decoder.decode(CustomType.self, from: data!)
                    
                    expect(actual) == .init(id: 3)
                }
            }
            
            context("when writing the value") {
                it("value gets overriden") {
                    Self.userDefaults.set(try? encoder.encode("user123"), forKey: key)
                    
                    precondition(Self.userDefaults.object(forKey: key) != nil)
                    
                    service = SomeService()
                    
                    service.username = "user-abc"
                    
                    expect(service.username) == "user-abc"
                }
            }
            
            context("when reading the value") {
                it("reads properly succeeds") {
                    Self.userDefaults.set(try? encoder.encode("user123"), forKey: key)
                                        
                    service = SomeService()
                    
                    expect(service.username) == "user123"
                }
                
                it("goes to default when data() returns nil") {
                    Self.userDefaults.setValue(nil, forKey: key)

                    precondition(Self.userDefaults.object(forKey: key) == nil)
                    
                    service = SomeService()

                    expect(service.username) == "no-user"
                }

                it("goes to default when decode() fails") {
                    Self.userDefaults.setValue([1, 2, 3], forKey: key)
                    
                    precondition(Self.userDefaults.object(forKey: key) != nil)
                    
                    service = SomeService()
                    
                    expect(service.username) == "no-user"
                }
            }
        }
    }
}

private class SomeService {
    @UserDefault(.username, defaultValue: "no-user", userDefaults: UserDefaultSpec.userDefaults)
    var username: String
    
    @UserDefault(.customType, defaultValue: .init(id: -1), userDefaults: UserDefaultSpec.userDefaults)
    var customType: CustomType
}

fileprivate extension UserDefaultKey {
    static let username: UserDefaultKey = .init(name: "username")
    static let customType: UserDefaultKey = .init(name: "custom-type")
}

fileprivate struct CustomType: Equatable, Codable {
    var id = 1
}
