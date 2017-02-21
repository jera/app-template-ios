//
//  HelperDomain.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

class DomainHelper {
    
    static func isEmailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

extension UIButton {
    func setTitle(_ title: String?, for state: UIControlState, animated: Bool){
        guard !animated else {
            setTitle(title, for: state)
            return
        }
        
        UIView.performWithoutAnimation {
            setTitle(title, for: state)
            
            layoutIfNeeded()
        }
    }
    func setAttributedTitle(_ title: NSAttributedString?, for state: UIControlState, animated: Bool){
        guard !animated else {
            setAttributedTitle(title, for: state)
            return
        }
        
        UIView.performWithoutAnimation {
            setAttributedTitle(title, for: state)
            
            layoutIfNeeded()
        }
    }
}

extension UIColor {
    
    static func defaultViewBackground() -> UIColor {
        return white
    }
    
    static func defaultTitleLabel() -> UIColor {
        return UIColor(red:255, green:255, blue:255, alpha:1.0)
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
}
