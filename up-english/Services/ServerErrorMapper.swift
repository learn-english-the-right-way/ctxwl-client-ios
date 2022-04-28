//
//  ServerErrorMapper.swift
//  up-english
//
//  Created by James Tsai on 4/26/22.
//

import Foundation

struct ServerErrorMapper: ErrorMapper {
    func mapToClientError(from error: Error) -> CTXWLClientError? {
        guard let serverError = error as? CTXWLServerError else {
            return nil
        }
        for cause in serverError.causes {
            if cause.component == "email_registration" {
                if cause.code == "invalid_email_address.occupied" {
                    return EmailRegistrationError(.emailOccupied)
                }
                else if cause.code == "invalid_email_address.malformed" {
                    return EmailRegistrationError(.emailMalformed)
                }
                else if cause.code == "unauthorized_email_address.mismatch" {
                    return EmailVerificationError(.emailMismatch)
                }
                else if cause.code == "unauthorized_email_address.expired" {
                    return EmailVerificationError(.emailExpired)
                }
                else if cause.code == "invalid_verification_code.mismatch" {
                    return EmailVerificationError(.verificationCodeMismatch)
                } else if cause.code == "invalid_verification_code.tried_too_many_times" {
                    return EmailVerificationError(.verificationCodeTriedTooManyTimes)
                }
            } else if cause.component == "api" {
                if cause.code == "unauthenticated_caller.unauthenticated" {
                    return AuthError(.callerUnauthenticated)
                }
                else if cause.code == "unauthenticated_caller.invalid_application_key" {
                    return AuthError(.invalidApplicationKey)
                }
                else if cause.code == "unauthorized_access" {
                    return AuthError(.unauthorizedAccess)
                }
                else if cause.code == "data_error" {
                    return DataError()
                }
            }
        }
        return UnspecifiedServerError()
    }
}
