//
//  ViewFactory.swift
//  up-english
//
//  Created by James Tsai on 8/13/22.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
struct ViewFactory {
    
    var dependencies: ViewConstructionDependencies
    
    @ViewBuilder
    func createViewFor(destination: PageInfo) -> some View {
        switch destination.page {
        case .Registration:
            let model = RegistrationModel(requestAggregator: self.dependencies.requestAggregator, registrationService: self.dependencies.serviceInitializer.registrationService, userService: self.dependencies.serviceInitializer.userService, errorMapper: self.dependencies.uiErrorMapper)
            Registration(model: model)
        case .EmailVerification:
            let model = EmailVerificationModel(registrationService: self.dependencies.serviceInitializer.registrationService, router: self.dependencies.router, requestAggregator: self.dependencies.requestAggregator, errorMapper: self.dependencies.uiErrorMapper)
            EmailVerification(model: model)
        case .Login:
            let model = LoginModel(requestAggregator: self.dependencies.requestAggregator, errorMapper: self.dependencies.uiErrorMapper, userService: self.dependencies.serviceInitializer.userService)
            Login(model)
        case .Home:
            // TODO: add homepage initiation code
            Text("placeholder view here")
        }
    }
}
