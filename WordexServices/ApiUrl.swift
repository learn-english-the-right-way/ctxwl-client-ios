//
//  APIURL.swift
//  up-english
//
//  Created by James Tsai on 5/20/21.
//

import Foundation

class ApiUrl {
    private static var baseUrl = "http://18.180.115.247:8888"
    static func emailConfirmationUrl() -> URL {
        return URL(string: self.baseUrl + "/email_registration")!
    }
    static func registrationUrl(email: String) -> URL {
        return URL(string: self.baseUrl + "/email_registration/" + email)!
    }
    static func loginUrl(email: String) -> URL {
        return URL(string: self.baseUrl + "/authentication/user.email:" + email + "/application_key_challenge")!
    }
    static func paragraphGeneratorURL() -> URL {
        return URL(string: self.baseUrl + "/generated_paragraph")!
    }
    static func readingSessionUrl() -> URL {
        return URL(string: self.baseUrl + "/reading_session")!
    }
    static func readingEntryUrl(applicationKey: String, session: String, serial: String) -> URL {
        return URL(string: self.baseUrl + "/reading_history_entry/\(session)-\(serial)")!
    }
    static func readingLookupUrl(session: String, entrySerial: Int, lookupSerial: Int) -> URL {
        return URL(string: self.baseUrl + "/reading_inspired_lookup/\(session)-\(entrySerial)-\(lookupSerial)")!
    }
}
