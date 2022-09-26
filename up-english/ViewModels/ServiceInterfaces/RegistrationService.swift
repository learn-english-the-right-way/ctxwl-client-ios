//
//  RegistrationService.swift
//  up-english
//
//  Created by James Tsai on 5/11/21.
//

import Foundation
import Combine

protocol RegistrationService: ObservableObject {
    var errorsPublisher: AnyPublisher<CLIENT_ERROR, Never> {get}
    func requestEmailConfirmation() -> AnyPublisher<String, CLIENT_ERROR>
    func register(confirmationCode: String) -> AnyPublisher<String, CLIENT_ERROR>
    func currentRegistrationStatus() -> RegistrationStatus
    func resetRegistrationStatus() -> Void
}
