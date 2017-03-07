//
//  Appearence.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 21/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

struct Appearance{
    static let buttonColor = UIColor(red: 230/255, green: 37/255, blue: 101/255, alpha: 1)
    static let dividerTextFieldColor = UIColor(red: 230/255, green: 37/255, blue: 101/255, alpha: 1)
    static let barTintColor = UIColor(red:85/255, green:124/255, blue:211/255, alpha:1)
    
    static let backgroundImage: UIImage = #imageLiteral(resourceName: "img_bg")
    static let logoImage: UIImage = #imageLiteral(resourceName: "ic_logo")
    
    static func applyUIAppearence(){
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = barTintColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
}
