//
//  EmailVerification.swift
//  up-english
//
//  Created by James Tsai on 5/2/21.
//

import SwiftUI

struct EmailVerification<ModelType>: View where ModelType: EmailVerificationModel {
    
    @ObservedObject private var model: ModelType
    
    init(model: ModelType) {
        self.model = model
    }
    
    var body: some View {
        VStack {
            Button("Go Back") {
                model.reset()
            }
            HStack {
                Text("Confirmation Code")
                TextField("Confirmation code", text: $model.confirmationCode)
            }
            Button("Verify") {
                model.register()
            }
        }
    }
}

struct EmailVerification_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerification(model: EmailVerificationModelDefault(registrationService: RegistrationServiceDefault(), userService: UserServiceDefault(), viewRouter: ViewRouter()))
    }
}
