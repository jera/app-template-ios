//
//  ForgotPasswordWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

class ForgotPasswordWireFrame: BaseWireFrame {
    
    fileprivate var navigationController = UINavigationController()
    fileprivate let forgotPasswordPresenter: ForgotPasswordPresenter
    fileprivate var forgotPasswordInteractor: ForgotPasswordInteractor
    fileprivate let viewController = ForgotPasswordViewController()
    fileprivate let apiClientInterface = APIClient()
    fileprivate var loginWireFrame: LoginWireFrame?
    
    override init() {
        forgotPasswordInteractor = ForgotPasswordInteractor(repositoryInterface: ForgotPasswordRepository(apiClientInterface: apiClientInterface))
        forgotPasswordPresenter = ForgotPasswordPresenter(interactorInterface: forgotPasswordInteractor)
        
        super.init()
        
        navigationController = BaseNavigationController(rootViewController: viewController)
        forgotPasswordPresenter.router = self
        viewController.presenterInterface = forgotPasswordPresenter
    }
    
    func presentForgotPassword(rootViewController: UIViewController, loginWireFrame: LoginWireFrame) {
        self.loginWireFrame = loginWireFrame
        rootViewController.present(navigationController, animated: true, completion: nil)
    }
    
    func popForgotPassword() {
        navigationController.dismiss(animated: true, completion: { [weak self] in
            if let strongSelf = self {
                strongSelf.loginWireFrame?.deallocForgotPasswordWireFrame()
            }
        })
    }
    
}
