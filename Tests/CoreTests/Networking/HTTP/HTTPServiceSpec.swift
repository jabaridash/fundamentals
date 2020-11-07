//
//  HTTPServiceSpec.swift
//  CoreTests
//
//  Created by jabari on 11/6/20.
//

import Foundation
import Nimble
import Quick

@testable import Core

final class HTTPServiceSpec: QuickSpec {
    override func spec() {
        describe("An HTTPService") {
            var subject: HTTPService!
            var urlSession: MockURLSession!
            var httpConfiguration: MockHTTPConfiguration!
            var httpRequest: MockHTTPRequest!
            
            beforeEach {
                httpRequest = .mock()
                urlSession = .mock()
                httpConfiguration = .mock()
                subject = HTTPService(session: urlSession, httpConfiguration: httpConfiguration)
            }
            
            it("URLRequest is built properly") {
                httpConfiguration = .mock(
                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                    defaultHeaders: ["Authorization": "abc123", "X-API-KEY": "123"],
                    defaultParameters: ["id": "abc", "page": "2", "size": "2"],
                    jsonDecoder: JSONDecoder(),
                    jsonEncoder: JSONEncoder(),
                    shouldHandleStatusCode: false,
                    timeoutInterval: 200
                )
                
                httpRequest = .init(
                    url: URL(string: "https://yahoo.com/auth/login")!,
                    method: .GET,
                    headers: ["X-API-KEY": "321"],
                    parameters: ["page": "1"],
                    body: AnyEncodable([1, 2, 3]),
                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                    timeoutInterval: 300,
                    supportsBodyForAllMethods: true
                )
                
                subject = .init(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
                
                subject.task(for: httpRequest).perform { _ in }
                
                let request = urlSession.requests.last
                                
                expect(request?.url?.scheme) == "https"
                expect(request?.url?.host) == "yahoo.com"
                expect(request?.url?.port).to(beNil())
                expect(request?.url?.user).to(beNil())
                expect(request?.url?.password).to(beNil())
                expect(request?.url?.path) == "/auth/login"
                expect(request?.url?.query?.contains("id=abc")) == true
                expect(request?.url?.query?.contains("page=1")) == true
                expect(request?.url?.query?.contains("size=2")) == true
                expect(request?.url?.query?.occurences(of: "&")) == 2
                expect(request?.httpMethod) == "GET"
                expect(request?.allHTTPHeaderFields) == ["Authorization": "abc123", "X-API-KEY": "321"]
                expect(request?.httpBody) == (try! JSONEncoder().encode([1, 2, 3]))
                expect(request?.cachePolicy) == .reloadIgnoringLocalAndRemoteCacheData
                expect(request?.timeoutInterval) == 300
            }
            
            it("HTTPError.invalidResponse is returned when data, response, and error are returned") {
                urlSession.data = nil
                urlSession.response = nil
                urlSession.error = nil
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        guard case let .failure(error) = result else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(error) == .invalidResponse
                        done()
                    }
                }
            }
        }
    }
}
