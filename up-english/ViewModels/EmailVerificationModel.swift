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
    
    private var handler: EmailVerificationModelHandler?
    
    @Published var confirmationCode = ""
        
    @Published var displayConfirmationCodeErrMsg = false
    
    func register() {
        guard let handler = self.handler else {
            return
        }
        handler.register(code: self.confirmationCode)
    }
    
    func reset() {
        // TODO: add go back logic
    }
    
    func setHandler(_ handler: EmailVerificationModelHandler) {
        self.handler = handler
    }
}

protocol EmailVerificationModelHandler {
    func register(code: String) -> Void
}

@available(iOS 16.0, *)
class EmailVerificationModelHandlerDefault: EmailVerificationModelHandler {
    private var registrationService: RegistrationService
    private var router: Router
    private var errorMapper: UIErrorMapper
    private var generalUIEffectManager: GeneralUIEffectManager
    private var emailVerificationModel: EmailVerificationModel
    
    private var requestingRegistration = false
    var registrationRequestCancellable: AnyCancellable?
    
    init(registrationService: RegistrationService, router: Router, errorMapper: UIErrorMapper, generalUIEffectManager: GeneralUIEffectManager, emailVerificationModel: EmailVerificationModel) {
        self.registrationService = registrationService
        self.router = router
        self.errorMapper = errorMapper
        self.generalUIEffectManager = generalUIEffectManager
        self.emailVerificationModel = emailVerificationModel
    }
    
    func register(code: String) -> Void {
        guard self.requestingRegistration == false else {
            var effect = GeneralUIEffect()
            effect.action = .notice
            effect.message = "There is already a registration attempt under way"
            self.generalUIEffectManager.newEffect(effect)
            return
        }
        self.requestingRegistration = true
        self.registrationRequestCancellable = self.registrationService.register(confirmationCode: code)
            .sink { result in
                switch result {
                case .success():
                    //TODO: add logic to route to homepage
                    print("need to add logic to navigate to login page")
                case .failure(let clientError):
                    let effect = self.errorMapper.mapError(clientError)
                    self.generalUIEffectManager.newEffect(effect)
                }
            }
    }
}
