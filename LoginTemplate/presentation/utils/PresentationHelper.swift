//
//  PresentationHelper.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func controllerFromStoryboard(withName name: String, viewControllerIdentifier: String? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        
        let viewController: UIViewController?
        if let viewControllerIdentifier = viewControllerIdentifier {
            viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        }else {
            viewController = storyboard.instantiateInitialViewController()
        }
        
        return viewController
    }
}
