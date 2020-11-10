//
//  ExampleSpec.swift
//  FundamentalsTests
//
//  Created by jabari on 11/9/20.
//

import Foundation
import Fundamentals
import Nimble
import Quick

//final class ExampleSpec: QuickSpec {
//    override func spec() {
//        describe("An ExampleService") {
//            var subject: ExampleService!
//            var httpsService: HTTPService!
//            var logger: Logger!
//            
//            beforeEach {
//                logger = Logger(configuration: .default)
//                httpsService = HTTPService(session: .shared, httpConfiguration: .default)
//                
//                ServiceContainer.example.register(logger, as: LoggerProtocol.self)
//                ServiceContainer.shared.register(httpsService, as: HTTPService.self)
//                ServiceContainer.shared.register(ExampleService(), as: ExampleService.self)
//                
//                subject = ServiceContainer.shared.get(ExampleService.self)
//            }
//            
//            afterEach {
//                ServiceContainer.example.clear()
//                ServiceContainer.shared.clear()
//                
//                UserDefaults.example.removePersistentDomain(forName: "example")
//            }
//            
//            it("integrates the components from the Fundamentals library as expected") {
//                expect(subject.usersLoaded) == 0
//        
//                let expectedUser = User(
//                    id: .init(value: "id"),
//                    name: .init(value: "name"),
//                    transactions: [
//                        .init(id: 1, description: "description-1"),
//                        .init(id: 2, description: "description-2")
//                    ]
//                )
//                
//                waitUntil { done in
//                    subject.load { result in
//                        guard case let .success(actualUser) = result else {
//                            fail("\(result)")
//                            return
//                        }
//                        
//                        expect(subject.usersLoaded) == 1
//                        expect(actualUser) == expectedUser
//                        done()
//                    }
//                }
//            }
//        }
//    }
//}
