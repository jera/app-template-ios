//
//  MaterialAppearance.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 21/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import Material
import NSStringMask
import RxSwift

extension UIButton {
    func setTitleWithoutAnimation(_ title: String?, for state: UIControlState) {
        UIView.performWithoutAnimation { [weak self] in
            self?.setTitle(title, for: state)
            self?.layoutIfNeeded()
        }
    }
}

extension UIImage {
    static func fromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}

enum RaisedButtonAppearance {
    case facebook
    case google
    case main
}

extension RaisedButton {
    func applyAppearance(appearance: RaisedButtonAppearance) {
        switch appearance {
        case .facebook:
            pulseColor = .white
            backgroundColor = Color(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            setBackgroundImage(UIImage.fromColor(color: .red), for: .disabled)
            setTitleColor(.white, for: .normal)
            setTitleWithoutAnimation(R.string.localizable.loginFacebook(), for: .normal)
            setImage(#imageLiteral(resourceName: "ic_facebook"), for: .normal)
        case .google:
            pulseColor = .lightGray
            backgroundColor = .white
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            setBackgroundImage(UIImage.fromColor(color: .red), for: .disabled)
            setTitleColor(.gray, for: .normal)
            setTitleWithoutAnimation(R.string.localizable.loginGoogle(), for: .normal)
            setImage(#imageLiteral(resourceName: "ic_google"), for: .normal)
        case .main:
            pulseColor = .white
            backgroundColor = UIColor.buttonColor
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            setTitleColor(.white, for: .normal)
            
            //disable
            setBackgroundImage(UIImage.fromColor(color: Color(white: 0.88, alpha: 1)), for: .disabled)
            setTitleColor(Color(white: 0.74, alpha: 1), for: .disabled)
        }
    }
}

enum FlatButtonAppearance {
    case main
    case white
}

extension FlatButton {
    func applyAppearance(appearance: FlatButtonAppearance) {
        switch appearance {
        case .main:
            pulseColor = .white
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            setTitleColor(.white, for: .normal)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            
            //disable
            setTitleColor(Color(white: 0.74, alpha: 1), for: .disabled)
        case .white:
            pulseColor = .gray
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            setTitleColor(.gray, for: .normal)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            
            //disable
            setTitleColor(Color(white: 0.74, alpha: 1), for: .disabled)
        }
    }
}

enum TextFieldAppearence {
    case main
    case white
}

extension TextField {
    func applyAppearance(appearance: TextFieldAppearence) {
        switch appearance {
        case .main:
            tintColor = UIColor.white
            font = UIFont.systemFont(ofSize: 14)
            textColor = UIColor.white
            backgroundColor = .clear
            
            placeholderLabel.font = UIFont.systemFont(ofSize: 14)
            placeholderNormalColor = UIColor.white.withAlphaComponent(0.7)
            placeholderActiveColor = UIColor.white
            placeholderVerticalOffset = 20
            
            dividerColor = UIColor.white.withAlphaComponent(0.7)
            dividerNormalColor = UIColor.white.withAlphaComponent(0.3)
            dividerActiveColor = UIColor.white
            dividerContentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
            
            detailLabel.font = UIFont.systemFont(ofSize: 10)
            detailColor = Color.red.base
            detailVerticalOffset = -2
        case .white:
            tintColor = UIColor.gray
            font = UIFont.systemFont(ofSize: 14)
            textColor = UIColor.gray
            backgroundColor = UIColor.white
            
            placeholderLabel.font = UIFont.systemFont(ofSize: 14)
            placeholderNormalColor = UIColor.gray.withAlphaComponent(0.7)
            placeholderActiveColor = UIColor.gray
            placeholderVerticalOffset = 20
            
            dividerColor = UIColor.gray.withAlphaComponent(0.7)
            dividerNormalColor = UIColor.gray.withAlphaComponent(0.3)
            dividerActiveColor = UIColor.dividerTextField
            dividerContentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 6, right: 0)
            
            detailLabel.font = UIFont.systemFont(ofSize: 10)
            detailColor = Color.red.base
            detailVerticalOffset = -2
        }
    }
}
