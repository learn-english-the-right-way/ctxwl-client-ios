//
//  CTXWLURLSessionDefault.swift
//  up-english
//
//  Created by James Tsai on 5/15/22.
//

import Foundation
import Combine

public class CTXWLURLSessionDefault: CTXWLURLSession {
    
    var mappers: [ErrorMapper] = [ServerErrorMapper()]
    
    var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    
    public init() {}
    
    public func dataTaskPublisher(for: URLRequest) -> CTXWLDataTaskPublisher {
        let publisher = URLSession(configuration: self.configuration).dataTaskPublisher(for: `for`)
            .handleEvents(receiveOutput: { data, response in
                  print(response)
               })
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw RESPONSE_NOT_HTTP()
                }
                if !(400...599).contains(httpResponse.statusCode) {
                    return data
                }
                if !["application/vnd.ctxwl.error.email_registration+json", "application/vnd.ctxwl.error+json", "application/json"].contains(httpResponse.value(forHTTPHeaderField: "Content-Type")) {
                    throw UNKNOWN_SERVER_ERROR()
                }
                if let serverError = try? JSONDecoder().decode(CTXWL_SERVER_ERROR.self, from: data) {
                    print(serverError)
                    var errorToThrow = CLIENT_ERROR()
                    for errorMapper in self.mappers {
                        if let mappedError = errorMapper.mapToClientError(from: serverError) {
                            errorToThrow = mappedError
                        }
                    }
                    throw errorToThrow
                }
                return data
            }
            .mapError { error in
                var mappedError: CLIENT_ERROR?
                for errorMapper in self.mappers {
                    mappedError = errorMapper.mapToClientError(from: error)
                }
                guard let mappedError = mappedError else {
                    return CLIENT_ERROR()
                }
                return mappedError
            }
            .eraseToAnyPublisher()

        return CTXWLDataTaskPublisher(dataTaskPublisher: publisher)
    }
}
