//
//  DashboardWireFrame.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

class DashboardWireFrame: BaseWireFrame {
    
    let presenter: DashboardPresenter
    let viewController: DashboardViewController

    override init() {
        let presenter = DashboardPresenter()
        let viewController = DashboardViewController(presenter: presenter, nibName: "DashboardViewController")
        
        self.presenter = presenter
        self.viewController = viewController
    }
}
