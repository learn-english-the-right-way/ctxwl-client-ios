//
//  UIException.swift
//  up-english
//
//  Created by James Tsai on 7/1/22.
//

import Foundation

enum Action {
    case alert
    case notice
}

enum Destination {
    case EmailVerification
    case Login
    case Homepage
}

struct UIEffect {
    var action: Action?
    var redirectionInfo: Destination?
    var message: String?
}
