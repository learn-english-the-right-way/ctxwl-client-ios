//
//  CTXWLURLSessionDefault.swift
//  up-english
//
//  Created by James Tsai on 5/15/22.
//

import Foundation
import Combine

class CTXWLURLSessionDefault: CTXWLURLSession {
    
    var mappers: [ErrorMapper] = [ServerErrorMapper()]
    
    var configuration: URLSessionConfiguration = URLSessionConfiguration.default

    func dataTaskPublisher(for: URLRequest) -> CTXWLDataTaskPublisher {
        let basicPublisher = URLSession(configuration: self.configuration).dataTaskPublisher(for: `for`)
        let publisherModifier = { (publisher: URLSession.DataTaskPublisher) -> AnyPublisher in
            return publisher
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
                .eraseToAnyPublisher()
        }
        return CTXWLDataTaskPublisher(dataTaskPublisher: basicPublisher, mappers: self.mappers, publisherModifier: publisherModifier)
    }
}
