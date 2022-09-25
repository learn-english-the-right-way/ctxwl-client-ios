//
//  up_englishApp.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

let server = "ctxwl"

@available(iOS 16.0, *)
@main
struct up_englishApp: App {
    
    @ObservedObject var router: Router
    
    var ctxwlUserSession: CTXWLURLSession
    
    var registrationService: any RegistrationService
    
    var userService: any UserService
    
    var viewFactory: ViewFactory
    
    init() {
        var ctxwlUserSession = CTXWLURLSessionDefault(configuration: URLSessionConfiguration.default, mappers: [ServerErrorMapper()])
        var registrationService = RegistrationServiceDefault(ctxwlUrlSession: ctxwlUserSession)
        var userService = UserServiceDefault(ctxwlUrlSession: ctxwlUserSession)
        var router = Router()
        var viewFactory = ViewFactory(router: router, userService: userService)
        
        self.ctxwlUserSession = ctxwlUserSession
        self.registrationService = registrationService
        self.userService = userService
        self.router = router
        self.viewFactory = viewFactory
        
        if self.userService.applicationKey != nil {
            // TODO: add routing logic to homepage
        } else {
            let loginPage = PageInfo(page: .Login)
            self.router.clearStackAndGoTo(page: loginPage)
        }
    }

    var body: some Scene {
        WindowGroup("CTXWL", id: "CTXWL") {
            NavigationStack(path: self.$router.path) {
                // TODO: change content view to homepage
                ContentView()
                    .navigationDestination(for: PageInfo.self) { pageInfo in
                        self.viewFactory.createViewFor(destination: pageInfo)
                    }
            }
        }
    }
}
