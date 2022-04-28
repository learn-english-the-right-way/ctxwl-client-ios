//
//  EmailRegistrationError.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

class EmailRegistrationError: CTXWLClientUserFacingError {
    enum ErrorKind {
        case emailOccupied
        case emailMalformed
    }
    let kind: ErrorKind
    init(_ kind: ErrorKind) {
        self.kind = kind
    }
}
