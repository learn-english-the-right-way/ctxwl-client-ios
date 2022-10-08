//
//  NotificationController.swift
//  up-english
//
//  Created by James Cai on 4/10/2022.
//

import Foundation

class GeneralUIEffectManager: ObservableObject {
    
    @Published var showNotice: Bool = false
    
    @Published var noticeContent: String = ""
    
    @Published var showAlert: Bool = false
    
    @Published var alertContent: String = ""
    
    func newEffect(_ effect: GeneralUIEffect) {
        if effect.action == .notice {
            self.noticeContent = effect.message ?? ""
            self.showNotice = true
        }
        if effect.action == .alert {
            self.alertContent = effect.message ?? ""
            self.showAlert = true
        }
    }
}
