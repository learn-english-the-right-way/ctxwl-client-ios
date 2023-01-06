//
//  ContentView.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    
    @State var notLoggedIn: Bool = true
    
    @EnvironmentObject var services: ServiceInitializer
    @EnvironmentObject var viewModelFactory: ViewModelFactory
        
    var body: some View {
        HomeView(model: viewModelFactory.createHomeModel())
            .fullScreenCover(isPresented: $notLoggedIn) {
                LoginOrSignupView()
            }
            .onReceive(services.userService.loggedIn) {
                self.notLoggedIn = !$0
            }
        
//        NavigationStack(path: self.$router.path) {
//            // TODO: change empty view to home view
//            EmptyView()
//                .navigationDestination(for: LoginModel.self) { model in
//                    Login(model: model)
//                        .id(model)
//                        .navigationBarBackButtonHidden()
//                }
//                .navigationDestination(for: RegistrationModel.self) { model in
//                    Registration(model: model)
////                        .id(model)
//                        .navigationBarBackButtonHidden()
//                }
//                .navigationDestination(for: EmailVerificationModel.self) {model in
//                    EmailVerification(model: model)
//                        .id(model)
//                }
//                .navigationDestination(for: HomeModel.self) {model in
//                    HomeView(model: model)
//                        .id(model)
//                        .navigationBarBackButtonHidden()
//                }
//                .navigationDestination(for: ArticleOpenerModel.self) { model in
//                    ArticleOpener(model: model)
//                        .id(model)
//                }
//        }
//        .noticeBanner(self.generalUIEffetManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("empty")
    }
}

