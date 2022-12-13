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
    
    @Published var confirmationCode = "" {
        didSet(value) {
            if value != "" {
                verifyButtonDisabled = false
            } else {
                verifyButtonDisabled = true
            }
        }
    }
        
    @Published var displayConfirmationCodeErrMsg = false
    
    @Published var registering = false
    
    @Published var verifyButtonDisabled = true
    
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
protocol EmailVerificationModelHandler: AnyObject {
    var model: EmailVerificationModel? {get set}
    var registrationRequestCancellable: AnyCancellable? {get}
    func register(code: String) -> Void
}

@available(iOS 16.0, *)
class EmailVerificationModelHandlerDefault: EmailVerificationModelHandler {
    var model: EmailVerificationModel?
    private var registrationService: RegistrationService
    private var router: Router
    private var errorMapper: UIErrorMapper
    private var generalUIEffectManager: GeneralUIEffectManager
    
    private var requestingRegistration = false
    var registrationRequestCancellable: AnyCancellable?
    
    init(model: EmailVerificationModel, registrationService: RegistrationService, router: Router, errorMapper: UIErrorMapper, generalUIEffectManager: GeneralUIEffectManager) {
        self.model = model
        self.registrationService = registrationService
        self.router = router
        self.errorMapper = errorMapper
        self.generalUIEffectManager = generalUIEffectManager
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
        self.model?.registering = true
        self.registrationRequestCancellable = self.registrationService.register(confirmationCode: code)
            .receive(on: DispatchQueue.main)
            .sink { result in
                self.requestingRegistration = false
                self.model?.registering = false
                switch result {
                case .success():
                    let pageInfo = PageInfo(page: .Home)
                    self.router.clearStackAndGoTo(page: pageInfo)
                case .failure(let clientError):
                    let effect = self.errorMapper.mapError(clientError)
                    self.generalUIEffectManager.newEffect(effect)
                }
            }
    }
}
