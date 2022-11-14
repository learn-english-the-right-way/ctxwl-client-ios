//
//  Router.swift
//  up-english
//
//  Created by James Tsai on 8/13/22.
//

import Foundation
import SwiftUI

@available(iOS 16.0, *)
class Router: ObservableObject {
    
    private var services: ServiceInitializer
    
    private var generalUIEffectManager: GeneralUIEffectManager
    
    private var uiErrorMapper: UIErrorMapper
    
    init(services: ServiceInitializer, generalUIEffectManager: GeneralUIEffectManager, uiErrorMapper: UIErrorMapper) {
        self.services = services
        self.generalUIEffectManager = generalUIEffectManager
        self.uiErrorMapper = uiErrorMapper
        
        if self.services.userService.applicationKey == nil {
            let loginModel = self.createPageModel(page: .Login)
            path.append(loginModel)
        }
    }
    
    @Published var path = NavigationPath()
    
    private func createPageModel(page: Page) -> any Hashable {
        switch page {
        case .Registration:
            let model = RegistrationModel()
            let handler = RegistrationModelHandlerDefault(model: model, userService: services.userService, registrationService: services.registrationService, router: self, errorMapper: uiErrorMapper, generalUIEffectManager: self.generalUIEffectManager)
            model.setHandler(handler: handler)
            return model
        case .EmailVerification:
            let model = EmailVerificationModel()
            let handler = EmailVerificationModelHandlerDefault(model: model, registrationService: services.registrationService, router: self, errorMapper: uiErrorMapper, generalUIEffectManager: generalUIEffectManager)
            model.setHandler(handler)
            return model
        case .Login:
            let model = LoginModel()
            let handler = LoginModelHandlerDefault(model: model, userService: services.userService, router: self, errorMapper: uiErrorMapper, generalUIEffectManager: generalUIEffectManager)
            model.setHandler(handler)
            return model
        case .Home:
            // TODO: add homepage model
            return ViewModelBase(page: page)
        }
    }
    
    func clearStackAndGoTo(page pageInfo: PageInfo) {
        path.removeLast(path.count)
        let model = createPageModel(page: pageInfo.page)
        path.append(model)
    }
    func append(page pageInfo: PageInfo) {
        let model = createPageModel(page: pageInfo.page)
        path.append(model)
    }
    
    func back() {
        path.removeLast(1)
    }
    
//    func onHomepageAppear() {
//        if self.services.userService.applicationKey == nil {
//            let loginModel = self.createPageModel(page: .Login)
//            path.append(loginModel)
//        }
//    }
}

