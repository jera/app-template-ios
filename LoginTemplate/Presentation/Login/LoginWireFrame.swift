//
//  LoginWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

class LoginWireFrame: BaseWireFrame {
    
    var loginPresenter = LoginPresenter()
    var loginInteractor =  LoginInteractor()
    var loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
    
    override init() {
        super.init()
        configureDependencies()
    }
    
    private func configureDependencies() {
        loginPresenter.router = self
        loginPresenter.interactorInterface = loginInteractor
        loginViewController.presenterInterface = loginPresenter
//        loginInteractor.outputInterface = loginPresenter
    }
}
