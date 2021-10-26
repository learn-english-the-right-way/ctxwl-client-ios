//
//  up_englishApp.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@main
struct up_englishApp: App {
    
    @StateObject var registrationService = RegistrationServiceDefault()
    
    @StateObject var userService = UserServiceDefault()

    @StateObject var viewRouter = ViewRouter()

    var body: some Scene {
        WindowGroup {
//            ContentView<RegistrationServiceDefault, UserServiceDefault>()
//                .environmentObject(self.viewRouter)
//                .environmentObject(self.registrationService)
//                .environmentObject(self.userService)
            ContentViewMock()
        }
    }
}
