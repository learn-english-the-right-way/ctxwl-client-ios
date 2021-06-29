//
//  ViewError.swift
//  up-english
//
//  Created by James Tsai on 5/16/21.
//

import Foundation

struct ServerError: Error {
    var message = ""
    var action: Actions
    init(action: Actions) {
        self.action = action
    }
}
