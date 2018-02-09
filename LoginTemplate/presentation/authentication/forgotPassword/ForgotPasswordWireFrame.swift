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
    
    let presenter: ForgotPasswordPresenter
    let interactor: ForgotPasswordInteractor
    let viewController = ForgotPasswordViewController()
//    let apiClient: APIClientProtocol = APIClient()
    
    override init() {
        interactor = ForgotPasswordInteractor(repository: ForgotPasswordRepository())
        let presenter = ForgotPasswordPresenter(interactor: interactor)
        self.presenter = presenter
        
        viewController.presenter = presenter
        
        navigationController = BaseNavigationController(rootViewController: viewController)
        
        super.init()
        
        presenter.router = self
    }
    
}
extension ForgotPasswordWireFrame: ForgotPasswordWireFrameProtocol {
    func presentOn(viewController: UIViewController, presenterWireFrame: ForgotPasswordPresenterWireFrameProtocol) {
        self.presenterWireFrame = presenterWireFrame
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func dismiss() {
        viewController.dismiss(animated: true) { [weak self] in
            self?.presenterWireFrame?.wireframeDidDismiss()
        }
    }
}
