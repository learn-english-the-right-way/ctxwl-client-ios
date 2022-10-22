//
//  ContentView.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@available(iOS 16.0, *)
struct ContentView: View {
    
    @EnvironmentObject var initializer: ServiceInitializer
    
    @EnvironmentObject var router: Router
    
    @EnvironmentObject var generalUIEffetManager: GeneralUIEffectManager
    
    var body: some View {
        NavigationStack(path: self.$router.path) {
            // TODO: change empty view to home view
            EmptyView()
                .navigationDestination(for: PageInfo.self) { pageInfo in
                    let dependencies = ViewConstructionDependencies(
                        router: self.router,
                        serviceInitializer: self.initializer,
                        generalUIEffectManager: self.generalUIEffetManager
                    )
                    ViewFactory(dependencies: dependencies).createViewFor(destination: pageInfo)
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

