//
//  RegistrationModelDefault.swift
//  up-english
//
//  Created by James Tsai on 5/3/21.
//

import Foundation
import Peppermint
import Combine

@available(iOS 16.0, *)
class RegistrationModel: ObservableObject {

    private var handler: RegistrationModelDelegate?
        
    var confirmationCode = ""
    
    @Published var email = "" {
        didSet {
            checkEmail()
            checkRegistrationButtonStatus()
        }
    }
    
    @Published var emailValid = false
    
    @Published var emailErrorMsg = ""
    
    @Published var password1 = "" {
        didSet {
            checkPassword1()
            checkPassword2()
            checkRegistrationButtonStatus()
        }
    }
    
    @Published var password1ErrorMsg =  ""
    
    @Published var password1Valid = false
    
    @Published var password2 = "" {
        didSet {
            checkPassword1()
            checkPassword2()
            checkRegistrationButtonStatus()
        }
    }
    
    @Published var password2Valid = false
    
    @Published var password2ErrorMsg = ""
    
    @Published var validationFailed = true
    
    @Published var requestingConfirmationCode = false
                        
    private func checkEmail() -> Void {
        let predicate = EmailPredicate()
        if email.isEmpty {
            emailValid = false
            emailErrorMsg = ""
        } else if !predicate.evaluate(with: email) {
            emailValid = false
            emailErrorMsg = "This is not a valid email address"
        } else {
            emailValid = true
            emailErrorMsg = ""
        }
    }
    
    private func checkPassword1() -> Void {
        if password1.isEmpty {
            password1Valid = false
            password1ErrorMsg = ""
        } else if password1.count < 8 {
            password1Valid = false
            password1ErrorMsg = "Password must at least be 8 characters long"
        } else {
            password1Valid = true
            password1ErrorMsg = ""
        }
    }
    
    private func checkPassword2() -> Void {
        if password2.isEmpty {
            password2Valid = false
            password2ErrorMsg = ""
        } else if password2 != password1 {
            password2Valid = false
            password2ErrorMsg = "The two passwords are not the same"
        } else {
            password2Valid = true
            password2ErrorMsg = ""
        }
    }
    
    private func checkRegistrationButtonStatus() {
        if emailValid && password1Valid && password2Valid {
            validationFailed = false
        } else {
            validationFailed = true
        }
    }
    
    private func saveCredential() {
        guard let handler = self.handler else {
            print("registration model handler missing, cannot save credential")
            return
        }
        do {
            try handler.saveCredential(username: self.email, password: self.password1)
        } catch {
            var effect = GeneralUIEffect()
            effect.action = .alert
            effect.message = "saving credential to persistence failed"
        }
    }
    
    func switchToLoginPage() {
        guard let handler = self.handler else {
            print("registration model handler missing, cannot switch to login page")
            return
        }
        handler.switchToLoginPage(username: self.email, password: self.password1)
    }
    
    func requestConfirmationCode() -> Void {
        
        // make sure credentials in service is up to date
        self.saveCredential()
        
        guard let handler = self.handler else {
            print("registration model handler missing, cannot request confirmation code")
            return
        }
        
        handler.getRegistrationEmailVerification()
    }
    
    func setHandler(handler: RegistrationModelDelegate) {
        self.handler = handler
    }
    
    func cleanUp() {
        self.handler?.confirmationCodeRequestCancellable?.cancel()
        self.handler?.model = nil
        self.handler = nil
    }

}

@available(iOS 16.0, *)
extension RegistrationModel: Hashable {
    static func == (lhs: RegistrationModel, rhs: RegistrationModel) -> Bool {
        if let lhsHandler = lhs.handler, let rhsHandler = rhs.handler {
            return lhs.email == rhs.email && lhs.password1 == rhs.password1 && lhs.password2 == rhs.password2 && ObjectIdentifier(lhsHandler) == ObjectIdentifier(rhsHandler)
        } else {
            return false
        }
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(confirmationCode)
        hasher.combine(email)
        hasher.combine(emailValid)
        hasher.combine(emailErrorMsg)
        hasher.combine(password1)
        hasher.combine(password1ErrorMsg)
        hasher.combine(password1Valid)
        hasher.combine(password2)
        hasher.combine(password2Valid)
        hasher.combine(password2ErrorMsg)
        hasher.combine(validationFailed)
        hasher.combine(requestingConfirmationCode)
        if let handler {
            hasher.combine(ObjectIdentifier(handler))
        }
    }
}

@available(iOS 16.0, *)
protocol RegistrationModelDelegate: AnyObject {
    var model: RegistrationModel? {get set}
    var confirmationCodeRequestCancellable: AnyCancellable? {get}
    func saveCredential(username: String, password: String) throws -> Void
    func switchToLoginPage(username: String, password: String) -> Void
    func getRegistrationEmailVerification() -> Void
}

@available(iOS 16.0, *)
class RegistrationModelHandlerDefault: RegistrationModelDelegate {
    weak var model: RegistrationModel?
    private var userService: UserService
    private var registrationService: RegistrationService
    private var errorMapper = UIErrorMapper()
    private var generalUIEffectManager: GeneralUIEffectManager
    
    private var requestingConfirmationCode = false
    var confirmationCodeRequestCancellable: AnyCancellable?
    
    init(model: RegistrationModel, userService: UserService, registrationService: RegistrationService, generalUIEffectManager: GeneralUIEffectManager) {
        self.model = model
        self.userService = userService
        self.registrationService = registrationService
        self.generalUIEffectManager = generalUIEffectManager
    }
    
    func saveCredential(username: String, password: String) throws {
        try self.userService.saveCredential(username: username, password: password)
    }
    
    func switchToLoginPage(username: String, password: String) {
        var pageInfo = PageInfo(page: .Login)
        pageInfo.loginPageContent = LoginPageContent(email: username, password: password)
    }
    
    func getRegistrationEmailVerification() -> Void {
        guard self.requestingConfirmationCode == false else {
            var effect = GeneralUIEffect()
            effect.action = .alert
            effect.message = "There is a request to get verification code going on"
            self.generalUIEffectManager.newEffect(effect)
            return
        }
        self.requestingConfirmationCode = true
        self.model?.requestingConfirmationCode = true
        
        self.confirmationCodeRequestCancellable = self.registrationService.requestEmailConfirmation()
            .receive(on: DispatchQueue.main)
            .sink { result in
                self.requestingConfirmationCode = false
                self.model?.requestingConfirmationCode = false
                switch result {
                case .success():
                    print("success")
                case .failure(let error):
                    let effect = self.errorMapper.mapError(error)
                    self.generalUIEffectManager.newEffect(effect)
                }
            }
    }
}
