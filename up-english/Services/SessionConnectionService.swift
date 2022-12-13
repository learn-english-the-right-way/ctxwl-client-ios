//
//  UserService.swift
//  up-english
//
//  Created by James Tsai on 12/5/22.
//

import Foundation
import Combine

protocol SessionConnectionService {
    func sessionProtectedDataTaskPublisher(request: URLRequest) -> AnyPublisher<Data, CLIENT_ERROR>
}
