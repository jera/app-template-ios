//
//  CreateAccountWireFrame.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift

protocol CreateAccountWireFrameInterface: class{
    func presentOn(viewController: UIViewController, presenterWireFrame: CreateAccountPresenterWireFrameInterface)
    func dismiss()
}

protocol CreateAccountPresenterWireFrameInterface: PresenterWireFrameInterface{
    
}

class CreateAccountWireFrame: BaseWireFrame {
    let navigationController: UINavigationController
    
    let createAccountPresenter: CreateAccountPresenterInterface
    let createAccountInteractor: CreateAccountInteractorInterface
    let createAccountViewController = CreateAccountViewController()
    let apiClientInterface: APIClientInterface = APIClient()
    
//    weak var presenterWireFrame: CreateAccountPresenterWireFrameInterface?
    
    override init() {
        createAccountInteractor = CreateAccountInteractor(repositoryInterface: CreateAccountRepository(apiClientInterface: apiClientInterface))
        let createAccountPresenter = CreateAccountPresenter(interactorInterface: createAccountInteractor)
        self.createAccountPresenter = createAccountPresenter
        
        createAccountViewController.presenterInterface = createAccountPresenter
        
        navigationController = BaseNavigationController(rootViewController: createAccountViewController)
        
        super.init()
        
        createAccountPresenter.routerInterface = self
    }
}

extension CreateAccountWireFrame: CreateAccountWireFrameInterface{
    func presentOn(viewController: UIViewController, presenterWireFrame: CreateAccountPresenterWireFrameInterface) {
        self.presenterWireFrame = presenterWireFrame
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func dismiss() {
        createAccountViewController.dismiss(animated: true) { [weak self] in
            self?.presenterWireFrame?.wireframeDidDismiss()
        }
    }
}
