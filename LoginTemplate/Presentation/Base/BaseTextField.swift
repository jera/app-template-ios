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
    case White
    case Black
}


extension BaseTextField{
    func applyAppearence(textFieldAppearence: BaseTextFieldAppearence){
        switch textFieldAppearence {
        case .White:
            //tintColor = UIColor.textFielTint()
            font = UIFont.systemFont(ofSize: 14)
            //textColor = UIColor.textFielText()
            backgroundColor = UIColor.white.withAlphaComponent(0.2)
            
            placeholderLabel.font = UIFont.systemFont(ofSize: 14)
            placeholderNormalColor = UIColor.white.withAlphaComponent(0.7)
            //placeholderActiveColor = UIColor.textFielTint()
            placeholderVerticalOffset = 24
            
            dividerNormalHeight = 1/UIScreen.main.nativeScale
            dividerActiveHeight = 1/UIScreen.main.nativeScale
            dividerColor = UIColor.white.withAlphaComponent(0.7)
            dividerNormalColor = UIColor.white.withAlphaComponent(0.7)
            dividerActiveColor = UIColor.white.withAlphaComponent(0.7)
            
            detailLabel.font = UIFont.systemFont(ofSize: 12)
            detailColor = UIColor.white.withAlphaComponent(1)
        case .Black:
            tintColor = UIColor.gray
            font = UIFont.systemFont(ofSize: 14)
            textColor = UIColor.black
            backgroundColor = UIColor.white.withAlphaComponent(0.2)
            
            placeholderLabel.font = UIFont.systemFont(ofSize: 14)
            placeholderNormalColor = UIColor.gray.withAlphaComponent(0.7)
            placeholderActiveColor = UIColor.gray
            placeholderVerticalOffset = 24
            
            dividerNormalHeight = 1/UIScreen.main.nativeScale
            dividerActiveHeight = 1/UIScreen.main.nativeScale
            dividerColor = UIColor.gray.withAlphaComponent(0.7)
            dividerNormalColor = UIColor.gray.withAlphaComponent(0.7)
            dividerActiveColor = UIColor.gray.withAlphaComponent(0.7)
            
            detailLabel.font = UIFont.systemFont(ofSize: 12)
            detailColor = UIColor.gray.withAlphaComponent(1)
        }
    }
}

