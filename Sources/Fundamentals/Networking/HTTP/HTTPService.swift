//
//  HTTPService.swift
//  Fundamentals
//
//  Created by jabari on 11/3/20.
//

import Foundation

// MARK: - HTTPService

/// Default implementation of `HTTPServiceProtocol`.
public final class HTTPService {
    /// The shared singleton `HTTPService` instance.
    public static let shared: HTTPService = .init(
        session: .shared,
        httpConfiguration: HTTPConfigurations.Default()
    )
    
    /// Contains properties that influece encoding, decoding, and handling of HTTP responses.
    private let httpConfiguration: HTTPConfiguration
    
    /// Used to execute the `URLRequest`s.
    private let session: URLSession
    
    /// Initializes the `HTTPService`.
    /// - Parameters:
    ///   - session: Instance of `URLSession` that will execute the request.
    ///   - httpConfiguration: Contains default values and other paratemeters that define detault behavior.
    public init(session: URLSession, httpConfiguration: HTTPConfiguration) {
        self.session = session
        self.httpConfiguration = httpConfiguration
    }
}

// MARK: - HTTPService conformance

extension HTTPService: HTTPServiceProtocol {
    public func task<R: HTTPRequest>(for request: R) -> Task<R.ResponseBody, HTTPError> {
        return .init { [weak self] completion in
            guard let self = self else { return }
            
            var urlComponents = URLComponents(url: request.url, resolvingAgainstBaseURL: true)
            
            // Build query parameters
            let parameters = self.httpConfiguration.defaultParameters.merged(with: request.parameters)
            
            if !parameters.isEmpty {
                urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
            
            // Convert URLComponents into standard URL object
            guard let url = urlComponents?.url else {
                completion(.failure(.invalidURLComponentsURL))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            
            // Build HTTP headers
            let headers = self.httpConfiguration.defaultHeaders.merged(with: request.headers)
            
            if !headers.isEmpty {
                headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
            }
            
            // Set the HTTP method
            urlRequest.httpMethod = request.method.rawValue
            
            // Build the HTTP body
            if request.method.supportsBody || request.supportsBodyForAllMethods, let body = request.body {
                do {
                    urlRequest.httpBody = try self.httpConfiguration.jsonEncoder.encode(body)
                } catch {
                    completion(.failure(.encodingFailure(error)))
                    return
                }
            }
            
            // Set other variables to configure the request
            if let timeoutInterval = request.timeoutInterval ?? self.httpConfiguration.timeoutInterval {
                urlRequest.timeoutInterval = timeoutInterval
            }
            
            if let cachePolicy = request.cachePolicy ?? self.httpConfiguration.cachePolicy {
                urlRequest.cachePolicy = cachePolicy
            }
            
            // Execute the data task once the URLRequest is built
            self.session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
                guard let self = self else { return }
                
                self.handle(
                    request: urlRequest,
                    response: response,
                    data: data,
                    error: error
                ) { result in
   
                    switch result {
                    case .success(let response):
                        do {
                            let body = try self.httpConfiguration.jsonDecoder.decode(
                                R.ResponseBody.self,
                                from: response.data
                            )
                            
                            completion(.success(body))
                        } catch {
                            completion(.failure(.decodingFailure(error)))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}


// MARK: - Private helpers for DefaultHTTPService

private extension HTTPService {
    /// Processes the incoming `URLResponse`'s status code or any other errors that
    /// may have occurred.
    /// - Parameters:
    ///   - request: The original request.
    ///   - response: The response to the `URLRequest`.
    ///   - data: Optional data that may have been returned as a result of executing the request.
    ///   - error: An optional error that may have been returned due to a failed request.
    ///   - completion: Completion handle that continues to handle the processed response.
    func handle(
        request: URLRequest,
        response: URLResponse?,
        data: Data?,
        error: Error?,
        completion: @escaping (Result<(response: HTTPURLResponse, data: Data), HTTPError>) -> Void
    ) {
        let result: Result<(response: HTTPURLResponse, data: Data), HTTPError>
        
        if let error = error {
            result = .failure(.urlSession(error))
        } else if let response = response as? HTTPURLResponse {
            if let data = data {
                if httpConfiguration.shouldHandleStatusCode {
                    switch response.statusCode {
                    case 100...199:
                        result = .failure(.informational(response, data: data))
                    case 200...299:
                        result = .success((response: response, data: data))
                    case 300...399:
                        result = .failure(.redirection(response, data: data))
                    case 400...499:
                        result = .failure(.clientError(response, data: data))
                    case 500...599:
                        result = .failure(.serverError(response, data: data))
                    default:
                        result = .failure(.unrecognizedStatusCode(response, data: data))
                    }
                } else {
                    result = .success((response: response, data: data))
                }
            } else {
                result = .failure(.noDataReturned)
            }
        } else {
            result = .failure(.invalidResponse)
        }
        
        completion(result)
    }
}
