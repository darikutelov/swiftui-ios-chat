//
//  AuthError.swift
//  ChatPro
//
//  Created by Dariy Kutelov on 7.10.24.
//

import FirebaseAuth

enum AuthError: Error {
    case invalidEmail
    case invalidPassword
    case userNotFound
    case weakPassword
    case invalidData
    case unknown
    
    init(authErrorCode: AuthErrorCode) {
        switch authErrorCode {
        case .invalidEmail:
            self = .invalidEmail
        case .wrongPassword:
            self = .invalidPassword
        case .weakPassword:
            self = .weakPassword
        case .userNotFound:
            self = .userNotFound
        default:
            self = .unknown
        }
    }
    
    var description: String {
        switch self {
        case .invalidEmail:
            return "The email you entered is invalid. Please try again"
        case .invalidPassword:
            return "Incorrect password. Please try again"
        case .userNotFound:
            return "It looks like there is no account associated with this email. Create an account to continue"
        case .weakPassword:
            return "Your password must be at least 6 characters in length. Please try again."
        case .unknown:
            return "An unknown error occured. Please try again."
        case .invalidData:
            return "Enter all fields in correct format"
        }
    }
}

