//
//  ServiceContainerSpec.swift
//  FundamentalsTests
//
//  Created by jabari on 11/6/20.
//

import Nimble
import Quick
import XCTest

@testable import Fundamentals

final class ServiceContainerSpec: QuickSpec {
    override func spec() {
        describe("A ServiceContainer") {
            var subject: ServiceContainer!
            var service: MockService!
            var controller: MockController!
            
            beforeEach {
                subject = ServiceContainer()
                service = MockService()
                controller = MockController()
            }
            
            it("is empty by default") {
                expect(subject.isEmpty) == true
            }
            
            it("registers services properly") {
                subject.register(service, as: MockServiceProtocol.self)
                
                expect(subject.contains(MockServiceProtocol.self)) == true
                expect(subject.get(MockServiceProtocol.self)) === service
            }
            
            it("removes services properly") {
                subject.register(service, as: MockServiceProtocol.self)
                subject.remove(MockServiceProtocol.self)
                
                expect(subject.isEmpty) == true
                expect(subject.contains(MockServiceProtocol.self)) == false
            }
            
            it("clears services properly") {
                subject.register(service, as: MockServiceProtocol.self)
                subject.register(controller, as: MockControllerProtocol.self)
                
                subject.clear()
                
                expect(subject.isEmpty) == true
                expect(subject.contains(MockServiceProtocol.self)) == false
                expect(subject.contains(MockControllerProtocol.self)) == false
            }
            
            it("overrides instance for same type") {
                subject.register(service, as: MockServiceProtocol.self)
                subject.register(controller, as: MockServiceProtocol.self)
                
                expect(subject.get(MockServiceProtocol.self)) === controller
                expect(subject.get(MockServiceProtocol.self)) !== service
            }
        }
    }
}

final class ServiceContainerTest: XCTestCase {
    private var subject: ServiceContainer!
    
    override func setUp() {
        subject = ServiceContainer()
    }
    
    func testGetCallsFatalErrorWhenServiceIsNotFound() {
        let expectedMessage = "No service registered for type: MockService.Type"
        
        expectFatalError(expectedMessage: expectedMessage) { [weak self] in
            _ = self?.subject.get(MockService.self)
        }
    }
}
