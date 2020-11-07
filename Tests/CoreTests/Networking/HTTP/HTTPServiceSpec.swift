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
            var httpRequest: MockHTTPRequest<[Int]>!
            
            beforeEach {
                httpRequest = .mock()
                urlSession = .mock()
                httpConfiguration = .mock()
                
                subject = HTTPService(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
            }
            
            it("returns HTTPError.informational when status code is 1XX") {
                urlSession.response = HTTPURLResponse(statusCode: 100)
                
                httpConfiguration = .mock(shouldHandleStatusCode: true)
                
                subject = HTTPService(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        guard
                            case let .failure(error) = result,
                            case let .informational(response, data) = error
                        else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(response) == urlSession.response
                        expect(data) == urlSession.data
                        done()
                    }
                }
            }
            
            it("success when status code is non 2XX and status handling is off") {
                httpConfiguration = .mock(shouldHandleStatusCode: false)
                
                urlSession.response = HTTPURLResponse(
                    url: URL(string: "https://google.com")!,
                    statusCode: 400,
                    httpVersion: "HTTP/1.1",
                    headerFields: nil
                )
                
                subject = .init(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        guard case let .success(value) = result else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(value) == [1, 2, 3]
                        done()
                    }
                }
            }
            
            it("returns HTTPError.redirection when status code is 3XX") {
                urlSession.response = HTTPURLResponse(statusCode: 300)
                
                httpConfiguration = .mock(shouldHandleStatusCode: true)
                
                subject = HTTPService(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        guard
                            case let .failure(error) = result,
                            case let .redirection(response, data) = error
                        else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(response) == urlSession.response
                        expect(data) == urlSession.data
                        done()
                    }
                }
            }
            
            it("returns HTTPError.clientError when status code is 4XX") {
                urlSession.response = HTTPURLResponse(statusCode: 400)
                
                httpConfiguration = .mock(shouldHandleStatusCode: true)
                
                subject = HTTPService(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        guard
                            case let .failure(error) = result,
                            case let .clientError(response, data) = error
                        else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(response) == urlSession.response
                        expect(data) == urlSession.data
                        done()
                    }
                }
            }
            
            it("returns HTTPError.unrecognizedStatusCode when status code is invalid") {
                urlSession.response = HTTPURLResponse(statusCode: 600)
                
                httpConfiguration = .mock(shouldHandleStatusCode: true)
                
                subject = HTTPService(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        guard
                            case let .failure(error) = result,
                            case let .unrecognizedStatusCode(response, data) = error
                        else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(response) == urlSession.response
                        expect(data) == urlSession.data
                        done()
                    }
                }
            }
            
            it("returns HTTPError.clientError when status code is 5XX") {
                urlSession.response = HTTPURLResponse(statusCode: 500)
                
                httpConfiguration = .mock(shouldHandleStatusCode: true)
                
                subject = HTTPService(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        guard
                            case let .failure(error) = result,
                            case let .serverError(response, data) = error
                        else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(response) == urlSession.response
                        expect(data) == urlSession.data
                        done()
                    }
                }
            }
            
            it("returns HTTPError.noDataReturned when response is present but data is nil") {
                urlSession.data = nil
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        guard case let .failure(error) = result else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(error) == .noDataReturned
                        done()
                    }
                }
            }
                                    
            it("completion handler runs on correct ditpach queue when specified") {
                waitUntil { done in
                    let queue = DispatchQueue(label: "queue")
                    
                    let key = DispatchSpecificKey<String>()
                    queue.setSpecific(key: key, value: "abc")
                    
                    subject.task(for: httpRequest, on: queue).perform { result in
                        expect(DispatchQueue.getSpecific(key: key)) == "abc"
                        done()
                    }
                }
            }
            
            it("ResponseBody is decoded properly") {
                waitUntil { done in
                    urlSession.data = try! JSONEncoder().encode([1, 2, 3])
                    urlSession.response = HTTPURLResponse(
                        url: httpRequest.url,
                        statusCode: 200,
                        httpVersion: "HTTP/1.1",
                        headerFields: httpRequest.headers
                    )
                    
                    subject.task(for: httpRequest).perform { result in
                        switch result {
                        case .success(let value):
                            expect(value) == [1, 2, 3]
                            done()
                        default:
                            fail("\(result)")
                        }
                    }
                }
            }
            
            it("properly decodes custom data types") {
                let expected = CustomResponseBody(
                    id: 1,
                    names: ["abc", "def"],
                    otherValues: [
                        "a": 1,
                        "b": 2
                    ],
                    bools: [true, false, false],
                    date: Date(),
                    nestedType: .init(id: "abc")
                )
                
                urlSession.data = try! JSONEncoder().encode(expected)
                
                let request: MockHTTPRequest<CustomResponseBody> = .mock()
                
                waitUntil { done in
                    subject.task(for: request).perform { result in
                        guard case let .success(actual) = result else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(actual) == expected
                        done()
                    }
                }
            }
            
            it("returns proper error when encoder fails to decode response body") {
                let decoder = MockJSONDecoder()
                decoder.result = .failure(MockJSONDecoder.DecodeError.mockError)
                
                httpConfiguration = .mock(jsonDecoder: decoder)
                
                subject = .init(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
                
                httpRequest.method = .DELETE
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        expect(decoder.decodeCallCount) == 1
                        
                        guard
                            case let .failure(httpError) = result,
                            case let .decodingFailure(error as MockJSONDecoder.DecodeError) = httpError
                        else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(error) == .mockError
                        done()
                    }
                }
            }
            
            it("returns proper error when encoder fails to encode request body") {
                let encoder = MockJSONEncoder()
                encoder.result = .failure(MockJSONEncoder.EncodeError.mockError)
                
                httpConfiguration = .mock(jsonEncoder: encoder)
                
                subject = .init(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
                
                httpRequest.method = .PUT
                httpRequest.body = .init([1, 2, 3])
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        expect(encoder.encodeCallCount) == 1
                        
                        guard
                            case let .failure(httpError) = result,
                            case let .encodingFailure(error as MockJSONEncoder.EncodeError) = httpError
                        else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(error) == .mockError
                        done()
                    }
                }
            }
            
            it("returns proper error when URLSessionDataTask fails") {
                urlSession.error = MockError.httpRequestFailed
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        guard
                            case let .failure(httpError) = result,
                            case let .urlSession(error as MockError) = httpError
                        else {
                            fail("\(result)")
                            return
                        }
                        
                        expect(error) == MockError.httpRequestFailed
                        done()
                    }
                }
            }
                        
            it("HTTPConfigutation configures URLRequest") {
                httpConfiguration = .mock(
                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                    defaultHeaders: ["Authorization": "abc123", "X-API-KEY": "123"],
                    defaultParameters: ["id": "abc", "page": "2", "size": "2"],
                    jsonDecoder: JSONDecoder(),
                    jsonEncoder: JSONEncoder(),
                    shouldHandleStatusCode: true,
                    timeoutInterval: 200
                )
                
                httpRequest = .mock()
                
                subject = .init(
                    session: urlSession,
                    httpConfiguration: httpConfiguration
                )
                
                waitUntil { done in
                    subject.task(for: httpRequest).perform { result in
                        switch result {
                        case .failure(let error):
                            fail("\(error)")
                        case .success:
                            let request = urlSession.requests.last
                            
                            expect(request?.cachePolicy) == .reloadIgnoringLocalAndRemoteCacheData
                            expect(request?.allHTTPHeaderFields) == ["Authorization": "abc123", "X-API-KEY": "123"]
                            expect(request?.url?.query?.contains("id=abc")) == true
                            expect(request?.url?.query?.contains("page=2")) == true
                            expect(request?.url?.query?.occurences(of: "&")) == 2
                            expect(request?.timeoutInterval) == 200
                            done()
                        }
                    }
                }
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
                
                httpRequest = .mock(
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
 
                waitUntil { done in
                    subject.task(for: httpRequest).perform { _ in
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
                        done()
                    }
                }
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

private struct CustomResponseBody: Codable, Equatable {
    var id: Int
    var names: [String]
    var otherValues: [String: Int]
    var bools: [Bool]
    var date: Date
    var nestedType: NestedType
    
    struct NestedType: Codable, Equatable {
        var id: String
    }
}
