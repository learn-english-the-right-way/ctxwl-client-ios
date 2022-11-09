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
    
    private var handler: LoginModelHandler?
    
    @Published var email: String = ""
    
    @Published var password: String = ""
        
    func switchToRegistrationPage() {
        var pageInfo = PageInfo(page: .Registration)
        pageInfo.registrationPageContent = RegistrationPageContent(email: self.email, password: self.password)
    }
    
    func login() -> Void {
        guard let handler = self.handler else {
            return
        }
        handler.requestLogin(username: self.email, password: self.password)
    }
    
    func setHandler(_ handler: LoginModelHandler) {
        self.handler = handler
    }
}

protocol LoginModelHandler {
    func requestLogin(username: String, password: String) -> Void
}

@available(iOS 16.0, *)
class LogminModelHandlerDefault: LoginModelHandler {
    private var userService: UserService
    private var router: Router
    private var errorMapper: UIErrorMapper
    private var generalUIEffectManager: GeneralUIEffectManager
    
    private var requestingLogin = false
    
    var loginRequestCancellable: AnyCancellable?
    
    init(userService: UserService, router: Router, errorMapper: UIErrorMapper, generalUIEffectManager: GeneralUIEffectManager, requestingLogin: Bool = false, loginRequestCancellable: AnyCancellable? = nil) {
        self.userService = userService
        self.router = router
        self.errorMapper = errorMapper
        self.generalUIEffectManager = generalUIEffectManager
        self.requestingLogin = requestingLogin
        self.loginRequestCancellable = loginRequestCancellable
    }
    
    func requestLogin(username: String, password: String) -> Void {
        do {
            try self.userService.saveCredential(username: username, password: password)
        } catch {
            var effect = GeneralUIEffect()
            effect.action = .alert
            effect.message = "saving credentials failed"
            self.generalUIEffectManager.newEffect(effect)
        }
        guard self.requestingLogin != true else {
            var effect = GeneralUIEffect()
            effect.action = .notice
            effect.message = "There is a login request under way"
            self.generalUIEffectManager.newEffect(effect)
            return
        }
        self.loginRequestCancellable = self.userService.login()
            .sink { result in
                switch result {
                case .success():
                    //TODO: add logic to navigate to homepage
                    print("add logic to navigate to homepage")
                case .failure(let clientError):
                    self.generalUIEffectManager.newEffect(self.errorMapper.mapError(clientError))
                }
            }
    }
}
