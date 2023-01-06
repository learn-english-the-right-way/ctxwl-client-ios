//
//  Login.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@available(iOS 16.0, *)
struct Login: View {
        
    @ObservedObject var model: LoginModel
    
    var body: some View {
        VStack {
            ZStack {
                Text("Please wait while we log you in...")
                    .opacity(model.loginUnderway ? 1 : 0)
            }

            HStack {
                Text("Email:")
                TextField("Email address", text: $model.email)
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Text(model.emailErrorMsg)
            HStack {
                Text("Password:")
                TextField("Password", text: $model.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
            }
        }
        VStack {
            Button("Login") {
                model.login()
            }
            .buttonStyle(.borderedProminent)
            .disabled(model.loginButtonDisabled)
        }
    }
}

@available(iOS 16.0, *)
struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(model: LoginModel())
    }
}
