//
//  EmailVerification.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

@available(iOS 16.0, *)
struct EmailVerification: View {
    
    @ObservedObject var model: EmailVerificationModel
    
    var body: some View {
        VStack {
            TextField("Confirmation code", text: $model.confirmationCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .padding([.leading, .trailing], 27.5)
                .onChange(of: model.confirmationCode) {newCode in
                    model.checkButtonStatus()
                }
        }
        Button() {
            model.register()
        } label: {
            Text("Verify")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding([.leading, .trailing, .top], 27.5)
        .disabled(model.isButtonDisabled)
        Button("Cancel") {
            model.reset()
        }
        .padding([.leading, .trailing, .top], 27.5)
    }
}

@available(iOS 16.0, *)
struct EmailVerification_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerification(model: EmailVerificationModel())
    }
}
