//
//  RegistrationModelDefault.swift
//  up-english
//
//  Created by James Tsai on 5/3/21.
//

import Foundation
import Peppermint
import Combine

class RegistrationModelDefault<RegistrationServiceType, UserServiceType>: RegistrationModel where RegistrationServiceType: RegistrationService, UserServiceType: UserService {
    
    private var registrationService: RegistrationServiceType
    
    private var userService: UserServiceType
    
    private var viewRouter: ViewRouter
    
    private var confirmationCodeRequestCancellable: AnyCancellable?
        
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
    
    init(registrationService: RegistrationServiceType, userService: UserServiceType, viewRouter: ViewRouter) {
        self.registrationService = registrationService
        self.userService = userService
        self.viewRouter = viewRouter
        self.email = userService.email
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
    
    func requestConfirmationCode() -> Void {
        
        // do nothing if there is an ongoing confirmation code request
        guard self.requestingConfirmationCode else {
            self.requestingConfirmationCode = true
            self.userService.email = self.email
            self.userService.password = self.password1
            self.confirmationCodeRequestCancellable =
                self.registrationService.requestEmailConfirmation(email: self.userService.email, password: self.userService.password)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: {
                    completion in
                    self.requestingConfirmationCode = false
                    switch completion {
                    case .finished:
                        self.viewRouter.currentPage = .Confirmation
                        UserDefaults.standard.setValue(RegistrationStatus.ConfirmationRequested.rawValue, forKey: "registrationStatus")
                    case .failure:
                        print("failed")
                    }
                },
                      receiveValue: {value in}
                )
            return
        }
    }

}
