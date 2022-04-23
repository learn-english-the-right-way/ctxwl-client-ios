//
//  ClientServerErrorMapper.swift
//  up-english
//
//  Created by James Tsai on 4/22/22.
//

import Foundation

func clientServerErrorMapper(_ serverError: CTXWLError) -> CTXWLClientError {
    for cause in serverError.causes {
        if cause.component == "email_registration"{
            if cause.code == "invalid_email_address.occupied" {
                var error = EmailRegistrationError(.emailOccupied)
                error.serverMessage = serverError.message
                error.userMessage = "This email address is already used. Please use another one."
                return error
            } else if cause.code == "invalid_email_address.malformed" {
                var error = EmailRegistrationError(.emailMalformed)
                error.serverMessage = serverError.message
                error.userMessage =  "This is not a valid email address. Please input a correct email address."
                return error
            } else if cause.code == "unauthorized_email_address.mismatch" {
                var error = EmailVerificationError(.emailMismatch)
                error.serverMessage = serverError.message
                error.userMessage = "The email you are verifying has not been registered."
                return error
            } else if cause.code == "unauthorized_email_address.expired" {
                var error = EmailVerificationError(.emailExpired)
                error.serverMessage = serverError.message
                error.userMessage = "This email address has expired. Please register again."
                return error
            } else if cause.code == "invalid_verification_code.mismatch" {
                var error = EmailVerificationError(.verificationCodeMismatch)
                error.serverMessage = serverError.message
                error.userMessage = "Incorrect verification code."
                return error
            } else if cause.code == "invalid_verification_code.tried_too_many_times" {
                var error = EmailVerificationError(.verificationCodeTriedTooManyTimes)
                error.serverMessage = serverError.message
                error.userMessage = "This verification code has been tried too many times. Please register again."
                return error
            }
        } else if cause.component == "api" {
            if cause.code == "unauthenticated_caller.unauthenticated" {
                var error =  AuthError(.callerUnauthenticated)
                error.serverMessage = serverError.message
                return error
            } else if cause.code == "unauthenticated_caller.invalid_application_key" {
                var error = AuthError(.invalidApplicationKey)
                error.serverMessage = serverError.message
                return error
            } else if cause.code == "unauthorized_access" {
                var error = AuthError(.unauthorizedAccess)
                error.serverMessage = serverError.message
                return error
            } else if cause.code == "data_error" {
                var error = DataError()
                error.serverMessage = serverError.message
                return error
            }
        }
    }
    var unknownError = UnknownError()
    unknownError.serverMessage = serverError.message
    return unknownError
}

