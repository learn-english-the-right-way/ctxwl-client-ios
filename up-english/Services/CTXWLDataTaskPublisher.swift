//
//  DataTaskPublisher.swift
//  up-english
//
//  Created by James Tsai on 16/4/2022.
//

import Foundation
import Combine

struct CTXWLDataTaskPublisher: Publisher {
    
    typealias Output = (data: Data, response: HTTPURLResponse)
    
    typealias Failure = Error
    
    var dataTaskPublisher: AnyPublisher<(data: Data, response: HTTPURLResponse), Error>
    
    init(dataTaskPublisher: URLSession.DataTaskPublisher) {
        self.dataTaskPublisher = dataTaskPublisher
            .tryMap { data, response -> (Data, HTTPURLResponse) in
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 400...599:
                        if ["application/vnd.ctxwl.error.email_registration+json", "application/vnd.ctxwl.error+json", "application/json"].contains(httpResponse.value(forHTTPHeaderField: "Content-Type")) {
                            do {
                                throw try JSONDecoder().decode(CTXWLError.self, from: data)
                            } catch let decodeError {
                                throw decodeError
                            }
                        }
                    default:
                        return (data, httpResponse)
                    }
                }
            }
            .mapError(<#T##transform: (Publishers.TryMap<URLSession.DataTaskPublisher, (Data, HTTPURLResponse)>.Failure) -> Error##(Publishers.TryMap<URLSession.DataTaskPublisher, (Data, HTTPURLResponse)>.Failure) -> Error#>)
            .eraseToAnyPublisher()
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, (data: Data, response: HTTPURLResponse) == S.Input {
        self.dataTaskPublisher.receive(subscriber: subscriber)
    }
}

