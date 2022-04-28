//
//  EmailVerificationError.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

class EmailVerificationError: CTXWLClientUserFacingError {
    enum ErrorKind {
        case emailMismatch
        case emailExpired
        case verificationCodeMismatch
        case verificationCodeTriedTooManyTimes
    }
    let kind: ErrorKind
    init(_ kind: ErrorKind) {
        self.kind = kind
    }
}
