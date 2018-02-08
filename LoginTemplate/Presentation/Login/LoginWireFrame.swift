//
//  LoginWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

protocol LoginWireFrameProtocol: class {
    func goToForgotPassword()
    func goToCreateAccount()
}

class LoginWireFrame: BaseWireFrame {
    
    let loginPresenter: LoginPresenterProtocol
    let loginInteractor: LoginInteractorProtocol
    let loginViewController = LoginViewController()
    let apiClient: APIClientProtocol = APIClient()
    let facebookAPI: FacebookAPIProtocol = FacebookAPI()
    let googleAPI: GoogleAPIProtocol = GoogleAPI.shared
    
    override init() {
        loginInteractor = LoginInteractor(repository: LoginRepository(apiClient: apiClient, facebookAPI: facebookAPI, googleAPI: googleAPI))
        let loginPresenter = LoginPresenter(interactor: loginInteractor)
        self.loginPresenter = loginPresenter
        
        loginViewController.presenter = loginPresenter
        
        super.init()
        
        loginPresenter.router = self
    }
    
}

extension LoginWireFrame: LoginWireFrameProtocol {
    func goToForgotPassword() {
        let forgotPasswordWireFrame = ForgotPasswordWireFrame()
        
        forgotPasswordWireFrame.presentOn(viewController: loginViewController, presenterWireFrame: self)
        
        self.presentedWireFrame = forgotPasswordWireFrame
    }
    
    func goToCreateAccount() {
        let createAccountWireFrame = CreateAccountWireFrame()
        
        createAccountWireFrame.presentOn(viewController: loginViewController, presenterWireFrame: self)
        
        self.presentedWireFrame = createAccountWireFrame
    }
}

extension LoginWireFrame: ForgotPasswordPresenterWireFrameProtocol, CreateAccountPresenterWireFrameProtocol {
    
}
