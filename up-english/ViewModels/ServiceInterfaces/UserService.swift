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

protocol UserService: ObservableObject {
            
    var applicationAuthenticationKey: String {get set}
    
    func readApplicationKey() throws -> String
    
    func saveApplicationKey(key: String) throws -> Void
    
    func readCredentials() throws -> Credential
    
    func saveCredentials(email: String, password: String) throws -> Void
    
    func sessionProtectedDataTaskPublisher(request: URLRequest) -> AnyPublisher<Data, CLIENT_ERROR>
            
    func login() -> AnyPublisher<String, CLIENT_ERROR>
}

