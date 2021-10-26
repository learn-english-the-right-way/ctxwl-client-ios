//
//  UserServiceDefault.swift
//  up-english
//
//  Created by James Tsai on 5/24/21.
//

import Foundation
import Combine
import UIKit

struct LoginRequest: Codable {
    struct ClientContent: Codable {
        var os: String
        var app: String
        var hardware: String
        var region: String
        var language: String
    }
    var password: String
    var client: ClientContent
    init(password: String, os: String, app: String, hardware: String, region: String, language: String) {
        self.password = password
        self.client = ClientContent(os: os, app: app, hardware: hardware, region: region, language: language)
    }
}

struct LoginResponse: Codable {
    let applicationKey: String
}

class UserServiceDefault: UserService {
    
    private var loginCancellable: AnyCancellable?
    
    var email: String {
        get {
            guard let email = UserDefaults.standard.string(forKey: "email") else {
                return ""
            }
            return email
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "email")
        }
    }
    
    var password: String = ""
    
    var applicationAuthenticationKey: String = ""
    
    func login(email: String, password: String) -> AnyPublisher<Never, Error> {
        
        // store the email and password in user service
        self.email = email
        self.password = password
        
        // configure login post request
        let url = ApiUrl.loginUrl(email: email)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //TODO: revisit how these info are retrieved
        let loginRequestContent = LoginRequest(
            password: password,
            os: UIDevice().systemName + " " + UIDevice().systemVersion,
            app: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
            hardware: UIDevice().model,
            region: Locale.autoupdatingCurrent.regionCode ?? "",
            language: Locale.autoupdatingCurrent.languageCode ?? "")
        guard let data = try? JSONEncoder().encode(loginRequestContent) else {
            print("failed to encode request data")
            return Fail(error: NSError()).eraseToAnyPublisher()
        }
        request.httpBody = data
        
        // conect the request to a URLSession
        let publisher = URLSession(configuration: .default).dataTaskPublisher(for: request)
            .map({ dataAndResponse in
                return dataAndResponse.data
            })
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .share()
        
        // make the request happen, store the application key
        self.loginCancellable = publisher
            .sink(receiveCompletion: {
                arg in
            }, receiveValue: {
                loginResponse in
                self.applicationAuthenticationKey = loginResponse.applicationKey
            })
        return publisher.ignoreOutput().eraseToAnyPublisher()
    }
    
}

