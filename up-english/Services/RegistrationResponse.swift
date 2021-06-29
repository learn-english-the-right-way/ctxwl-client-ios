//
//  RegistrationResponse.swift
//  up-english
//
//  Created by James Tsai on 5/21/21.
//

import Foundation

struct RegistrationResponse: Codable {
    let email: String
    let userID: Int
    let userAuthenticationApplicationKey: String
    let userSessionToken: String
}
