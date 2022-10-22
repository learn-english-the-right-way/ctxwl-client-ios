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
    
    @StateObject var initializer = ServiceInitializer()
    
    @StateObject var router = Router()
    
    @StateObject var generalUIEffectManager = GeneralUIEffectManager()
    
    var body: some Scene {
        WindowGroup("CTXWL", id: "CTXWL") {
            ContentView()
                .environmentObject(self.initializer)
                .environmentObject(self.router)
                .environmentObject(self.generalUIEffectManager)
        }
    }
}
