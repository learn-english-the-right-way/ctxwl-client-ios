//
//  UserService.swift
//  up-english
//
//  Created by James Tsai on 5/21/21.
//

import Foundation
import Combine

protocol UserService: ObservableObject {
    
    var email: String { get set }
    
    var password: String {get set}
    
    var applicationAuthenticationKey: String {get set}
            
    func login(email: String, password: String) -> AnyPublisher<Never, Error>
}

