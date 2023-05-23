//
//  CTXWL_SERVER_MAPPED_CLIENT_ERROR.swift
//  up-english
//
//  Created by James Tsai on 6/25/22.
//

import Foundation

public class SERVER_MAPPED_CLIENT_ERROR: CLIENT_ERROR {
    var serverMessage: String
    init(_ serverMessage: String) {
        self.serverMessage = serverMessage
    }
}
