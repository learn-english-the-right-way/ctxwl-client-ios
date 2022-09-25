//
//  UIErrorMapperDefault.swift
//  up-english
//
//  Created by James Tsai on 7/2/22.
//

import Foundation
import Combine

class UIErrorMapperDefault: UIErrorMapper {
    func mapError(_ serviceError: CLIENT_ERROR) -> UIEffect {
        var exception = UIEffect()
        if serviceError is SESSION_AUTHENTICATION_INVALID_CREDENTIAL {
            exception.message = "wrong username or password"
            exception.action = .notice
        } else if serviceError is SESSION_AUTHENTICATION_ERROR {
            exception.message = "authentication error, cannot continue"
            exception.action = .notice
        } else if serviceError is EMAIL_REGISTRATION_INVALID_CONFIRMATION_CODE {
            exception.message = "wrong confirmation code"
            exception.action = .notice
        } else if serviceError is EMAIL_REGISTRATION_UNAUTHORIZED_EMAIL_ADDRESS {
            exception.message  = "email address is not registered"
            exception.action = .notice
        } else if serviceError is EMAIL_REGISTRATION_ERROR {
            exception.message = "error when registering, cannot continue"
            exception.action = .notice
        } else if serviceError is API_ERROR {
            exception.message = "something wrong"
            exception.action = .notice
        } else {
            exception.message = "unknown error"
            exception.action = .notice
        }
        return exception
    }
}
