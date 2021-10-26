//
//  RegistrationService.swift
//  up-english
//
//  Created by James Tsai on 5/11/21.
//

import Foundation
import Combine

protocol RegistrationService: ObservableObject {
    func requestEmailConfirmation(email: String, password: String) -> AnyPublisher<Never, Error>
    func register(email: String, confirmationCode: String) -> AnyPublisher<RegistrationResponse, Error>
    func currentRegistrationStatus() -> RegistrationStatus
    func resetRegistrationStatus() -> Void
}
