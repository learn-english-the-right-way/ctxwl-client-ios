//
//  NotificationController.swift
//  up-english
//
//  Created by James Cai on 4/10/2022.
//

import Foundation
import Combine

class GeneralUIEffectManager: ObservableObject {
    
    private var _showAlert = CurrentValueSubject<Bool, Never>(false)
    
    var showAlert: AnyPublisher<Bool, Never> {
        get {
            return self._showAlert.receive(on: DispatchQueue.main).eraseToAnyPublisher()
        }
    }
        
    var alertContent: String = ""
    
    func removeEffect() {
        self._showAlert.send(false)
    }
    
    func newEffect(_ effect: GeneralUIEffect) {
        if effect.action == .alert {
            self.alertContent = effect.message ?? ""
            self._showAlert.send(true)
        }
    }
}
