//
//  RegistrationService.swift
//  up-english
//
//  Created by James Tsai on 5/11/21.
//

import Foundation
import Combine

public protocol RegistrationService {
    func requestEmailConfirmation() -> AnyPublisher<Result<Void, CLIENT_ERROR>, Never>
    func register(confirmationCode: String) -> AnyPublisher<Result<Void, CLIENT_ERROR>, Never>
    var requireVerification: AnyPublisher<Bool, Never> {get}
    func currentRegistrationStatus() -> RegistrationStatus
    func resetRegistrationStatus() -> Void
}
