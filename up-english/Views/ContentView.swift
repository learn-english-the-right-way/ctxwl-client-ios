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
    @EnvironmentObject var generalUIEffectManager: GeneralUIEffectManager
        
    var body: some View {
        HomeView(model: viewModelFactory.createHomeModel())
            .fullScreenCover(isPresented: $notLoggedIn) {
                LoginOrSignupView()
                    .noticeBanner()
            }
            .onReceive(services.userService.loggedIn.receive(on: DispatchQueue.main)) {
                self.notLoggedIn = !$0
            }
            .noticeBanner()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("empty")
    }
}

