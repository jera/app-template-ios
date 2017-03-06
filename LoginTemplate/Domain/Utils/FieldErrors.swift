//
//  FieldErrors.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 27/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

enum NameFieldError: Equatable{
    case empty
}

enum EmailFieldError: Equatable{
    case empty
    case notValid
}

enum PhoneFieldError: Equatable{
    case empty
    case minCharaters(count: Int)
    
    static func ==(lhs: PhoneFieldError, rhs: PhoneFieldError) -> Bool{
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.minCharaters, .minCharaters):
            return true
        default:
            return false
        }
    }
}

enum CpfFieldError: Equatable{
    case empty
    case notValid
}

enum PasswordFieldError: Equatable{
    case empty
    case minCharaters(count: Int)
    
    static func ==(lhs: PasswordFieldError, rhs: PasswordFieldError) -> Bool{
        switch (lhs, rhs) {
        case (.empty, .empty):
            return true
        case (.minCharaters, .minCharaters):
            return true
        default:
            return false
        }
    }
}

enum ConfirmPasswordFieldError: Equatable{
    case confirmPasswordNotMatch
}
