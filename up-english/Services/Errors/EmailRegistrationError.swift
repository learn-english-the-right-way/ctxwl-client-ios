//
//  EmailRegistrationError.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

struct EmailRegistrationError: CTXWLClientUserFacingError {
    enum ErrorKind {
        case emailOccupied
        case emailMalformed
    }
    var serverMessage: String = ""
    var userMessage: String = ""
    let kind: ErrorKind
    init(_ kind: ErrorKind) {
        self.kind = kind
    }
}
