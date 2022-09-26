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
    
    private var requestAggregator: RequestAggregator
    
    private var registrationService: any RegistrationService
    
    private var userService: any UserService
    
    private var uiErrorMapper: UIErrorMapper
        
    private var confirmationCodeRequestCancellable: AnyCancellable?
    
    private var registrationServiceErrorsCancellable: AnyCancellable?
        
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
    
    @Published var registering = false
    
    @Published var showModal: Bool = false
    
    @Published var message: String = ""
    
    @Published var effect: UIEffect
    
    init(requestAggregator: RequestAggregator, registrationService: any RegistrationService, userService: any UserService, errorMapper: UIErrorMapper) {
        self.registrationService = registrationService
        self.userService = userService
        self.requestAggregator = requestAggregator
        self.uiErrorMapper = errorMapper
        self.effect = UIEffect()
        
        self.registrationServiceErrorsCancellable = self.registrationService.errorsPublisher.sink(receiveValue: {clientError in
            self.effect = self.uiErrorMapper.mapError(clientError)
        })
    }
    
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
        do {
            try self.userService.saveCredential(username: self.email, password: self.password1)
        } catch {
            var effect = UIEffect()
            effect.action = .notice
            effect.message = "saving credential to persistence failed"
        }
    }
    
    func requestConfirmationCode() -> Void {
        
        // make sure credentials in service is up to date
        self.saveCredential()
        
        // do nothing if there is an ongoing confirmation code request
        guard self.requestingConfirmationCode == false else {
            var effect = UIEffect()
            effect.action = .notice
            effect.message = "There is a request to get verification code going on"
            self.effect = effect
            return
        }
        self.requestingConfirmationCode = true
        self.confirmationCodeRequestCancellable = self.requestAggregator.getRegistrationEmailVerification()
        // TODO: figure out what this does
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in}, receiveValue: {effect in self.effect = effect})
    }

}
