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
    
    private var navigationController: UINavigationController
    private let presenter: ForgotPasswordPresenterProtocol
    private let interactor: ForgotPasswordInteractorProtocol
    private let viewController: ForgotPasswordViewController
    
    override init() {
        let interactor = ForgotPasswordInteractor(repository: ForgotPasswordRepository(apiClient: APIClient()))
        let presenter = ForgotPasswordPresenter(interactor: interactor)
        
        self.viewController = ForgotPasswordViewController(presenter: presenter)
        self.interactor = interactor
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
