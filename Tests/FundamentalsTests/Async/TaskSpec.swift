//
//  TaskSpec.swift
//  FundamentalsTests
//
//  Created by jabari on 11/6/20.
//

import Foundation
import Nimble
import Quick

@testable import Fundamentals

final class TaskSpec: QuickSpec {
    override func spec() {
        describe("A Task") {
            var subject: Task<Int, MockError>!
            var result: Result<Int, MockError>!
            var taskComplete: Bool!
            
            beforeEach {
                taskComplete = false
                result = .success(1)
                
                subject = .init { completion in
                    completion(result)
                }
            }
            
            context("when calling .error()") {
                it("the correct error is resolved") {
                    subject = .error(MockError.basicError)
                    
                    waitUntil { done in
                        subject.perform { result in
                            guard case let .failure(error) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(error) == MockError.basicError
                            done()
                        }
                    }
                }
            }
            
            context("when calling .just()") {
                it("the correct error is resolved") {
                    subject = .just(1)
                    
                    waitUntil { done in
                        subject.perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == 1
                            done()
                        }
                    }
                }
            }
            
            context("when calling mapError()") {
                it("the new error error is resolved") {
                    subject = .error(MockError.basicError)
                    
                    waitUntil { done in
                        subject
                            .mapError { _ in MappedError.anotherError }
                            .perform { result in
                            guard case let .failure(error) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(error) == .anotherError
                            done()
                        }
                    }
                }
                
                it("original value is still resolved") {
                    subject = .just(1)
                    
                    waitUntil { done in
                        subject
                            .mapError { _ in MappedError.anotherError }
                            .perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == 1
                            done()
                        }
                    }
                }
            }
            
            context("when calling map()") {
                it("new value is returned") {
                    subject = .just(1)
                    
                    waitUntil { done in
                        subject
                            .map { "\(2 * $0)" }
                            .perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == "2"
                            done()
                        }
                    }
                }
                
                it("error can be re-cast back to original error type") {
                    subject = .error(MockError.basicError)
                    
                    waitUntil { done in
                        subject
                            .map { 2 * $0 }
                            .perform { result in
                            guard case let .failure(error) = result else {
                                fail("\(result)")
                                return
                            }
            
                            expect(error as? MockError) == .basicError
                            done()
                        }
                    }
                }
                
                it("new error type can be resolved if map() throws") {
                    subject = .just(1)
                    
                    waitUntil { done in
                        subject
                            .map { _ in throw MappedError.anotherError }
                            .perform { result in
                            guard case let .failure(error as MappedError) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(error) == .anotherError
                            done()
                        }
                    }
                }
            }
            
            context("when calling perform()") {
                it("completion is called") {
                    subject.perform { result in
                        taskComplete = true
                    }
                    
                    expect(taskComplete).toEventually(equal(true))
                }
                
                it("value is properly resolved") {
                    result = .success(10)
                    
                    waitUntil { done in
                        subject.perform { result in
                            guard case let .success(value) = result else {
                                fail("\(result)")
                                return
                            }
                            
                            expect(value) == 10
                            done()
                        }
                    }
                }
                
                it("completion is called on proper dispatch queue when specified") {
                    let queue = DispatchQueue(label: "abc")
                    let key = DispatchSpecificKey<String>()
                    
                    queue.setSpecific(key: key, value: "abc-key")
                    
                    waitUntil { done in
                        _ = subject.perform(on: queue) { result in
                            expect(DispatchQueue.getSpecific(key: key)) == "abc-key"
                            done()
                        }
                    }
                }
            }
        }
    }
}

private enum MappedError: Error, Equatable {
    case anotherError
}
