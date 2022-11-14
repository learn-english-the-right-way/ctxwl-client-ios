//
//  up_englishApp.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

let server = "ctxwl"

@available(iOS 16.0, *)
@main
struct up_englishApp: App {
    
    var initializer: ServiceInitializer
    
    var router: Router
    
    var generalUIEffectManager: GeneralUIEffectManager
        
    var uiErrorMapper: UIErrorMapper
    
    init() {
        self.uiErrorMapper = UIErrorMapper()
        self.initializer = ServiceInitializer()
        self.generalUIEffectManager = GeneralUIEffectManager()
        self.router = Router(services: self.initializer, generalUIEffectManager: self.generalUIEffectManager, uiErrorMapper: self.uiErrorMapper)
    }
    
    var body: some Scene {
        WindowGroup("CTXWL", id: "CTXWL") {
            ContentView()
                .environmentObject(self.initializer)
                .environmentObject(self.router)
                .environmentObject(self.generalUIEffectManager)
                .environmentObject(self.uiErrorMapper)
        }
    }
}
