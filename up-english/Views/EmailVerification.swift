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
            ZStack {
                Text("Please wait while we finish registering...")
                    .opacity(model.registering ? 1 : 0)
            }
            HStack {
                Text("Confirmation Code")
                TextField("Confirmation code", text: $model.confirmationCode)
            }
            Button("Verify") {
                model.register()
            }
            .disabled(model.verifyButtonDisabled)
        }
    }
}

@available(iOS 16.0, *)
struct EmailVerification_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerification(model: EmailVerificationModel())
    }
}
