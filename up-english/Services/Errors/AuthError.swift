//
//  AuthError.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

class AuthError: CTXWLClientError {
    enum ErrorKind {
        case callerUnauthenticated
        case invalidApplicationKey
        case unauthorizedAccess
    }
    let kind: ErrorKind
    init(_ kind: ErrorKind) {
        self.kind = kind
    }
}
