//
//  UIException.swift
//  up-english
//
//  Created by James Tsai on 7/1/22.
//

import Foundation

enum Action {
    case notice
    case choice
    case input
    case nothing
}

class UIException: Error {
    var message: String = ""
    var redirect: String = ""
    var action: Action = .notice
}
