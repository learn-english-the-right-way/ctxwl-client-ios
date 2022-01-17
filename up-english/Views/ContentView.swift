//
//  ContentView.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

struct ContentView<RegistrationServiceType, UserServiceType>: View where RegistrationServiceType: RegistrationService, UserServiceType: UserService {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @EnvironmentObject var registrationService: RegistrationServiceType
    
    @EnvironmentObject var userService: UserServiceType
    
    
    @State var test: UITextRange? = nil
    
    var body: some View {
        switch viewRouter.currentPage {
        case .Registration:
            Registration(model: RegistrationModelDefault(registrationService: self.registrationService, userService: self.userService, viewRouter: self.viewRouter))
        case .Login:
            Login(LoginModelDefault(userService: self.userService, viewRouter: self.viewRouter))
        case .Confirmation:
            EmailVerification(model: EmailVerificationModelDefault(registrationService: self.registrationService, userService: self.userService, viewRouter: self.viewRouter))
        case .ArticleList:
            // add main page initialization logic
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<RegistrationServiceDefault, UserServiceDefault>()
            .environmentObject(ViewRouter())
            .environmentObject(RegistrationServiceDefault())
            .environmentObject(UserServiceDefault())
    }
}

