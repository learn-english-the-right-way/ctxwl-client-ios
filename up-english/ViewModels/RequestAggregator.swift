//
//  RequestAggregator.swift
//  up-english
//
//  Created by James Tsai on 7/2/22.
//

import Foundation
import Combine

protocol RequestAggregator {
    func login() -> AnyPublisher<UIException, Never>
}
