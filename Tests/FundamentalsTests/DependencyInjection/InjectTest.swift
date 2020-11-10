//
//  InjectSpect.swift
//  FundamentalsTests
//
//  Created by jabari on 11/7/20.
//

import Foundation
import XCTest

@testable import Fundamentals

final class InjectTest: XCTestCase {
    fileprivate static var container: ServiceContainer!
    private var dependency: MockDependency!
    
    override func setUp() {
        dependency = MockDependency()
    }
    
    override func tearDown() {
        dependency = nil
        Self.container?.clear()
        ServiceContainer.shared.clear()
    }
    
    func testResolvesFromSharedContainer() {
        Self.container = ServiceContainer()
        Self.container.register(dependency, as: MockDependency.self)
        
        let otherClass = OtherClass()
        
        XCTAssert(otherClass.dependency === dependency)
    }
    
    func testResolvedFromSpecifiedContainer() {
        ServiceContainer.shared.register(dependency, as: MockDependency.self)
        
        let someClass = SomeClass()
        
        XCTAssert(someClass.dependency === dependency)
    }
    
    func testFatalWhenDependencyNotResolved() {
        let expectedMessage = "No service registered for type: MockDependency.Type"
        
        ServiceContainer.shared.remove(MockDependency.self)
                
        expectFatalError(expectedMessage: expectedMessage) {
            _ = SomeClass()
        }
    }
    
    func testDependencyIsPresentAfterBeingRemovedFromContainer() {
        ServiceContainer.shared.register(dependency, as: MockDependency.self)
        
        precondition(ServiceContainer.shared.contains(MockDependency.self))
        
        let someClass = SomeClass()
        
        ServiceContainer.shared.remove(MockDependency.self)
        
        precondition(!ServiceContainer.shared.contains(MockDependency.self))
        
        XCTAssert(someClass.dependency === dependency)
    }
}

fileprivate class MockDependency {}

fileprivate class SomeClass {
    @Inject var dependency: MockDependency
}

fileprivate class OtherClass {
    @Inject(from: InjectTest.container)
    var dependency: MockDependency
}
