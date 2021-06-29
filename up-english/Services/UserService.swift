//
//  UserService.swift
//  up-english
//
//  Created by James Tsai on 5/21/21.
//

import Foundation

protocol UserService: ObservableObject {
    
    var email: String { get set }
    
    var password: String {get set}
    
    var applicationAuthenticationKey: String {get set}
}

