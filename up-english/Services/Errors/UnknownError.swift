//
//  UnknownError.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

struct UnknownError: CTXWLClientError {
    var serverMessage: String = ""
}