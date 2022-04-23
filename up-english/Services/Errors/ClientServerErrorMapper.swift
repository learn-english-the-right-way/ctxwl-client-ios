//
//  ClientServerErrorMapper.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

func clientServerErrorMapper(_ serverError: CTXWLError) -> CTXWLClientError {
    for cause in serverError.causes {
        switch cause {
        case cause.component == "" &&
        }
    }
    var unknownError = UnknownError()
    unknownError.serverMessage = serverError.message
    return unknownError
}
