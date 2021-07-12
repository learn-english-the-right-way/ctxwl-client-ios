//
//  RegistrationModel.swift
//  up-english
//
//  Created by James Tsai on 5/3/21.
//

import Foundation
import Combine

protocol RegistrationModel: ObservableObject {
    var email: String {get set}
    var emailValid: Bool {get}
    var emailErrorMsg: String {get}
    var password1: String {get set}
    var password1Valid: Bool {get}
    var password1ErrorMsg: String {get}
    var password2: String {get set}
    var password2Valid: Bool {get}
    var password2ErrorMsg: String {get}
    var confirmationCode: String {get set}
    var validationFailed: Bool {get}
    var requestingConfirmationCode: Bool {get}
    func requestConfirmationCode() -> Void

}
