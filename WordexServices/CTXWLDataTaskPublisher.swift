//
//  DataTaskPublisher.swift
//  up-english
//
//  Created by James Tsai on 16/4/2022.
//

import Foundation
import Combine

public struct CTXWLDataTaskPublisher: Publisher {
    
    public typealias Output = Data
    
    public typealias Failure = CLIENT_ERROR
    
    var dataTaskPublisher: AnyPublisher<Data, CLIENT_ERROR>
        
    init(dataTaskPublisher: AnyPublisher<Data, CLIENT_ERROR>) {
        self.dataTaskPublisher = dataTaskPublisher
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        self.dataTaskPublisher.receive(subscriber: subscriber)
    }
}

