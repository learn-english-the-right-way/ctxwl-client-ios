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
    
    private var registerSaveApplicationKeyCancellable: AnyCancellable?
    
    private var saveKeyCancellable: AnyCancellable?
    
    private var ctxwlUrlSession: CTXWLURLSession
    
    private var userService: UserService
    
    private var errorsSubject: PassthroughSubject<CLIENT_ERROR, Never>
    
    init(ctxwlUrlSession: CTXWLURLSession, userService: UserService) {
        self.ctxwlUrlSession = ctxwlUrlSession
        self.userService = userService
        self.errorsSubject = PassthroughSubject()
    }
        
    private var applicationKey: String?
    
    var errorsPublisher: AnyPublisher<CLIENT_ERROR, Never> {
        get {
            return self.errorsSubject.eraseToAnyPublisher()
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
    
    func requestEmailConfirmation() -> AnyPublisher<Result<Void, CLIENT_ERROR>, Never> {
        
        // make sure we have valid email and password
        guard let credential = self.userService.credential else {
            return Just(Result.failure(CREDENTIALS_EMPTY())).eraseToAnyPublisher()
        }
        
        // configure email registration post request
        let url = ApiUrl.emailConfirmationUrl()
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        guard let data = try? JSONEncoder().encode(["email": credential.username, "password": credential.password]) else {
            print("failed to encode request data")
            return Just(Result.failure(ENCODING_FAILED())).eraseToAnyPublisher()
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
        self.saveKeyCancellable = publisher
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { confirmationResponse in
                    self.applicationKey = confirmationResponse
            })
        
        return publisher
            .map { key in Result<Void, CLIENT_ERROR>.success(())}
            .catch { error in Just(Result.failure(error))}
            .eraseToAnyPublisher()
    }
    
    func register(confirmationCode: String) -> AnyPublisher<Result<Void, CLIENT_ERROR>, Never> {
        // make sure we have up to date email
        guard let email = self.userService.credential?.username else {
            return Just(Result<Void, CLIENT_ERROR>.failure(CREDENTIALS_EMPTY())).eraseToAnyPublisher()
        }
        
        // configure verification patch request
        let url = ApiUrl.registrationUrl(email: email)
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(self.applicationKey, forHTTPHeaderField: "X-Ctxwl-Key")
        guard let data = try? JSONEncoder().encode(VerificationRequestBody(confirmationCode: confirmationCode)) else {
            return Just(Result<Void, CLIENT_ERROR>.failure(ENCODING_FAILED())).eraseToAnyPublisher()
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
        self.registerSaveApplicationKeyCancellable = publisher.sink(
            receiveCompletion: {_ in},
            receiveValue: {value in
                do {
                    try self.userService.saveAuthenticationApplicationKey(key: value)
                } catch {
                    self.errorsSubject.send(KEYCHAIN_CANNOT_SAVE_APPLICATION_KEY())
                }
                
            }
        )
        
        // return the publisher
        return publisher
            .map { _ in Result.success(())}
            .catch { clientError in Just(Result.failure(clientError))}
            .eraseToAnyPublisher()
    }
}


