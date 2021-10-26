//
//  LoginModelDefault.swift
//  up-english
//
//  Created by James Tsai on 7/19/21.
//

import Foundation
import Combine

class LoginModelDefault<UserServiceType>: LoginModel where UserServiceType: UserService {
    
    private var userService: UserServiceType
    
    private var viewRouter: ViewRouter
    
    private var loginRequestCancellable: AnyCancellable?
    
    @Published var loginUnderway: Bool = false
    
    @Published var loginSuccess: Bool = false
    
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    init(userService: UserServiceType, viewRouter: ViewRouter) {
        self.userService = userService
        self.viewRouter = viewRouter
    }
    
    func login() -> Void {
        // do nothing if there is an ongoing
        guard self.loginUnderway else {
            //TODO: since emitted is never, change the type of sink
            self.loginRequestCancellable = self.userService.login(email: self.email, password: self.password)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: {
                    completion in
                    self.loginUnderway = false
                    switch completion {
                    case .finished:
                        self.loginSuccess = true
                        //TODO: add view router logic to main page
                        print("login completed")
                    case .failure:
                        print("request login failed")
                    }
                }, receiveValue: {
                    value in
                })
            return
        }
    }
}
