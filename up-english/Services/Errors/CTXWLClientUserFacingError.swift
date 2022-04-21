//
//  CTXWLClientUserFacingError.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

protocol CTXWLClientUserFacingError: CTXWLClientError {
    var userMessage: String { get }
}
