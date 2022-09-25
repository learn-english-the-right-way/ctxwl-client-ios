//
//  ViewFactory.swift
//  up-english
//
//  Created by James Tsai on 8/13/22.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
class ViewFactory {
    
    var router: Router
    
    var userService: any UserService
    
    var registrationService: any RegistrationService
    
    init(router: Router, userService: any UserService) {
        self.router = router
        self.userService = userService
    }
    
    @ViewBuilder
    func createViewFor(destination: PageInfo) -> some View {
        switch destination.page {
        case .Registration:
            Registration(model: RegistrationModel(registrationService: self.registrationService, userService: self.userService, router: self.router))
        case .EmailVerification:
            EmailVerification(model: EmailVerificationModel(registrationService: self.registrationService, userService: self.userService, router: self.router))
        case .Login:
            Login(LoginModel(userService: self.userService, router: router))
        case .Home:
            // TODO: add homepage initiation code
            Text("placeholder view here")
        }
    }
}
