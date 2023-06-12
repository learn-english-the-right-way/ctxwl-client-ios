//
//  SettingsView.swift
//  up-english
//
//  Created by James Tsai on 1/13/23.
//

import SwiftUI

@available(iOS 15.0, *)
struct SettingsView: View {
    
    @ObservedObject var model: SettingsViewModel
    
    var body: some View {
        VStack {
            Button("Logout") {
                model.logout()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

@available(iOS 15.0, *)
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: SettingsViewModel())
    }
}
