//
//  ForgotPasswordWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

protocol ForgotPasswordWireFrameInterface: class{
    func presentOn(viewController: UIViewController, presenterWireFrame: ForgotPasswordPresenterWireFrameInterface)
    func dismiss()
}

protocol ForgotPasswordPresenterWireFrameInterface: class{
    func dismissForgotPassword()
}

class ForgotPasswordWireFrame: BaseWireFrame {
    
    var navigationController: UINavigationController
    
    let forgotPasswordPresenter: ForgotPasswordPresenter
    let forgotPasswordInteractor: ForgotPasswordInteractor
    let forgotPasswordViewController = ForgotPasswordViewController()
    let apiClientInterface: APIClientInterface = APIClient()
    
    weak var presenterWireFrame: ForgotPasswordPresenterWireFrameInterface?
    
    override init() {
        forgotPasswordInteractor = ForgotPasswordInteractor(repositoryInterface: ForgotPasswordRepository(apiClientInterface: apiClientInterface))
        let forgotPasswordPresenter = ForgotPasswordPresenter(interactorInterface: forgotPasswordInteractor)
        self.forgotPasswordPresenter = forgotPasswordPresenter
        
        forgotPasswordViewController.presenterInterface = forgotPasswordPresenter
        
        navigationController = BaseNavigationController(rootViewController: forgotPasswordViewController)
        
        super.init()
        
        forgotPasswordPresenter.router = self
    }
    
}
extension ForgotPasswordWireFrame: ForgotPasswordWireFrameInterface{
    func presentOn(viewController: UIViewController, presenterWireFrame: ForgotPasswordPresenterWireFrameInterface) {
        self.presenterWireFrame = presenterWireFrame
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func dismiss() {
        presenterWireFrame?.dismissForgotPassword()
    }
}
