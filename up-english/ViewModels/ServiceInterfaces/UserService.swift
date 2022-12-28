//
//  UserService.swift
//  up-english
//
//  Created by James Tsai on 5/21/21.
//

import Foundation
import Combine

struct Credential {
    var username: String
    var password: String
}

protocol UserService: SessionConnectionService {
    var credential: Credential? {get}
    var errorsPublisher: AnyPublisher<CLIENT_ERROR, Never> {get}
    func saveCredential(username: String, password: String) throws -> Void
    func saveAuthenticationApplicationKey(key: String) throws -> Void
    func login() -> AnyPublisher<Result<Void, CLIENT_ERROR>, Never>
}

