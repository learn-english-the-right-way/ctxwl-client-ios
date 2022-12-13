//
//  ServerErrorMapper.swift
//  up-english
//
//  Created by James Tsai on 4/26/22.
//

import Foundation

struct ServerErrorMapper: ErrorMapper {
    func mapToClientError(from error: Error) -> CLIENT_ERROR? {
        guard let serverError = error as? CTXWL_SERVER_ERROR else {
            if let error = error as? CLIENT_ERROR {
                return error
            } else {
                return CONNECTION_FAILED()
            }
        }
        for cause in serverError.causes {
            if cause.component == "email_registration" {
                if cause.code == "invalid_request" {
                    return EMAIL_REGISTRATION_INVALID_REQUEST(serverError.message)
                }
                else if cause.code == "unauthorized_email_address" {
                    return EMAIL_REGISTRATION_UNAUTHORIZED_EMAIL_ADDRESS(serverError.message)
                }
                else if cause.code == "invalid_confirmation_code" {
                    return EMAIL_REGISTRATION_INVALID_CONFIRMATION_CODE(serverError.message)
                }
                else {
                    return EMAIL_REGISTRATION_ERROR(serverError.message)
                }
            } else if cause.component == "session_authentication" {
                if cause.code == "invalid_request" {
                    return SESSION_AUTHENTICATION_INVALID_REQUEST(serverError.message)
                }
                else if cause.code == "invalid_credential" {
                    return SESSION_AUTHENTICATION_INVALID_CREDENTIAL(serverError.message)
                }
                else if cause.code == "unsupported_authentication_method" {
                    return SESSION_AUTHENTICATION_UNSUPPORTED_AUTHENTICATION_METHOD(serverError.message)
                }
                else {
                    return SESSION_AUTHENTICATION_ERROR(serverError.message)
                }
            } else if cause.component == "api" {
                if cause.code == "unauthenticated" {
                    return API_UNAUTHENTICATED(serverError.message)
                }
                else if cause.code == "data_error" {
                    return API_DATA_ERROR(serverError.message)
                }
                else {
                    return API_ERROR(serverError.message)
                }
            }
        }
        return UNSPECIFIED_SERVER_ERROR(serverError.message)
    }
}
