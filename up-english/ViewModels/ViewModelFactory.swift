//
//  ViewModelFactory.swift
//  up-english
//
//  Created by James Tsai on 12/31/22.
//

import Foundation

@available(iOS 16.0, *)
class ViewModelFactory: ObservableObject {
    private var serviceRepository: ServiceInitializer
    private var generalUIEffectManager: GeneralUIEffectManager
    private var uiErrorMapper = UIErrorMapper()
    init(serviceRepository: ServiceInitializer, generalUIEffectManager: GeneralUIEffectManager) {
        self.serviceRepository = serviceRepository
        self.generalUIEffectManager = generalUIEffectManager
    }
    func createRegistrationViewModel() -> RegistrationModel {
        let model = RegistrationModel()
        let handler = RegistrationModelHandlerDefault(model: model, userService: serviceRepository.userService, registrationService: serviceRepository.registrationService, generalUIEffectManager: generalUIEffectManager)
        model.setHandler(handler: handler)
        return model
    }
    func createLoginViewModel() -> LoginModel {
        let model = LoginModel()
        let handler = LoginModelHandlerDefault(userService: serviceRepository.userService, generalUIEffectManager: generalUIEffectManager)
        model.setHandler(handler)
        return model
    }
    func createEmailVerificationModel() -> EmailVerificationModel {
        let model = EmailVerificationModel()
        let handler = EmailVerificationModelHandlerDefault(model: model, registrationService: serviceRepository.registrationService, generalUIEffectManager: generalUIEffectManager)
        model.setHandler(handler)
        return model
    }
    func createHomeModel() -> RecommendationViewModel {
        let model = RecommendationViewModel()
        let handler = RecommendationViewModelFake(model: model)
        model.handler = handler
        return model
    }
    func createArticleOpenerModel(url: String) -> ArticleOpenerModel {
        let model = ArticleOpenerModel(url: url)
        if serviceRepository.articleReadingService == nil {
            serviceRepository.initializeArticleReadingService()
        }
        let handler = ArticleOpenerModelHandler(articleReadingService: serviceRepository.articleReadingService!)
        model.handler = handler
        return model
    }
    func createSettingsModel() -> SettingsViewModel {
        let model = SettingsViewModel()
        let handler = SettingsViewModelHandler(serviceRepository.userService)
        model.handler = handler
        return model
    }
}
