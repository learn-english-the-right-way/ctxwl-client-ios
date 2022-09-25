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
    
    private var userService: any UserService
    
    private var router: Router
    
    private var loginRequestCancellable: AnyCancellable?
    
    private var requestAggregator: RequestAggregator
    
    @Published var loginUnderway: Bool = false
    
    @Published var loginSuccess: Bool = false
    
    @Published var email: String = ""
    
    @Published var password: String = ""
    
    @Published var effect: UIEffect
    
    init(userService: any UserService, router: Router, requestAggregator: RequestAggregator) {
        self.userService = userService
        self.router = router
        self.requestAggregator = requestAggregator
        self.effect = UIEffect()
    }
    
    func login() -> Void {
        // do nothing if there is an ongoing
        guard !self.loginUnderway else {
            var effect = UIEffect()
            effect.action = .notice
            effect.message = "There is a login request under way"
            self.effect = effect
            return
        }
        //TODO: since emitted is never, change the type of sink
        self.loginRequestCancellable = self.requestAggregator.login()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {completion in self.loginUnderway = false},
                  receiveValue: {effect in self.effect = effect}
            )
    }
}
