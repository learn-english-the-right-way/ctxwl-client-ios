//
//  DataTaskPublisher.swift
//  up-english
//
//  Created by James Tsai on 16/4/2022.
//

import Foundation
import Combine

struct CTXWLDataTaskPublisher: Publisher {
    
    typealias Output = Data
    
    typealias Failure = CLIENT_ERROR
    
    var dataTaskPublisher: AnyPublisher<Data, CLIENT_ERROR>
        
    init(dataTaskPublisher: URLSession.DataTaskPublisher, mappers: [ErrorMapper]) {
        self.dataTaskPublisher = dataTaskPublisher
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
                do {
                    throw try JSONDecoder().decode(CTXWL_SERVER_ERROR.self, from: data)
                } catch {
                    throw CANNOT_DECODE_RESPONSE()
                }
            }
            .mapError { error in
                var mappedError: CLIENT_ERROR?
                for errorMapper in mappers {
                    mappedError = errorMapper.mapToClientError(from: error)
                }
                guard let mappedError = mappedError else {
                    return CLIENT_ERROR()
                }
                return mappedError
            }
            .eraseToAnyPublisher()
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        self.dataTaskPublisher.receive(subscriber: subscriber)
    }
}

