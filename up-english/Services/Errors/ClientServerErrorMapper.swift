//
//  ClientServerErrorMapper.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

func clientServerErrorMapper(_ serverError: Error) -> CTXWLClientError {
    if let serverError = serverError as? CTXWLServerError {
        for cause in serverError.causes {
            if cause.component == "email_registration" {
                if cause.code == "invalid_email_address.occupied" {
                    let error = EmailRegistrationError(.emailOccupied)
                    error.serverMessage = serverError.message
                    error.userMessage = "This email address is already used. Please use another one."
                    return error
                } else if cause.code == "invalid_email_address.malformed" {
                    let error = EmailRegistrationError(.emailMalformed)
                    error.serverMessage = serverError.message
                    error.userMessage =  "This is not a valid email address. Please input a correct email address."
                    return error
                } else if cause.code == "unauthorized_email_address.mismatch" {
                    let error = EmailVerificationError(.emailMismatch)
                    error.serverMessage = serverError.message
                    error.userMessage = "The email you are verifying has not been registered."
                    return error
                } else if cause.code == "unauthorized_email_address.expired" {
                    let error = EmailVerificationError(.emailExpired)
                    error.serverMessage = serverError.message
                    error.userMessage = "This email address has expired. Please register again."
                    return error
                } else if cause.code == "invalid_verification_code.mismatch" {
                    let error = EmailVerificationError(.verificationCodeMismatch)
                    error.serverMessage = serverError.message
                    error.userMessage = "Incorrect verification code."
                    return error
                } else if cause.code == "invalid_verification_code.tried_too_many_times" {
                    let error = EmailVerificationError(.verificationCodeTriedTooManyTimes)
                    error.serverMessage = serverError.message
                    error.userMessage = "This verification code has been tried too many times. Please register again."
                    return error
                }
            } else if cause.component == "api" {
                if cause.code == "unauthenticated_caller.unauthenticated" {
                    let error =  AuthError(.callerUnauthenticated)
                    error.serverMessage = serverError.message
                    return error
                } else if cause.code == "unauthenticated_caller.invalid_application_key" {
                    let error = AuthError(.invalidApplicationKey)
                    error.serverMessage = serverError.message
                    return error
                } else if cause.code == "unauthorized_access" {
                    let error = AuthError(.unauthorizedAccess)
                    error.serverMessage = serverError.message
                    return error
                } else if cause.code == "data_error" {
                    let error = DataError()
                    error.serverMessage = serverError.message
                    return error
                }
            }
        }
        let unknownError = UnspecifiedServerError()
        unknownError.serverMessage = serverError.message
        return unknownError
    } else if serverError is CTXWLUnknownServerError {
        return UnspecifiedServerError()
    } else if serverError is InvalidResponseError {
        return InvalidResponseError()
    } else if serverError is ResponseDecodeError {
        return InvalidResponseError()
    } else {
        return CTXWLClientError()
    }
}

