//
//  Logger.swift
//  Core
//
//  Created by jabari on 11/8/20.
//

import Quick
import Nimble

@testable import Core

final class LoggerSpec: QuickSpec {
    override func spec() {
        describe("A Logger") {
            var subject: Logger!
            
            beforeEach {
                Logger.messages = []
                shouldRecordLoggedMessage = true
                
                subject = Logger(
                    configuration: .init(
                        logLevel: .all,
                        executionMode: .synchronous,
                        dateFormatter: .logFormatter
                    )
                )
            }
            
            afterEach {
                Logger.messages = []
                shouldRecordLoggedMessage = false
            }
            
            it("all() behaves as expected") {
                let expected = ["1995-10-30 20:31:00 +0000 ALL LoggerSpec.swift:spec() - ABC"]
                
                subject.all("ABC")
                
                expect(Logger.messages) == expected
            }
            
            it("info() behaves as expected") {
                let expected = ["1995-10-30 20:31:00 +0000 INFO LoggerSpec.swift:spec() - ABC"]
                
                subject.info("ABC")
                
                expect(Logger.messages) == expected
            }
            
            it("trace() behaves as expected") {
                let expected = ["1995-10-30 20:31:00 +0000 TRACE LoggerSpec.swift:spec() - ABC"]
                
                subject.trace("ABC")
                
                expect(Logger.messages) == expected
            }
            
            it("debug() behaves as expected") {
                let expected = ["1995-10-30 20:31:00 +0000 DEBUG LoggerSpec.swift:spec() - ABC"]
                
                subject.debug("ABC")
                
                expect(Logger.messages) == expected
            }
            
            it("warn() behaves as expected") {
                let expected = ["1995-10-30 20:31:00 +0000 WARN LoggerSpec.swift:spec() - ABC"]
                
                subject.warn("ABC")
                
                expect(Logger.messages) == expected
            }
            
            it("error() behaves as expected") {
                let expected = ["1995-10-30 20:31:00 +0000 ERROR LoggerSpec.swift:spec() - ABC"]
                
                subject.error("ABC")
                
                expect(Logger.messages) == expected
            }
            
            it("fatal() behaves as expected") {
                let expected = ["1995-10-30 20:31:00 +0000 FATAL LoggerSpec.swift:spec() - ABC"]
                
                subject.fatal("ABC")
                
                expect(Logger.messages) == expected
            }
            
            it("does not log if log level is lower than set log level") {
                subject = .init(
                    configuration: .init(
                        logLevel: .warn,
                        executionMode: .synchronous,
                        dateFormatter: .logFormatter
                    )
                )
                
                subject.info("ABC")
                
                expect(Logger.messages).to(beEmpty())
            }
            
            it("logs if log level is higher that set log level") {
                let expected = ["1995-10-30 20:31:00 +0000 WARN LoggerSpec.swift:spec() - ABC"]
                
                subject = .init(
                    configuration: .init(
                        logLevel: .info,
                        executionMode: .synchronous,
                        dateFormatter: .logFormatter
                    )
                )
                
                subject.warn("ABC")
                
                expect(Logger.messages) == expected
            }
            
            it("logs if log level is equal to set log level") {
                let expected = ["1995-10-30 20:31:00 +0000 TRACE LoggerSpec.swift:spec() - ABC"]
                
                subject = .init(
                    configuration: .init(
                        logLevel: .trace,
                        executionMode: .synchronous,
                        dateFormatter: .logFormatter
                    )
                )
                
                subject.trace("ABC")
                
                expect(Logger.messages) == expected
            }
            
            it("synchronously logs multiple messages in sequence properly") {
                precondition(Logger.messages.isEmpty)
                
                let expected: [String] = (1...10).map {
                    "1995-10-30 20:31:00 +0000 INFO LoggerSpec.swift:spec() - ABC: \($0)"
                }
                
                for i in 1...10 {
                    subject.info("ABC: \(i)")
                }
                                                    
                expect(Logger.messages) == expected
            }
            
            it("asynchronously logs multiple messages in sequence properly") {
                precondition(Logger.messages.isEmpty)
                
                subject = .init(
                    configuration: .init(
                        logLevel: .info,
                        executionMode: .asynchronous,
                        dateFormatter: .logFormatter
                    )
                )
                
                let expected: [String] = (1...10).map {
                    "1995-10-30 20:31:00 +0000 INFO LoggerSpec.swift:spec() - ABC: \($0)"
                }
                
                for i in 1...10 {
                    subject.info("ABC: \(i)")
                }
                
                waitUntil { done in
                    subject.dispatchQueue?.async {
                        expect(Logger.messages) == expected
                        done()
                    }
                }
            }
        }
    }
}
