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
        
    init(dataTaskPublisher: URLSession.DataTaskPublisher, mappers: [ErrorMapper], publisherModifier: (URLSession.DataTaskPublisher) -> AnyPublisher<Data, Error>) {
        self.dataTaskPublisher = publisherModifier(dataTaskPublisher)
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

