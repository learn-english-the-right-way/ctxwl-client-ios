//
//  UserServiceDefault.swift
//  up-english
//
//  Created by James Tsai on 5/24/21.
//

import Foundation

class UserServiceDefault: UserService {
    var email: String {
        get {
            guard let email = UserDefaults.standard.string(forKey: "email") else {
                return ""
            }
            return email
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "email")
        }
    }
    
    var password: String = ""
    
    var applicationAuthenticationKey: String = ""
    
    var userID: Int = 0
    
    var userSessionToken: String = ""
    
}

