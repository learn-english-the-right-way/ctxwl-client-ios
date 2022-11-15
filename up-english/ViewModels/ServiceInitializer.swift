//
//  ServiceInitializerDefualt.swift
//  up-english
//
//  Created by James Cai on 5/10/2022.
//

import Foundation

@available(iOS 16.0, *)
class ServiceInitializer: ObservableObject {
    
    var ctxwlUserSession: CTXWLURLSession
    
    var userService: UserService
    
    var registrationService: RegistrationService
        
    init() {
        self.ctxwlUserSession = CTXWLURLSessionDefault()
        self.userService = UserServiceDefault(ctxwlUrlSession: ctxwlUserSession)
        self.registrationService = RegistrationServiceDefault(ctxwlUrlSession: ctxwlUserSession, userService: userService)
    }
    
}
