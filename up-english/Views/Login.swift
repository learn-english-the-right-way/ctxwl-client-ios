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
            VStack(alignment: .leading, spacing: 15) {
                TextField("Email", text: $model.email)
                    .padding()
                    .cornerRadius(10)
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $model.password)
                    .padding()
                    .cornerRadius(10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            }
            .padding([.leading, .trailing], 27.5)

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
