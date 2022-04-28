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
    
    typealias Failure = CTXWLClientError
    
    var dataTaskPublisher: AnyPublisher<Data, CTXWLClientError>
        
    init(dataTaskPublisher: URLSession.DataTaskPublisher, mappers: [ErrorMapper]) {
        self.dataTaskPublisher = dataTaskPublisher
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw InvalidResponseError()
                }
                if !(400...599).contains(httpResponse.statusCode) {
                    return data
                }
                if !["application/vnd.ctxwl.error.email_registration+json", "application/vnd.ctxwl.error+json", "application/json"].contains(httpResponse.value(forHTTPHeaderField: "Content-Type")) {
                    throw CTXWLUnknownServerError()
                }
                do {
                    throw try JSONDecoder().decode(CTXWLServerError.self, from: data)
                } catch {
                    throw ResponseDecodeError()
                }
            }
            .mapError { error in
                var mappedError: CTXWLClientError?
                for errorMapper in mappers {
                    mappedError = errorMapper.mapToClientError(from: error)
                }
                guard let mappedError = mappedError else {
                    return CTXWLClientError()
                }
                return mappedError
            }
            .eraseToAnyPublisher()
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        self.dataTaskPublisher.receive(subscriber: subscriber)
    }
}

