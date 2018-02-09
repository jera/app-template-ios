//
//  DashboardWireFrame.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

class DashboardWireFrame: BaseWireFrame {
    
    var presenter = DashboardPresenter()
    var viewController = DashboardViewController(nibName: "DashboardViewController", bundle: nil)

}
