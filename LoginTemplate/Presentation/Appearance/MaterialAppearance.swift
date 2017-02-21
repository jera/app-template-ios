//
//  MaterialAppearance.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 21/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Material

extension UIButton{
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

enum RaisedButtonAppearance{
    case facebook
    case google
    case normal
}

extension RaisedButton{
    func applyAppearance(appearance: RaisedButtonAppearance){
        switch appearance {
        case .facebook:
            pulseColor = .white
            backgroundColor = Color(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            setBackgroundImage(UIImage.fromColor(color: .red), for: .disabled)
            setTitleColor(.white, for: .normal)
            setTitleWithoutAnimation("FACEBOOK", for: .normal)
            setImage(#imageLiteral(resourceName: "ic_facebook"), for: .normal)
        case .google:
            pulseColor = .lightGray
            backgroundColor = .white
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            setBackgroundImage(UIImage.fromColor(color: .red), for: .disabled)
            setTitleColor(.gray, for: .normal)
            setTitleWithoutAnimation("GOOGLE", for: .normal)
            setImage(#imageLiteral(resourceName: "ic_google"), for: .normal)
        case .normal:
            pulseColor = .white
            backgroundColor = Appearance.mainColor
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            setTitleColor(.white, for: .normal)
            
            //disable
            setBackgroundImage(UIImage.fromColor(color: .lightGray), for: .disabled)
            setTitleColor(.darkGray, for: .disabled)
        }
    }
}
