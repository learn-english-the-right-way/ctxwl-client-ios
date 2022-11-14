//
//  PageInfo.swift
//  up-english
//
//  Created by James Tsai on 8/13/22.
//

import Foundation

enum Page: Codable, Hashable, Equatable {
    case Registration
    case EmailVerification
    case Login
    case Home
}

struct RegistrationPageContent: Codable, Hashable {
    var email: String
    var password: String
}

struct EmailVerificationPageContent: Codable, Hashable {
    var confirmationCode: String
}

struct LoginPageContent: Codable, Hashable {
    var email: String
    var password: String
}

struct HomePageContent: Codable, Hashable {
    
}

struct PageInfo: Codable, Hashable {
    var page: Page
    var registrationPageContent: RegistrationPageContent?
    var emailVerificationPageContent: EmailVerificationPageContent?
    var loginPageContent: LoginPageContent?
    var homePageContent: HomePageContent?
}
