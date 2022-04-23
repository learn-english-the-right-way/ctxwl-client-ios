//
//  EmailVerificationError.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

struct EmailVerificationError: CTXWLClientUserFacingError {
    enum ErrorKind {
        case emailMismatch
        case emailExpired
        case verificationCodeMismatch
        case verificationCodeTriedTooManyTimes
    }
    var serverMessage: String = ""
    var userMessage: String = ""
    let kind: ErrorKind
    init(_ kind: ErrorKind) {
        self.kind = kind
    }
}
