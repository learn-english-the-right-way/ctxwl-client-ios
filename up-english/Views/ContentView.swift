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
//        switch viewRouter.currentPage {
//        case .Registration:
//            Registration(model: RegistrationModelDefault(registrationService: self.registrationService, userService: self.userService, viewRouter: self.viewRouter))
//        case .Login:
//            Login(LoginModelDefault(userService: self.userService, viewRouter: self.viewRouter))
//        case .Confirmation:
//            EmailVerification(model: EmailVerificationModelDefault(registrationService: self.registrationService, userService: self.userService, viewRouter: self.viewRouter))
//        }
//                    ArticleReaderViewRepresentable(text: "not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje not suitable for children under 15 years of age or pregnant soiejfosjfe soijeosiejf soeijfosiejfsoe soiejfosiejfo osiejfosijefoisjef soeijfosiejf soijefoisjefos osijeofisjef soijefosijefosjf soeijfosihefosef oisjefosijeof soiehfosefose siefjesif soeijfosejf soeijfosefj osijeofsje", range: $test)
//                    Text("\(test?.start ?? UITextPosition()), \(test?.end ?? UITextPosition())")
//                    Button("clear") {
//                        test = nil
//                    }
        ScrollViewRepresentable {
            VStack {
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
            }
            VStack {
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
            }
            VStack {
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
            }
            VStack {
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
                Text("fuckfuck")
                Button("wowowo") {
                }
            }
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

