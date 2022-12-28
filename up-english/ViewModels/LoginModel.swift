//
//  LoginModelDefault.swift
//  up-english
//
//  Created by James Tsai on 7/19/21.
//

import Foundation
import Combine
import Peppermint

@available(iOS 16.0, *)
class LoginModel: ObservableObject {
    
    private var handler: LoginModelHandler?
    
    @Published var email: String = "" {
        didSet {
            checkEmail()
            checkLoginButtonStatus()
        }
    }
    
    @Published var password: String = "" {
        didSet {
            checkLoginButtonStatus()
        }
    }
    
    @Published var loginUnderway = false
    
    @Published var loginButtonDisabled = true
    
    @Published var emailValid = false
    
    @Published var emailErrorMsg = ""
    
    private func checkLoginButtonStatus() {
        if emailValid && password != "" {
            loginButtonDisabled = false
        } else {
            loginButtonDisabled = true
        }
    }
    
    private func checkEmail() -> Void {
        let predicate = EmailPredicate()
        if email.isEmpty {
            emailValid = false
            emailErrorMsg = ""
        } else if !predicate.evaluate(with: email) {
            emailValid = false
            emailErrorMsg = "This is not a valid email address"
        } else {
            emailValid = true
            emailErrorMsg = ""
        }
    }
        
    func switchToRegistrationPage() {
        var pageInfo = PageInfo(page: .Registration)
        pageInfo.registrationPageContent = RegistrationPageContent(email: self.email, password: self.password)
        guard let handler = self.handler else {
            return
        }
        handler.switchToRegistration(pageInfo)
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
    
    func cleanUp() {
        self.handler?.model = nil
        self.handler?.loginRequestCancellable?.cancel()
        self.handler = nil
    }
}

@available(iOS 16.0, *)
extension LoginModel: Hashable {
    static func == (lhs: LoginModel, rhs: LoginModel) -> Bool {
        if let lhsHandler = lhs.handler, let rhsHandler = rhs.handler {
            return lhs.email == rhs.email && lhs.password == rhs.password && lhs.loginUnderway == rhs.loginUnderway && ObjectIdentifier(lhsHandler) == ObjectIdentifier(rhsHandler)
        } else {
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
        hasher.combine(email)
        hasher.combine(password)
        hasher.combine(loginUnderway)
    }
}

@available(iOS 16.0, *)
protocol LoginModelHandler: AnyObject {
    var model: LoginModel? {get set}
    var loginRequestCancellable: AnyCancellable? {get}
    func requestLogin(username: String, password: String) -> Void
    func switchToRegistration(_ registrationPageInfo: PageInfo) -> Void
}

@available(iOS 16.0, *)
class LoginModelHandlerDefault: LoginModelHandler {
    weak var model: LoginModel?
    private var userService: UserService
    private var router: Router
    private var errorMapper: UIErrorMapper
    private var generalUIEffectManager: GeneralUIEffectManager
    
    private var requestingLogin = false
    
    var loginRequestCancellable: AnyCancellable?
    
    init(model: LoginModel, userService: UserService, router: Router, errorMapper: UIErrorMapper, generalUIEffectManager: GeneralUIEffectManager, requestingLogin: Bool = false) {
        self.model = model
        self.userService = userService
        self.router = router
        self.errorMapper = errorMapper
        self.generalUIEffectManager = generalUIEffectManager
        self.requestingLogin = requestingLogin
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
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.loginRequestCancellable = nil
            }) { result in
                switch result {
                case .success():
                    self.router.clearStackAndGoTo(page: PageInfo(page: .Home))
                case .failure(let clientError):
                    self.generalUIEffectManager.newEffect(self.errorMapper.mapError(clientError))
                }
            }
    }
    
    func switchToRegistration(_ registrationPageInfo: PageInfo) {
        self.router.clearStackAndGoTo(page: registrationPageInfo)
    }
}
