//
//  RegistrationAndVerificationView.swift
//  up-english
//
//  Created by James Tsai on 12/31/22.
//

import SwiftUI

@available(iOS 16.0, *)
struct RegistrationAndVerificationView: View {
    @State var showVerification: Bool = false
    @EnvironmentObject var viewModelFactory: ViewModelFactory
    @EnvironmentObject var services: ServiceInitializer

    var body: some View {
        VStack {
            if !showVerification {
                Registration(model: viewModelFactory.createRegistrationViewModel())
            } else {
                EmailVerification(model: viewModelFactory.createEmailVerificationModel())
            }
        }
        .onReceive(services.registrationService.requireVerification) {
            showVerification = $0
        }

    }
}

@available(iOS 16.0, *)
struct RegistrationAndVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationAndVerificationView()
    }
}
