//
//  ViewModelFactory.swift
//  up-english
//
//  Created by James Tsai on 12/31/22.
//

import Foundation

@available(iOS 16.0, *)
struct ViewModelFactory {
    private var router: Router
    private var serviceRepository: ServiceInitializer
    private var generalUIEffectManager: GeneralUIEffectManager
    private var uiErrorMapper: UIErrorMapper
    init(services: ServiceInitializer, generalUIEffectManager: GeneralUIEffectManager, uiErrorMapper: UIErrorMapper, router: Router) {
        self.serviceRepository = services
        self.generalUIEffectManager = generalUIEffectManager
        self.uiErrorMapper = uiErrorMapper
        self.router = router
    }
    func createRegistrationViewModel(_ info: RegistrationPageContent) -> RegistrationModel {
        let model = RegistrationModel()
        model.email = info.email
        model.password1 = info.password
        let handler = RegistrationModelHandlerDefault(model: model, userService: serviceRepository.userService, registrationService: serviceRepository.registrationService, router: router, errorMapper: uiErrorMapper, generalUIEffectManager: self.generalUIEffectManager)
        model.setHandler(handler: handler)
        return model
    }
    func createLoginViewModel() -> LoginModel {
        let model = LoginModel()
        model.email = pageInfo.loginPageContent?.email ?? ""
        model.password = pageInfo.loginPageContent?.password ?? ""
        let handler = LoginModelHandlerDefault(model: model, userService: services.userService, router: self, errorMapper: uiErrorMapper, generalUIEffectManager: generalUIEffectManager)
        model.setHandler(handler)
        return model
    }
    func createEmailVerificationModel() -> EmailVerificationModel
    func createHomeModel() -> HomeModel
    func createArticleOpenerModel() -> ArticleOpenerModel
}
