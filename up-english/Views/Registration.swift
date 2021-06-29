//
//  Registration.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

struct Registration<ModelType>: View where ModelType: RegistrationModel {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var showEmailErrorMsg: Bool = false
    @State var showPassword2ErrorMsg: Bool = false
    @ObservedObject private var registrationModel: ModelType
    
    init(model: ModelType) {
        self.registrationModel = model
    }

    var body: some View {
        VStack {
            Text("Sending verification email...")
                .opacity(registrationModel.requestingConfirmationCode ? 1 : 0)
            HStack {
                Text("Email:")
                TextField("Email address", text: $registrationModel.email) { isEditing in
                    self.showEmailErrorMsg = isEditing
                }
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            Text(registrationModel.emailErrorMsg)
                .opacity(self.showEmailErrorMsg ? 0 : 1)
            HStack {
                Text("Password:")
                TextField("Password", text: $registrationModel.password1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding()
            }
            Text(registrationModel.password1ErrorMsg)
            HStack {
                Text("Password:")
                TextField("Confirm password", text: $registrationModel.password2) { isEditing in
                    showPassword2ErrorMsg = !isEditing
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .padding()

            }
            Text(registrationModel.password2ErrorMsg)
                .opacity(showPassword2ErrorMsg ? 1 : 0)
            Button("Register") {
                registrationModel.requestConfirmationCode()
            }
            .disabled(registrationModel.registrationButtonDisabled)
            .disabled(registrationModel.registering)
            Button("Login") {
                viewRouter.currentPage = .Login
            }
        }
    }
}

struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Registration(model: RegistrationModelDefault(registrationService: RegistrationServiceDefault(), userService: UserServiceDefault(), viewRouter: ViewRouter()))
    }
}
