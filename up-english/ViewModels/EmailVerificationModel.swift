//
//  EmailVerificationModelDefault.swift
//  up-english
//
//  Created by James Tsai on 7/2/21.
//

import Foundation
import Combine
import WordexServices

@available(iOS 16.0, *)
class EmailVerificationModel: ObservableObject {

    private var handler: EmailVerificationModelDelegate?
    
    @Published var confirmationCode = ""
        
    @Published var displayConfirmationCodeErrMsg = false
    
    @Published var registering = false
    
    @Published var isButtonDisabled = true
    
    func checkButtonStatus() {
        if confirmationCode != "" {
            isButtonDisabled = false
        } else {
            isButtonDisabled = true
        }
    }
    
    func register() {
        guard let handler = self.handler else {
            return
        }
        handler.register(code: self.confirmationCode)
    }
    
    func reset() {
        // TODO: add go back logic
        guard let handler = self.handler else {
            return
        }
        handler.resetRegistrationStatus()
    }
    
    func setHandler(_ handler: EmailVerificationModelDelegate) {
        self.handler = handler
    }
    
    func cleanUp() {
        self.handler?.registrationRequestCancellable?.cancel()
        self.handler?.model = nil
        self.handler = nil
    }
}

@available(iOS 16.0, *)
extension EmailVerificationModel: Hashable {
    static func == (lhs: EmailVerificationModel, rhs: EmailVerificationModel) -> Bool {
        if let lhsHandler = lhs.handler, let rhsHandler = rhs.handler {
            return lhs.confirmationCode == rhs.confirmationCode && lhs.displayConfirmationCodeErrMsg == rhs.displayConfirmationCodeErrMsg && lhs.registering == rhs.registering && ObjectIdentifier(lhsHandler) == ObjectIdentifier(rhsHandler)
        } else {
            return false
        }
        
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(confirmationCode)
        hasher.combine(displayConfirmationCodeErrMsg)
        hasher.combine(registering)
        if let handler {
            hasher.combine(ObjectIdentifier(handler))
        }
    }
}

@available(iOS 16.0, *)
protocol EmailVerificationModelDelegate: AnyObject {
    var model: EmailVerificationModel? {get set}
    var registrationRequestCancellable: AnyCancellable? {get}
    func register(code: String) -> Void
    func resetRegistrationStatus() -> Void
}

@available(iOS 16.0, *)
class EmailVerificationModelHandlerDefault: EmailVerificationModelDelegate {
    weak var model: EmailVerificationModel?
    private var registrationService: RegistrationService
    private var errorMapper = UIErrorMapper()
    private var generalUIEffectManager: GeneralUIEffectManager
    
    private var requestingRegistration = false
    var registrationRequestCancellable: AnyCancellable?
    
    init(model: EmailVerificationModel, registrationService: RegistrationService, generalUIEffectManager: GeneralUIEffectManager) {
        self.model = model
        self.registrationService = registrationService
        self.generalUIEffectManager = generalUIEffectManager
    }
    
    func register(code: String) -> Void {
        guard self.requestingRegistration == false else {
            var effect = GeneralUIEffect()
            effect.action = .alert
            effect.message = "There is already a registration attempt under way"
            self.generalUIEffectManager.newEffect(effect)
            return
        }
        self.requestingRegistration = true
        self.model?.registering = true
        self.registrationRequestCancellable = self.registrationService.register(confirmationCode: code)
            .receive(on: DispatchQueue.main)
            .sink { result in
                self.requestingRegistration = false
                self.model?.registering = false
                switch result {
                case .success():
                    print("email verified")
                case .failure(let clientError):
                    let effect = self.errorMapper.mapError(clientError)
                    self.generalUIEffectManager.newEffect(effect)
                }
            }
    }
    
    func resetRegistrationStatus() {
        self.registrationService.resetRegistrationStatus()
    }
}
