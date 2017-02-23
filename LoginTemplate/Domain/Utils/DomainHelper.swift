//
//  HelperDomain.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

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
    case minCharaters(count: Int)
    
    static func ==(lhs: CpfFieldError, rhs: CpfFieldError) -> Bool{
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

class DomainHelper {
    
    static func isEmailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

extension UIColor {
    
    static func defaultViewBackground() -> UIColor {
        return white
    }
    
    static func defaultTitleLabel() -> UIColor {
        return gray
    }
    
    static func defaultBarTint() -> UIColor {
        return UIColor(red:85/255, green:124/255, blue:211/255, alpha:1)
    }
    
    static func defaultBackgroundButton() -> UIColor{
        return UIColor(red: 189/255, green: 39/255, blue: 89/255, alpha: 1)
    }
    
    static func defaultTitleButton() -> UIColor{
        return white
    }
    
    class func primary() -> UIColor{
        return UIColor(red: 189/255, green: 39/255, blue: 89/255, alpha: 1)
    }
    
    class func textFielTint() -> UIColor{
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
}
