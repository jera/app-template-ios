//
//  Helper.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

class Helper {

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
