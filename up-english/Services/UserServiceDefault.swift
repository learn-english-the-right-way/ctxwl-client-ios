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

class UserServiceDefault: UserService, SessionConnectionService {
    
    private var ctxwlURLSession: CTXWLURLSession
    
    private var loginCancellable: AnyCancellable?
    
    private var errorsSubject: PassthroughSubject<CLIENT_ERROR, Never>
    
    private var _applicationKey: String?
    
    private var _credential: Credential?
    
    private var _authenticationKeyAccquired = CurrentValueSubject<String?, Never>(nil)
    
    var authenticationKeyAccquired: AnyPublisher<String, Never> {
        return _authenticationKeyAccquired.compactMap({$0}).eraseToAnyPublisher()
    }
    
    var errorsPublisher: AnyPublisher<CLIENT_ERROR, Never> {
        get {
            return self.errorsSubject.eraseToAnyPublisher()
        }
    }
    
    var credential: Credential? {
        get {
            if self._credential != nil {
                return self._credential
            } else {
                return try? self.readCredentialsFromKeychain()
            }
        }
    }
    
    var applicationKey: String? {
        get {
            if self._applicationKey != nil {
                return self._applicationKey
            } else {
                return try? self.readApplicationKeyFromKeychain()
            }
        }
    }
        
    init(ctxwlUrlSession: CTXWLURLSession) {
        self.ctxwlURLSession = ctxwlUrlSession
        self.errorsSubject = PassthroughSubject()
    }
    
    private func readCredentialsFromKeychain() throws -> Credential {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecAttrLabel as String: "password",
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {throw KEYCHAIN_CREDENTIALS_NOT_FOUND()}
        guard status == errSecSuccess else {throw KEYCHAIN_ERROR()}
        guard let existingItem = item as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8),
              let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KEYCHAIN_CREDENTIALS_NOT_FOUND()
        }
        return Credential(username: account, password: password)
    }
    
    private func saveCredentialsToKeychain(email: String, password: String) throws -> Void {
        let credential = Credential(username: email, password: password)
        let account = credential.username
        let password = credential.password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: server,
                                    kSecAttrLabel as String: "password",
                                    kSecValueData as String: password]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KEYCHAIN_CANNOT_SAVE_CREDENTIAL()
        }
    }
    
    private func readApplicationKeyFromKeychain() throws -> String {
        guard let account = try? self.readCredentialsFromKeychain().username else {
            throw KEYCHAIN_CREDENTIALS_NOT_FOUND()
        }
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecAttrAccount as String: account,
                                    kSecAttrLabel as String: "applicationKey",
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {throw KEYCHAIN_APPLICATION_KEY_NOT_FOUND()}
        guard status == errSecSuccess else {throw KEYCHAIN_ERROR()}
        guard let existingItem = item as? [String: Any],
              let applicationKeyData = existingItem[kSecValueData as String] as? Data,
              let applicationKey = String(data: applicationKeyData, encoding: String.Encoding.utf8)
        else {
            throw KEYCHAIN_APPLICATION_KEY_NOT_FOUND()
        }
        return applicationKey
    }
    
    private func saveApplicationKeyToKeychain(key: String) throws -> Void {
        guard let account = try? self.readCredentialsFromKeychain().username else {
            throw KEYCHAIN_CREDENTIALS_NOT_FOUND()
        }
        let applicationKey = key.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: server,
                                    kSecAttrLabel as String: "applicationKey",
                                    kSecValueData as String: applicationKey]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KEYCHAIN_CANNOT_SAVE_APPLICATION_KEY()
        }
    }
    
    func saveCredential(username: String, password: String) throws -> Void {
        self._credential = Credential(username: username, password: password)
        try self.saveCredentialsToKeychain(email: username, password: password)
    }
    
    func saveAuthenticationApplicationKey(key: String) throws -> Void {
        self._applicationKey = key
        self._authenticationKeyAccquired.send(key)
        try self.saveApplicationKeyToKeychain(key: key)
    }
    
    func sessionProtectedDataTaskPublisher(request: URLRequest) -> AnyPublisher<Data, CLIENT_ERROR> {
        var newRequest = request
        newRequest.setValue(applicationKey, forHTTPHeaderField: "X-Ctxwl-Key")
        print("sending request to:" + newRequest.url!.debugDescription)
        print("request headers:" + newRequest.allHTTPHeaderFields!.debugDescription)
        print("request body" + (newRequest.httpBody?.debugDescription ?? ""))
        return self.ctxwlURLSession.dataTaskPublisher(for: newRequest)
            .catch { (error) -> AnyPublisher<Data, CLIENT_ERROR> in
                let errorType = type(of: error)
                if errorType == API_UNAUTHENTICATED.self {
                    return self.requestLogin()
                        .flatMap { (applicationKey) -> CTXWLDataTaskPublisher in
                            var newRequest = request
                            newRequest.setValue(applicationKey, forHTTPHeaderField: "X-Ctxwl-Key")
                            return self.ctxwlURLSession.dataTaskPublisher(for: request)
                        }
                        .eraseToAnyPublisher()
                } else {
                    return Fail<Data, CLIENT_ERROR>(error: error)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func requestLogin() -> AnyPublisher<String, CLIENT_ERROR> {
        
        // configure login post request
        guard let credentials = self.credential else {
            return Fail(error: CREDENTIALS_EMPTY()).eraseToAnyPublisher()
        }
        let url = ApiUrl.loginUrl(email: credentials.username)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //TODO: revisit how these info are retrieved
        let loginRequestContent = LoginRequest(
            password: credentials.password,
            os: UIDevice().systemName + " " + UIDevice().systemVersion,
            app: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "",
            hardware: UIDevice().model,
            region: Locale.autoupdatingCurrent.regionCode ?? "",
            language: Locale.autoupdatingCurrent.languageCode ?? "")
        guard let data = try? JSONEncoder().encode(loginRequestContent) else {
            print("failed to encode request data")
            return Fail(error: ENCODING_FAILED()).eraseToAnyPublisher()
        }
        request.httpBody = data
        
        // conect the request to a URLSession
        return self.ctxwlURLSession.dataTaskPublisher(for: request)
            .first()
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .map({ loginResponse in loginResponse.applicationKey })
            .mapError({ (error) -> CLIENT_ERROR in
                if let error = error as? CLIENT_ERROR {
                    return error
                } else {
                    return CANNOT_DECODE_RESPONSE()
                }
            })
            .share()
            .eraseToAnyPublisher()
    }
    
    func login() -> AnyPublisher<Result<Void, CLIENT_ERROR>, Never> {
        let publisher = self.requestLogin()
        self.loginCancellable = publisher.sink(
            receiveCompletion: {
                print("user service login method completion with \($0)")
            },
            receiveValue: {
                print("received application key:" + $0)
                do {
                    try self.saveAuthenticationApplicationKey(key: $0)
                } catch {
                    self.errorsSubject.send(KEYCHAIN_CANNOT_SAVE_APPLICATION_KEY())
                }
            })
        return publisher
            .map { _ in Result<Void, CLIENT_ERROR>.success(())}
            .catch { clientError in Just(Result<Void, CLIENT_ERROR>.failure(clientError))}
            .eraseToAnyPublisher()
    }
    
}

