//
//  EmailVerificationModelDefault.swift
//  up-english
//
//  Created by James Tsai on 7/2/21.
//

import Foundation
import Combine

class EmailVerificationModelDefault<RegistrationServiceType, UserServiceType>: EmailVerificationModel where RegistrationServiceType: RegistrationService, UserServiceType: UserService {
    
    var confirmationCode = ""
    
    private var registrationService: RegistrationServiceType
    
    private var userService: UserServiceType
    
    private var viewRouter: ViewRouter
    
    private var registrationRequestCancellable: AnyCancellable?
    
    @Published var registering = false
    
    init(registrationService: RegistrationServiceType, userService: UserServiceType, viewRouter: ViewRouter) {
        self.registrationService = registrationService
        self.userService = userService
        self.viewRouter = viewRouter
    }
    
    func register() {
        guard self.registering else {
            self.registering = true
            self.registrationRequestCancellable = self.registrationService.register(email: self.userService.email, confirmationCode: self.confirmationCode)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: {
                        status in self.registering = false
                        print("registration process \(status)")
                    },
                    receiveValue: {
                        value in
                        self.userService.applicationAuthenticationKey = value.userAuthenticationApplicationKey
                        self.userService.userSessionToken = value.userSessionToken
                        self.userService.userID = value.userID
                    }
                )
            return
        }
    }
    
    func reset() {
        self.registrationService.resetRegistrationStatus()
        viewRouter.currentPage = .Registration
    }
}
