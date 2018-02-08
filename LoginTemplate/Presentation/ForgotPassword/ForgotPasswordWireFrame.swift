//
//  ForgotPasswordWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

protocol ForgotPasswordWireFrameProtocol: class {
    func presentOn(viewController: UIViewController, presenterWireFrame: ForgotPasswordPresenterWireFrameProtocol)
    func dismiss()
}

protocol ForgotPasswordPresenterWireFrameProtocol: PresenterWireFrameProtocol {
}

class ForgotPasswordWireFrame: BaseWireFrame {
    
    var navigationController: UINavigationController
    
    let forgotPasswordPresenter: ForgotPasswordPresenter
    let forgotPasswordInteractor: ForgotPasswordInteractor
    let forgotPasswordViewController = ForgotPasswordViewController()
    let apiClient: APIClientProtocol = APIClient()
    
    override init() {
        forgotPasswordInteractor = ForgotPasswordInteractor(repository: ForgotPasswordRepository(apiClient: apiClient))
        let forgotPasswordPresenter = ForgotPasswordPresenter(interactor: forgotPasswordInteractor)
        self.forgotPasswordPresenter = forgotPasswordPresenter
        
        forgotPasswordViewController.presenter = forgotPasswordPresenter
        
        navigationController = BaseNavigationController(rootViewController: forgotPasswordViewController)
        
        super.init()
        
        forgotPasswordPresenter.router = self
    }
    
}
extension ForgotPasswordWireFrame: ForgotPasswordWireFrameProtocol {
    func presentOn(viewController: UIViewController, presenterWireFrame: ForgotPasswordPresenterWireFrameProtocol) {
        self.presenterWireFrame = presenterWireFrame
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func dismiss() {
        forgotPasswordViewController.dismiss(animated: true) { [weak self] in
            self?.presenterWireFrame?.wireframeDidDismiss()
        }
    }
}
