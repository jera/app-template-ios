//
//  ForgotPasswordWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

class ForgotPasswordWireFrame: BaseWireFrame {
    
    fileprivate var navigationController: UINavigationController?
    fileprivate var viewController: ForgotPasswordViewController?
    fileprivate var forgotPasswordPresenter: ForgotPasswordPresenter?
    fileprivate var forgotPasswordInteractor: ForgotPasswordInteractor?
    
    func presentForgotPassword(rootViewController: UIViewController) {
        viewController = ForgotPasswordViewController()
        if let viewController = viewController{
            self.navigationController = BaseNavigationController(rootViewController: viewController)
            if let navigationController = navigationController{
                configureDependecies(viewController: viewController)
                rootViewController.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    func popForgotPassword() {
        if let navigationController = navigationController {
            deallocDependences()
            navigationController.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureDependecies(viewController: ForgotPasswordViewController) {
        forgotPasswordInteractor = ForgotPasswordInteractor()
        forgotPasswordPresenter = ForgotPasswordPresenter()
        
        viewController.presenterInterface = forgotPasswordPresenter
        forgotPasswordPresenter?.router = self
        forgotPasswordPresenter?.forgotPasswordInteractor = forgotPasswordInteractor
        forgotPasswordPresenter?.viewInterface = viewController
        forgotPasswordInteractor?.output = forgotPasswordPresenter
    }
    
    override func deallocDependences() {
        if let viewController = viewController {
            viewController.presenterInterface = nil
            self.viewController = nil
            self.forgotPasswordPresenter = nil
            self.forgotPasswordInteractor = nil
            self.navigationController = nil
        }
    }
    
}