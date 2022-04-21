//
//  AuthError.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

struct AuthError: CTXWLClientError {
    enum ErrorKind {
        case callerUnauthenticated
        case invalidApplicationKey
    }
    var serverMessage: String = ""
    let kind: ErrorKind
}
