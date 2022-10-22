//
//  RequestAggregatorDefault.swift
//  up-english
//
//  Created by James Tsai on 7/2/22.
//

import Foundation
import Combine

@available(iOS 16.0, *)
class RequestAggregator {
    
    var userService: UserService
    
    var registrationService: RegistrationService
    
    var uiErrorMapper: UIErrorMapper
    
    var router: Router
    
    init(userService: UserService, registrationService: RegistrationService, uiErrorMapper: UIErrorMapper, router: Router) {
        self.userService = userService
        self.registrationService = registrationService
        self.uiErrorMapper = uiErrorMapper
        self.router = router
    }
    
    func login() -> AnyPublisher<GeneralUIEffect, Never> {
        
        let loginPublisher = self.userService.login().share()
        
        let cancellable = loginPublisher.sink(receiveCompletion: { _ in }, receiveValue: { value in
            let homePageInfo = PageInfo(page: .Home)
            self.router.clearStackAndGoTo(page: homePageInfo)
        })
        
        return loginPublisher
            .flatMap{ value -> Empty<GeneralUIEffect, Never> in
                Empty<GeneralUIEffect, Never>(completeImmediately: true)
            }
            .catch { error in
                let mappedError = self.uiErrorMapper.mapError(error)
                return Just(mappedError)
            }
            .eraseToAnyPublisher()
    }
    
    func getRegistrationEmailVerification() -> AnyPublisher<GeneralUIEffect, Never> {
        
        let publisher = self.registrationService.requestEmailConfirmation().share()
        
        let cancellable = publisher.sink(receiveCompletion: { _ in }, receiveValue: { value in
            let emailVerificationPage = PageInfo(page: .EmailVerification)
            self.router.append(page: emailVerificationPage)
        })
        
        return publisher
            .flatMap{ value -> Empty<GeneralUIEffect, Never> in
                Empty<GeneralUIEffect, Never>(completeImmediately: true)
            }
            .catch { error in
                let mappedError = self.uiErrorMapper.mapError(error)
                return Just(mappedError)
            }
            .eraseToAnyPublisher()
    }
    
    func register(code: String) -> AnyPublisher<GeneralUIEffect, Never> {
        
        let publisher = self.registrationService.register(confirmationCode: code).share()
        
        let cancellable = publisher.sink(receiveCompletion: {_ in}, receiveValue: {value in
            let homepage = PageInfo(page: .Home)
            self.router.clearStackAndGoTo(page: homepage)
        })
        
        return publisher
            .flatMap{ value -> Empty<GeneralUIEffect, Never> in
                Empty<GeneralUIEffect, Never>(completeImmediately: true)
            }
            .catch { error in
                let mappedError = self.uiErrorMapper.mapError(error)
                return Just(mappedError)
            }
            .eraseToAnyPublisher()
    }
    
}
