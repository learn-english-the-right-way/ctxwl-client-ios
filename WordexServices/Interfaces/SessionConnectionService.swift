//
//  UserService.swift
//  up-english
//
//  Created by James Tsai on 12/5/22.
//

import Foundation
import Combine

public protocol SessionConnectionService: AnyObject {
    var applicationKey: String? {get}
    var authenticationKeyAccquired: AnyPublisher<String, Never> {get}
    var loggedIn: AnyPublisher<Bool, Never> {get}
    func sessionProtectedDataTaskPublisher(request: URLRequest) -> AnyPublisher<Data, CLIENT_ERROR>
    func logout() -> Void
}
