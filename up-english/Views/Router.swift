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
            let loginModel = self.createPageModel(PageInfo(page: .Login))
            path.append(loginModel)
        }
    }
    
    @Published var path = NavigationPath()
    
    private func createPageModel(_ pageInfo: PageInfo) -> any Hashable {
        switch pageInfo.page {
        case .Registration:
            let model = RegistrationModel()
            model.email = pageInfo.registrationPageContent?.email ?? ""
            model.password1 = pageInfo.registrationPageContent?.password ?? ""
            let handler = RegistrationModelHandlerDefault(model: model, userService: services.userService, registrationService: services.registrationService, router: self, errorMapper: uiErrorMapper, generalUIEffectManager: self.generalUIEffectManager)
            model.setHandler(handler: handler)
            return model
        case .EmailVerification:
            let model = EmailVerificationModel()
            model.confirmationCode = pageInfo.emailVerificationPageContent?.confirmationCode ?? ""
            let handler = EmailVerificationModelHandlerDefault(model: model, registrationService: services.registrationService, router: self, errorMapper: uiErrorMapper, generalUIEffectManager: generalUIEffectManager)
            model.setHandler(handler)
            return model
        case .Login:
            let model = LoginModel()
            model.email = pageInfo.loginPageContent?.email ?? ""
            model.password = pageInfo.loginPageContent?.password ?? ""
            let handler = LoginModelHandlerDefault(model: model, userService: services.userService, router: self, errorMapper: uiErrorMapper, generalUIEffectManager: generalUIEffectManager)
            model.setHandler(handler)
            return model
        case .Home:
            return ArticleOpenerModel()
        }
    }
    
    func clearStackAndGoTo(page pageInfo: PageInfo) {
        path.removeLast(path.count)
        let model = createPageModel(pageInfo)
        path.append(model)
    }
    func append(page pageInfo: PageInfo) {
        let model = createPageModel(pageInfo)
        path.append(model)
    }
    
    func replaceLastPageWith(_ pageInfo: PageInfo) {
        path.removeLast()
        let model = createPageModel(pageInfo)
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

