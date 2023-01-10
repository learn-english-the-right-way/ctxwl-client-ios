//
//  LoginOrSignupView.swift
//  up-english
//
//  Created by James Tsai on 12/31/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct LoginOrSignupView: View {
    @State var isLogin: Bool = true
    @EnvironmentObject var viewModelFactory: ViewModelFactory
    var body: some View {
        VStack {
            Spacer()
            if isLogin {
                Login(model: viewModelFactory.createLoginViewModel())
            } else {
                RegistrationAndVerificationView()
            }
            Spacer()
            Button("Switch") {
                isLogin.toggle()
            }
        }
    }
}

@available(iOS 16.0, *)
struct LoginOrSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginOrSignupView()
    }
}
