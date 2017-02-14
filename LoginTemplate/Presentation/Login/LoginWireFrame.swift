//
//  LoginWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

class LoginWireFrame: BaseWireFrame {
    
    fileprivate var navigationController: UINavigationController?
    fileprivate var loginViewController: LoginViewController?
    fileprivate var loginInteractor: LoginInteractor?
    fileprivate var loginPresenter: LoginPresenter?
    fileprivate var mainWireFrame: MainWireFrame?
    
    func presentLoginInterface(mainWireFrame: MainWireFrame) -> BaseNavigationController{
        self.mainWireFrame = mainWireFrame
        let navigation = self.navigationControllerFromStoryboard(stroryBoardName: "Login")
        self.navigationController = navigation
        navigation.isNavigationBarHidden = true
        loginViewController = navigation.viewControllers.first as? LoginViewController
        configureDependecies(viewController: loginViewController!)
        return navigation
    }
    
    func goToEstablishment() {
        if let mainWireFrame = mainWireFrame {
            mainWireFrame.goToPage(mainPage: .Dashboard)
        }
    }
    
    func configureDependecies(viewController: LoginViewController) {
        loginInteractor = LoginInteractor()
        loginPresenter = LoginPresenter()
        
        viewController.presenterInterface = loginPresenter
        loginPresenter?.router = self
        loginPresenter?.viewInterface = viewController
        loginPresenter?.loginInteractor = loginInteractor
        loginInteractor?.output = loginPresenter
    }
    
}
