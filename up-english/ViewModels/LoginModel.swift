//
//  LoginModelDefault.swift
//  up-english
//
//  Created by James Tsai on 7/19/21.
//

import Foundation
import Combine

@available(iOS 16.0, *)
class LoginModel: ObservableObject {
    
    private var router: Router
            
    private var loginRequestCancellable: AnyCancellable?
    
    private var loginServiceErrorsCancellable: AnyCancellable?
    
    private var requestAggregator: RequestAggregator
    
    private var uiErrorMapper: UIErrorMapper
    
    private var userService: UserService
    
    @Published var loginUnderway: Bool = false
    
    @Published var loginSuccess: Bool = false
    
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    @Published var effect: GeneralUIEffect
    
    init(requestAggregator: RequestAggregator, errorMapper: UIErrorMapper, userService: UserService) {
        self.requestAggregator = requestAggregator
        self.router = requestAggregator.router
        self.uiErrorMapper = errorMapper
        self.userService = userService
        self.effect = GeneralUIEffect()
        
        self.loginServiceErrorsCancellable = self.userService.errorsPublisher.sink(receiveValue: {clientError in
            self.effect = self.uiErrorMapper.mapError(clientError)
        })
    }
    
    func switchToRegistrationPage() {
        var pageInfo = PageInfo(page: .Registration)
        pageInfo.registrationPageContent = RegistrationPageContent(email: self.email, password: self.password)
    }
    
    func login() -> Void {
        // do nothing if there is an ongoing
        guard !self.loginUnderway else {
            var effect = GeneralUIEffect()
            effect.action = .notice
            effect.message = "There is a login request under way"
            self.effect = effect
            return
        }
        
        self.loginRequestCancellable = self.requestAggregator.login()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {completion in self.loginUnderway = false},
                  receiveValue: {effect in self.effect = effect}
            )
    }
}
