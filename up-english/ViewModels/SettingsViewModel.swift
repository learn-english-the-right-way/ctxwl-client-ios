//
//  SettingsViewModel.swift
//  up-english
//
//  Created by James Cai on 2/26/23.
//

import Foundation
import WordexServices

class SettingsViewModel: ObservableObject {
    
    var handler: SettingsViewModelHandler?
    
    func logout() {
        self.handler?.logout()
    }
}

class SettingsViewModelHandler {
    private var userService: UserService
    init(_ userService: UserService) {
        self.userService = userService
    }
    func logout() {
        self.userService.logout()
    }
}
