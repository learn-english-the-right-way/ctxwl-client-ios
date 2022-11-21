//
//  ContentView.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
        
    @EnvironmentObject var router: Router
    
    @EnvironmentObject var generalUIEffetManager: GeneralUIEffectManager
        
    var body: some View {
        NavigationStack(path: self.$router.path) {
            // TODO: change empty view to home view
            EmptyView()
                .navigationDestination(for: LoginModel.self) { model in
                    Login(model: model)
                        .navigationBarBackButtonHidden()
                }
                .navigationDestination(for: RegistrationModel.self) { model in
                    Registration(model: model)
                        .navigationBarBackButtonHidden()
                }
                .navigationDestination(for: EmailVerificationModel.self) {model in
                    EmailVerification(model: model)
                }
                .navigationDestination(for: ArticleOpenerModel.self) { model in
                    ArticleOpener()
                }
        }
        .noticeBanner(self.generalUIEffetManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("empty")
    }
}

