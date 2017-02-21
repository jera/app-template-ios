//
//  LoginWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

protocol LoginWireFrameInterface: class{
    func goToForgotPassword()
    func goToCreateAccount()
}

class LoginWireFrame: BaseWireFrame {
    
    let loginPresenter: LoginPresenter
    let loginInteractor: LoginInteractor
    let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
    let apiClientInterface = APIClient()
    let facebookAPI = FacebookAPI()
    let googleAPI = GoogleAPI.shared
    
    override init() {
        loginInteractor = LoginInteractor(repositoryInterface: LoginRepository(apiClientInterface: apiClientInterface, facebookAPIInterface: facebookAPI, googleAPIInterface: googleAPI))
        loginPresenter = LoginPresenter(interactorInterface: loginInteractor)
        
        super.init()
        
        loginPresenter.router = self
        loginViewController.presenterInterface = loginPresenter
    }
    
}

extension LoginWireFrame: LoginWireFrameInterface{
    func goToForgotPassword(){
        print("TODO goToForgotPassword")
    }
    
    func goToCreateAccount(){
        print("TODO goToCreateAccount")
    }
}
