//
//  LoginViewController.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

protocol LoginViewProtocol: BaseViewProtocol {
    
}

class LoginViewController: BaseScrollViewController, LoginViewProtocol {
    
    var presenter: LoginPresenterProtocol!
    
    private lazy var loginView: LoginView = {
        return LoginView.loadNibName(viewModel: presenter)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackgroundImage(#imageLiteral(resourceName: "img_bg"))
        addChildViewToScrollView(childView: loginView)
    }
}
