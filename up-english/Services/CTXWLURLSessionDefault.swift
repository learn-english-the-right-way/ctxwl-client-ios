//
//  CTXWLURLSessionDefault.swift
//  up-english
//
//  Created by James Tsai on 5/15/22.
//

import Foundation

class CTXWLURLSessionDefault: CTXWLURLSession {
    var mappers: [ErrorMapper]
    var configuration: URLSessionConfiguration
    init(configuration: URLSessionConfiguration, mappers: [ErrorMapper]) {
        self.mappers = mappers
        self.configuration = configuration
    }
    func dataTaskPublisher(for: URLRequest) -> CTXWLDataTaskPublisher {
        let basicPublisher = URLSession(configuration: self.configuration).dataTaskPublisher(for: `for`)
        return CTXWLDataTaskPublisher(dataTaskPublisher: basicPublisher, mappers: self.mappers)
    }
}
