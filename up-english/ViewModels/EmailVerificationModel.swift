//
//  EmailVerificationModelDefault.swift
//  up-english
//
//  Created by James Tsai on 7/2/21.
//

import Foundation
import Combine

@available(iOS 16.0, *)
class EmailVerificationModel: ObservableObject {
    
    private var registrationService: any RegistrationService
        
    private var router: Router
    
    private var registrationRequestCancellable: AnyCancellable?
    
    private var registrationServiceErrorsCancellable: AnyCancellable?
    
    private var requestAggregator: RequestAggregator
    
    private var uiErrorMapper: UIErrorMapper
    
    @Published var confirmationCode = ""
    
    @Published var registering = false
    
    @Published var displayConfirmationCodeErrMsg = false
    
    @Published var effect: UIEffect
    
    init(registrationService: any RegistrationService, router: Router, requestAggregator: RequestAggregator, errorMapper: UIErrorMapper) {
        self.registrationService = registrationService
        self.router = router
        self.requestAggregator = requestAggregator
        self.uiErrorMapper = errorMapper
        self.effect = UIEffect()
        
        self.registrationServiceErrorsCancellable = self.registrationService.errorsPublisher.sink(receiveValue: {clientError in
            self.effect = self.uiErrorMapper.mapError(clientError)
        })
    }
    
    func register() {
        guard !self.registering else {
            var effect = UIEffect()
            effect.action = .notice
            effect.message = "There is already a registration attempt under way"
            self.effect = effect
            return
        }
        self.registering = true
        self.registrationRequestCancellable = self.requestAggregator.register(code: self.confirmationCode)
        // TODO: figure out what this does
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: {status in self.registering = false},
                receiveValue: {effect in self.effect = effect}
            )
    }
    
    func reset() {
        self.registrationService.resetRegistrationStatus()
        // TODO: add go back logic
    }
}
