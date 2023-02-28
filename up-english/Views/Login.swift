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
            VStack() {
                VStack(alignment: .leading) {
                    TextField("Email", text: $model.email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(model.emailErrorMsg)
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .onChange(of: model.email) { newState in
                    model.checkEmail()
                    model.checkLoginButtonStatus()
                }
                SecureField("Password", text: $model.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .onChange(of: model.password) { newState in
                        model.checkLoginButtonStatus()
                    }
            }
            .padding([.leading, .trailing], 27.5)

            Button() {
                model.login()
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding([.leading, .trailing, .top], 27.5)
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
