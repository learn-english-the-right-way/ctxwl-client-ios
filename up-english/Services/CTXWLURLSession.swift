//
//  CTXWLURLSession.swift
//  up-english
//
//  Created by James Tsai on 15/4/2022.
//

import Foundation
import Combine

protocol CTXWLURLSession {
    func dataTaskPublisher(for: URLRequest) -> AnyPublisher<(data: Data, response: HTTPURLResponse), CTXWLClientError>
}
