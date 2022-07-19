//
//  CTXWLError.swift
//  up-english
//
//  Created by James Tsai on 18/4/2022.
//

import Foundation

struct CTXWL_SERVER_ERROR: Error, Codable {
    struct Cause: Codable {
        var code: String
        var component: String
        var payload: [String: String]
    }
    var causes: [Cause]
    var message: String
}
