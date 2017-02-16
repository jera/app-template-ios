//
//  HelperDomain.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Foundation

class DomainHelper {
    
    static func isEmailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
