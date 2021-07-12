//
//  EmailVerificationModel.swift
//  up-english
//
//  Created by James Tsai on 7/2/21.
//

import Foundation

protocol EmailVerificationModel: ObservableObject {
    var confirmationCode: String {get set}
    func register() -> Void
    func reset() -> Void
}
