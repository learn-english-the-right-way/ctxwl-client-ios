//
//  LoginModel.swift
//  up-english
//
//  Created by James Tsai on 7/19/21.
//

import Foundation
import Combine

protocol LoginModel: ObservableObject {
    var email: String {get set}
    var password: String {get set}
    var loginUnderway: Bool {get}
    var loginSuccess: Bool {get}
    func login() -> Void
}
