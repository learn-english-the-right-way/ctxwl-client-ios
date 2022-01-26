//
//  ViewRouter.swift
//  up-english
//
//  Created by James Tsai on 5/6/21.
//

import Foundation

class ViewRouter: ObservableObject {
    @Published var currentPage: Page
    init() {
        self.currentPage = .Registration
        
//        if (RegistrationStatus(rawValue: UserDefaults.standard.integer(forKey: "registrationStatus")) == .ConfirmationRequested) {
//            self.currentPage = .Confirmation
//        } else {
//            self.currentPage = .Registration
//        }
    }
}
