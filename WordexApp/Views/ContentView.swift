//
//  ContentView.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    
    @State var notLoggedIn: Bool = false
    @State var selectedTab = 0
    
    @EnvironmentObject var services: ServiceInitializer
    @EnvironmentObject var viewModelFactory: ViewModelFactory
    @EnvironmentObject var generalUIEffectManager: GeneralUIEffectManager
        
    var body: some View {
        TabView(selection: $selectedTab) {
            ArticleOpener(model: viewModelFactory.createArticleOpenerModel(url: "https://google.com"))
                .tabItem {
                    Label("Browse", systemImage: "globe")
                }
                .tag(1)
            RecommendationView()
                .tabItem {
                    Label("For You", systemImage: "books.vertical")
                }
                .tag(0)
            SettingsView(model: viewModelFactory.createSettingsModel())
                .tabItem {
                    Label("Me", systemImage: "person")
                }
                .tag(2)
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
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

