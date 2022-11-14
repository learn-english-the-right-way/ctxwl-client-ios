//
//  Registration.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@available(iOS 16.0, *)
struct Registration: View {
    
    @ObservedObject var model: RegistrationModel

    var body: some View {
        VStack {
            Text("Sending verification email...")
                .opacity(model.requestingConfirmationCode ? 1 : 0)
            HStack {
                Text("Email:")
                TextField("Email address", text: $model.email)
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disabled(model.requestingConfirmationCode)
            }
            Text(model.emailErrorMsg)
            HStack {
                Text("Password:")
                TextField("Password", text: $model.password1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
                    .disabled(model.requestingConfirmationCode)
            }
            Text(model.password1ErrorMsg)
            HStack {
                Text("Password:")
                TextField("Confirm password", text: $model.password2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .padding()
                .disabled(model.requestingConfirmationCode)

            }
            Text(model.password2ErrorMsg)
            Button("Register") {
                model.requestConfirmationCode()
            }
            .disabled(
                model.validationFailed ||
                model.requestingConfirmationCode
            )
            Button("Login") {
                model.switchToLoginPage()
            }
        }
    }
}

struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
