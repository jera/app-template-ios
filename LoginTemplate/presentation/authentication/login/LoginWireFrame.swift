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
    
    let viewController: LoginViewController
    private let presenter: LoginPresenterProtocol
    private let interactor: LoginInteractorProtocol

    override init() {

        let interactor = LoginInteractor(repository: LoginRepository(apiClient: APIClient(), facebookAPI: FacebookAPI(), googleAPI: GoogleAPI.shared))
        let presenter = LoginPresenter(interactor: interactor)
        
        self.presenter = presenter
        self.interactor = interactor
        self.viewController = LoginViewController(presenter: presenter)
        self.viewController.presenter = presenter
        
        super.init()
        
        presenter.router = self
        presenter.viewProtocol = viewController
    }
    
}

extension LoginWireFrame: LoginWireFrameProtocol {
    func goToForgotPassword() {
        let forgotPasswordWireFrame = ForgotPasswordWireFrame()
        forgotPasswordWireFrame.presentOn(viewController: viewController, presenterWireFrame: self)
        self.presentedWireFrame = forgotPasswordWireFrame
    }
    
    func goToCreateAccount() {
        let createAccountWireFrame = CreateAccountWireFrame()
        createAccountWireFrame.presentOn(viewController: viewController, presenterWireFrame: self)
        self.presentedWireFrame = createAccountWireFrame
    }
}

extension LoginWireFrame: ForgotPasswordPresenterWireFrameProtocol, CreateAccountPresenterWireFrameProtocol {
    
}
