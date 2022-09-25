//
//  RegistrationServiceDefault.swift
//  up-english
//
//  Created by James Tsai on 5/11/21.
//

import Foundation
import Combine

struct RegistrationResponse: Codable {
    let email: String
    let userAuthenticationApplicationKey: String
}

struct ConfirmationResponse: Codable {
    let email: String
    let applicationKey: String
}

struct VerificationRequestBody: Encodable {
    let confirmationCode: String
}

class RegistrationServiceDefault: RegistrationService {
    
    private var requestConfirmationCancellable: AnyCancellable?
    
    private var ctxwlUrlSession: CTXWLURLSession
    
    private var userService: UserService
    
    init(ctxwlUrlSession: CTXWLURLSession, userService: any UserService) {
        self.ctxwlUrlSession = ctxwlUrlSession
        self.userService = userService
    }
        
    private var applicationKey: String {
        get {
            guard let applicationKey = UserDefaults.standard.string(forKey: "applicationKey") else {
                return ""
            }
            return applicationKey
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "applicationKey")
        }
    }
    
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
    
    func requestEmailConfirmation() -> AnyPublisher<String, CLIENT_ERROR> {
        
        // make sure we have valid email and password
        guard let credential = self.userService.credential else {
            return Fail(error: CREDENTIALS_EMPTY()).eraseToAnyPublisher()
        }
        
        // configure email registration post request
        let url = ApiUrl.emailConfirmationUrl()
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let data = try? JSONEncoder().encode(["email": credential.username, "password": credential.password]) else {
            print("failed to encode request data")
            return Fail(error: ENCODING_FAILED()).eraseToAnyPublisher()
        }
        request.httpBody = data

        // connect the request to a URLSession, decode the response data and keep a multicasted publisher
        let publisher = self.ctxwlUrlSession.dataTaskPublisher(for: request)
            .decode(type: ConfirmationResponse.self, decoder: JSONDecoder())
            .map { response in response.applicationKey }
            .mapError({ (error) -> CLIENT_ERROR in
                if let error = error as? CLIENT_ERROR {
                    return error
                } else {
                    return CANNOT_DECODE_RESPONSE()
                }
            })
            .share()
        
//         make the request happen and store the application key
        self.requestConfirmationCancellable = publisher
            .sink(receiveCompletion: { arg in }, receiveValue: { confirmationResponse in
                self.applicationKey = confirmationResponse
            })
        return publisher.eraseToAnyPublisher()
    }
    
    func register(confirmationCode: String) -> AnyPublisher<String, CLIENT_ERROR> {
        
        // make sure we have up to date email
        guard let email = self.userService.credential?.username else {
            return Fail(error: CREDENTIALS_EMPTY()).eraseToAnyPublisher()
        }
        
        // configure verification patch request
        let url = ApiUrl.registrationUrl(email: email)
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.applicationKey, forHTTPHeaderField: "X-Ctxwl-Key")
        guard let data = try? JSONEncoder().encode(VerificationRequestBody(confirmationCode: confirmationCode)) else {
            return Fail<String, CLIENT_ERROR>(error: ENCODING_FAILED()).eraseToAnyPublisher()
        }
        request.httpBody = data
        
        // decode the response data, map out the authentication application key and share the publisher
        let publisher = self.ctxwlUrlSession.dataTaskPublisher(for: request)
            .decode(type: RegistrationResponse.self, decoder: JSONDecoder())
            .map { response in response.userAuthenticationApplicationKey}
            .mapError({ (error) -> CLIENT_ERROR in
                if let error = error as? CLIENT_ERROR {
                    return error
                } else {
                    return CANNOT_DECODE_RESPONSE()
                }
            })
            .share()
            .eraseToAnyPublisher()
        
        // subscribe to the publisher and save the application key to user service
        let cancellable = publisher.sink(receiveCompletion: {_ in}, receiveValue: {value in self.userService.applicationKey = value})
        
        // return the publisher
        return publisher
    }
}


