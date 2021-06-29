//
//  Login.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        Text("Login")
        Button("Register") {
            viewRouter.currentPage = .Registration
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
