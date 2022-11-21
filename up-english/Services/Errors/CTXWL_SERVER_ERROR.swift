//
//  CTXWLError.swift
//  up-english
//
//  Created by James Tsai on 18/4/2022.
//

import Foundation

struct CTXWL_SERVER_ERROR: Error, Decodable {
    struct Cause: Decodable {
        var code: String
        var component: String
        var payload: [String: String]?
    }
    var causes: [Cause]
    var message: String
}
