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
    
    let loginPresenter: LoginPresenterInterface
    let loginInteractor: LoginInteractorInterface
    let loginViewController = LoginViewController()
    let apiClientInterface: APIClientInterface = APIClient()
    let facebookAPI: FacebookAPIInterface = FacebookAPI()
    let googleAPI: GoogleAPIInterface = GoogleAPI.shared
    
    fileprivate var createAccountWireFrameInterface: CreateAccountWireFrameInterface?
    
    override init() {
        loginInteractor = LoginInteractor(repositoryInterface: LoginRepository(apiClientInterface: apiClientInterface, facebookAPIInterface: facebookAPI, googleAPIInterface: googleAPI))
        let loginPresenter = LoginPresenter(interactorInterface: loginInteractor)
        self.loginPresenter = loginPresenter
        
        loginViewController.presenterInterface = loginPresenter
        
        super.init()
        
        loginPresenter.routerInterface = self
    }
    
}

extension LoginWireFrame: LoginWireFrameInterface{
    func goToForgotPassword(){
        print("TODO goToForgotPassword")
    }
    
    func goToCreateAccount(){
        let createAccountWireFrame = CreateAccountWireFrame()
        
        createAccountWireFrame.presentOn(viewController: loginViewController, presenterWireFrame: self)
        
        createAccountWireFrameInterface = createAccountWireFrame
    }
}

extension LoginWireFrame: CreateAccountPresenterWireFrameInterface{
    func dismiss(){
        loginViewController.dismiss(animated: true) { [weak self] in
            self?.createAccountWireFrameInterface = nil
        }
    }
}
