//
//  BaseTextField.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import Material

class BaseTextField: TextField {
    
    var leftOffset: CGFloat = 0{
        didSet{
            leftView = UIView()
            leftViewOffset = -height + leftOffset
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: leftOffset, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return  bounds.insetBy(dx: leftOffset, dy: 0)
    }
}

import UIKit
import Material

enum BaseTextFieldFormPosition{
    case Top
    case Middle
    case Bottom
}

enum BaseTextFieldAppearence {
    case Default
}


extension BaseTextField{
    func applyAppearence(textFieldAppearence: BaseTextFieldAppearence){
        switch textFieldAppearence {
        case .Default:
            tintColor = UIColor.gray
            font = UIFont.systemFont(ofSize: 14)
            textColor = UIColor.gray
            backgroundColor = UIColor.white.withAlphaComponent(0.2)
            
            placeholderLabel.font = UIFont.systemFont(ofSize: 14)
            placeholderNormalColor = UIColor.gray.withAlphaComponent(0.7)
            placeholderActiveColor = UIColor.gray
            placeholderVerticalOffset = 24
            
            dividerNormalHeight = 3/UIScreen.main.nativeScale
            dividerActiveHeight = 3/UIScreen.main.nativeScale
            dividerColor = UIColor.gray.withAlphaComponent(0.7)
            dividerNormalColor = UIColor.gray.withAlphaComponent(0.7)
            dividerActiveColor = UIColor.primary().withAlphaComponent(0.7)
            
            detailLabel.font = UIFont.systemFont(ofSize: 12)
            detailColor = UIColor.white.withAlphaComponent(1)
        }
    }
}

