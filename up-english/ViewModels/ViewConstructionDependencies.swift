//
//  ViewConstructionDependencies.swift
//  up-english
//
//  Created by James Cai on 8/10/2022.
//

import Foundation

@available(iOS 16.0, *)
class ViewConstructionDependencies: ObservableObject {
    
    var router: Router
    var serviceInitializer: ServiceInitializer
    var requestAggregator: RequestAggregator
    var uiErrorMapper: UIErrorMapper
    var generalUIEffectManager: GeneralUIEffectManager
    
    init(router: Router, serviceInitializer: ServiceInitializer, generalUIEffectManager: GeneralUIEffectManager) {
        self.router = router
        self.serviceInitializer = serviceInitializer
        self.uiErrorMapper = UIErrorMapperDefault()
        self.requestAggregator = RequestAggregator(userService: self.serviceInitializer.userService, registrationService: self.serviceInitializer.registrationService, uiErrorMapper: self.uiErrorMapper, router: router)
        self.generalUIEffectManager = generalUIEffectManager
    }
    
}
