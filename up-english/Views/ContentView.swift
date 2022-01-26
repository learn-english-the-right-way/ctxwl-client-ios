//
//  ContentView.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

struct ContentView<RegistrationServiceType, UserServiceType, ArticleListServiceType>: View where RegistrationServiceType: RegistrationService, UserServiceType: UserService, ArticleListServiceType: ArticleListService {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @EnvironmentObject var registrationService: RegistrationServiceType
    
    @EnvironmentObject var userService: UserServiceType
    
    @EnvironmentObject var articleListService: ArticleListServiceType
    
    @State var test: UITextRange? = nil
    
    var body: some View {
        switch viewRouter.currentPage {
        case .Registration:
            Registration(
                model: RegistrationModelDefault(
                    registrationService: self.registrationService,
                    userService: self.userService,
                    viewRouter: self.viewRouter
                )
            )
        default:
            abort()
//        case .Login:
//            Login(
//                LoginModelDefault(
//                    userService: self.userService,
//                    viewRouter: self.viewRouter
//                )
//            )
//        case .Confirmation:
//            EmailVerification(
//                model: EmailVerificationModelDefault(
//                    registrationService: self.registrationService,
//                    userService: self.userService,
//                    viewRouter: self.viewRouter
//                )
//            )
//        case .ArticleList:
//            // add main page initialization logic
//            ArticleList(
//                articleListModel: ArticleListModelDefault(articleService: ArticleListServiceMockup())
//            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<RegistrationServiceDefault, UserServiceDefault, ArticleListServiceMockup>()
            .environmentObject(ViewRouter())
            .environmentObject(RegistrationServiceDefault())
            .environmentObject(UserServiceDefault())
            .environmentObject(ArticleListServiceMockup())
    }
}

