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
            VStack(alignment: .leading) {
                TextField("Email address", text: $model.email)
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(model.requestingConfirmationCode)
                    .onChange(of: model.email) {newEmail in
                        model.checkEmail()
                        model.checkRegistrationButtonStatus()
                    }
                Text(model.emailErrorMsg)
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding([.leading, .trailing], 27.5)
            VStack(alignment: .leading) {
                SecureField("Password", text: $model.password1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disabled(model.requestingConfirmationCode)
                    .onChange(of: model.password1) {newPassword1 in
                        model.checkPassword1()
                        model.checkRegistrationButtonStatus()
                    }
                Text(model.password1ErrorMsg)
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding([.leading, .trailing], 27.5)
            VStack(alignment: .leading) {
                SecureField("Confirm password", text: $model.password2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disabled(model.requestingConfirmationCode)
                    .onChange(of: model.password2) {newPassword2 in
                        model.checkPassword2()
                        model.checkRegistrationButtonStatus()
                    }
                Text(model.password2ErrorMsg)
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding([.leading, .trailing], 27.5)
            Button() {
                model.requestConfirmationCode()
            } label: {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding([.leading, .trailing, .top], 27.5)
            .disabled(model.validationFailed || model.requestingConfirmationCode)
        }
    }
}

@available(iOS 16.0, *)
struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Registration(model: RegistrationModel())
    }
}
