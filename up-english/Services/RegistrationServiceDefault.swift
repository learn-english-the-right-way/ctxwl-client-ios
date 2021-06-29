//
//  RegistrationServiceDefault.swift
//  up-english
//
//  Created by James Tsai on 5/11/21.
//

import Foundation
import Combine

class RegistrationServiceDefault: RegistrationService {
    
    private var requestConfirmationCancellable: AnyCancellable?
    
    private var applicationKey = ""
    
    var registrationStatus: RegistrationStatus {
        get {
            let statusValue = UserDefaults.standard.integer(forKey: "registrationStatus")
            return RegistrationStatus(rawValue: statusValue)!
        }
        set(newStatus) {
            UserDefaults.standard.set(newStatus.rawValue, forKey: "registrationStatus")
        }
    }
    
    func resetRegistrationStatus() -> Void {
        registrationStatus = .NotRegistered
    }
    
    func currentRegistrationStatus() -> RegistrationStatus {
        return registrationStatus
    }
    
    func requestEmailConfirmation(email: String, password: String) -> AnyPublisher<Never, Error> {
        
        // configure email registration post request
        let url = ApiUrl.emailConfirmationUrl()
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let data = try? JSONEncoder().encode(["email": email, "password": password]) else {
            print("failed to encode request data")
            return Fail(error: NSError()).eraseToAnyPublisher()
        }
        request.httpBody = data
        
        // connect the request to a URLSession, decode the response data and keep a multicasted publisher
        let publisher = URLSession(configuration: URLSessionConfiguration.default).dataTaskPublisher(for: request)
            .map({ dataAndResponse in
                return dataAndResponse.data
            })
            .decode(type: ConfirmationResponse.self, decoder: JSONDecoder())
            .share()
        
        // make the request happen and store the application key
        self.requestConfirmationCancellable = publisher
            .sink(receiveCompletion: { arg in print(arg)}, receiveValue: { confirmationResponse in
                self.applicationKey = confirmationResponse.applicationKey
            })
        return publisher.ignoreOutput().eraseToAnyPublisher()
    }
    
    func register(email: String, confirmationCode: String) -> AnyPublisher<RegistrationResponse, Error> {
        let url = ApiUrl.registrationUrl(email: email)
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(self.applicationKey, forHTTPHeaderField: "X-Ctxwl-Key")
        guard let data = try? JSONEncoder().encode(["confirmationCode": confirmationCode]) else {
            return Fail<RegistrationResponse, Error>(error: NSError()).eraseToAnyPublisher()
        }
        request.httpBody = data
        let urlSession = URLSession(configuration: .default)
        return urlSession.dataTaskPublisher(for: request)
            .map({ dataAndResponse in
                return dataAndResponse.data
            })
            .decode(type: RegistrationResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


