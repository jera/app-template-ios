//
//  MainWireFrame.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

enum MainPage {
    case login
    case dashboard
}

class MainWireFrame: BaseWireFrame {
    
    private let mainPresenter: MainPresenter
    private let mainViewController: MainViewController
    
    override init() {
        let mainPresenter = MainPresenter()
        let mainViewController = MainViewController(presenter: mainPresenter)
        
        self.mainPresenter = mainPresenter
        self.mainViewController = mainViewController
        
        super.init()
        
        configureDependencies()
    }
    
    var loginWireFrame: LoginWireFrame? {
        didSet {
            if let _ = loginWireFrame, let _ = dashboardWireFrame {
                self.dashboardWireFrame = nil
            }
        }
    }
    
    var dashboardWireFrame: DashboardWireFrame? {
        didSet {
            if let _ = dashboardWireFrame, let _ = loginWireFrame {
                self.loginWireFrame = nil
            }
        }
    }
    
    var page: MainPage? {
        didSet {
            if let page = page {
                if oldValue != page {
                    switch page {
                    case .login:
                        loginWireFrame = LoginWireFrame()
                        mainViewController.setCurrentViewController(viewController: loginWireFrame!.viewController)
                        
                    case .dashboard:
                        dashboardWireFrame = DashboardWireFrame()
                        mainViewController.setCurrentViewController(viewController: dashboardWireFrame!.viewController)
                    }
                }
            }
        }
    }
    
    func presentOn(window: UIWindow) {
        window.rootViewController = mainViewController
        window.makeKeyAndVisible()
    }
    
    func configureDependencies() {
        mainPresenter.router = self
        mainPresenter.userSessionInteractor = UserSessionInteractor.shared
        mainViewController.presenter = mainPresenter
    }

}
