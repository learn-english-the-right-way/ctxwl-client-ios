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
    
    private var userService: any UserService
    
    private var registrationService: any RegistrationService
    
    private var uiErrorMapper: UIErrorMapper
    
    private var router: Router
    
    init(userService: any UserService, registrationService: any RegistrationService, uiErrorMapper: UIErrorMapper, router: Router) {
        self.userService = userService
        self.registrationService = registrationService
        self.uiErrorMapper = uiErrorMapper
        self.router = router
    }
    
    func login() -> AnyPublisher<UIEffect, Never> {
        
        let loginPublisher = self.userService.login().share()
        
        let cancellable = loginPublisher.sink(receiveCompletion: { _ in }, receiveValue: { value in
            let homePageInfo = PageInfo(page: .Home)
            self.router.clearStackAndGoTo(page: homePageInfo)
        })
        
        return loginPublisher
            .flatMap{ value -> Empty<UIEffect, Never> in
                Empty<UIEffect, Never>(completeImmediately: true)
            }
            .catch { error in
                let mappedError = self.uiErrorMapper.mapError(error)
                return Just(mappedError)
            }
            .eraseToAnyPublisher()
    }
    
    func getRegistrationEmailVerification() -> AnyPublisher<UIEffect, Never> {
        
        let publisher = self.registrationService.requestEmailConfirmation().share()
        
        let cancellable = publisher.sink(receiveCompletion: { _ in }, receiveValue: { value in
            let emailVerificationPage = PageInfo(page: .EmailVerification)
            self.router.append(page: emailVerificationPage)
        })
        
        return publisher
            .flatMap{ value -> Empty<UIEffect, Never> in
                Empty<UIEffect, Never>(completeImmediately: true)
            }
            .catch { error in
                let mappedError = self.uiErrorMapper.mapError(error)
                return Just(mappedError)
            }
            .eraseToAnyPublisher()
    }
    
    func register(code: String) -> AnyPublisher<UIEffect, Never> {
        
        let publisher = self.registrationService.register(confirmationCode: code).share()
        
        let cancellable = publisher.sink(receiveCompletion: {_ in}, receiveValue: {value in
            let homepage = PageInfo(page: .Home)
            self.router.clearStackAndGoTo(page: homepage)
        })
        
        return publisher
            .flatMap{ value -> Empty<UIEffect, Never> in
                Empty<UIEffect, Never>(completeImmediately: true)
            }
            .catch { error in
                let mappedError = self.uiErrorMapper.mapError(error)
                return Just(mappedError)
            }
            .eraseToAnyPublisher()
    }
    
}
