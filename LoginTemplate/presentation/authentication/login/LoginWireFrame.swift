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
//    private let apiClient: APIClientProtocol
//    let facebookAPI: FacebookAPIProtocol
//    let googleAPI: GoogleAPIProtocol
    
    override init() {

        let facebookAPI = FacebookAPI()
        let googleAPI = GoogleAPI.shared
        let interactor = LoginInteractor(repository: LoginRepository(facebookAPI: facebookAPI, googleAPI: googleAPI))
        let presenter = LoginPresenter(interactor: interactor)
        
        self.presenter = presenter
        self.interactor = interactor
        self.viewController = LoginViewController()
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
