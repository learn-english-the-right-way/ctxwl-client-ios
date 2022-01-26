//
//  up_englishApp.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@main
struct up_englishApp: App {
    
    var registrationService = RegistrationServiceDefault()
    
    var userService = UserServiceDefault()

    var viewRouter = ViewRouter()
    
//    var articleListService = ArticleListServiceMockup()

    var body: some Scene {
        WindowGroup {
            ContentView<RegistrationServiceDefault, UserServiceDefault, ArticleListServiceMockup>()
                .environmentObject(self.viewRouter)
                .environmentObject(self.registrationService)
                .environmentObject(self.userService)
//                .environmentObject(self.articleListService)
//            if #available(iOS 15.0, *) {
//                ContentViewMock()
//            } else {
//                // Fallback on earlier versions
//            }
        }
    }
}
