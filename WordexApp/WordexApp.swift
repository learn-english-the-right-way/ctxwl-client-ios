//
//  up_englishApp.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@available(iOS 16.0, *)
@main
struct WordexApp: App {
    
    var services = ServiceInitializer()
                
    var uiErrorMapper = UIErrorMapper()
    
    var viewModelFactory: ViewModelFactory
    
    var generalUIEffectManager = GeneralUIEffectManager()
    
    init() {
        self.viewModelFactory = ViewModelFactory(serviceRepository: services, generalUIEffectManager: self.generalUIEffectManager)
    }
    
    var body: some Scene {
        WindowGroup("CTXWL", id: "CTXWL") {
            ContentView()
                .environmentObject(services)
                .environmentObject(viewModelFactory)
                .environmentObject(generalUIEffectManager)
        }
    }
}
