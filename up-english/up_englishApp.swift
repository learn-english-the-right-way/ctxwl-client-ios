//
//  up_englishApp.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@available(iOS 16.0, *)
@main
struct up_englishApp: App {
    
    var services = ServiceInitializer()
    
//    var router: Router
            
    var uiErrorMapper = UIErrorMapper()
    
    var viewModelFactory: ViewModelFactory
    
    init() {
        self.viewModelFactory = ViewModelFactory(serviceRepository: services)
//        self.router = Router(services: self.initializer, generalUIEffectManager: self.generalUIEffectManager, uiErrorMapper: self.uiErrorMapper)
    }
    
    var body: some Scene {
        WindowGroup("CTXWL", id: "CTXWL") {
            ContentView()
                .environmentObject(services)
                .environmentObject(viewModelFactory)
//                .environmentObject(self.router)
        }
    }
}
