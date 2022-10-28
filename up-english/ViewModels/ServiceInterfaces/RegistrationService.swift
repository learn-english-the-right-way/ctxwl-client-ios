//
//  RegistrationService.swift
//  up-english
//
//  Created by James Tsai on 5/11/21.
//

import Foundation
import Combine

protocol RegistrationService {
//    var errorsPublisher: AnyPublisher<CLIENT_ERROR, Never> {get}
    func requestEmailConfirmation() -> AnyPublisher<Result<Void, CLIENT_ERROR>, Never>
    func register(confirmationCode: String) -> AnyPublisher<Result<Void, CLIENT_ERROR>, Never>
    func currentRegistrationStatus() -> RegistrationStatus
    func resetRegistrationStatus() -> Void
}
