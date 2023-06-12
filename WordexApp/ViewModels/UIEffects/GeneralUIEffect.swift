//
//  UIException.swift
//  up-english
//
//  Created by James Tsai on 7/1/22.
//

import Foundation

enum Action {
    case alert
}

enum Destination {
    case EmailVerification
    case Login
    case Homepage
}

struct GeneralUIEffect {
    var action: Action?
    var redirectionInfo: Destination?
    var message: String?
}
