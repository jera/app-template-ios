//
//  LoginViewController.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

protocol LoginViewInterface: BaseViewInterface {
    
}

class LoginViewController: BaseViewController {

    var presenterInterface: LoginPresenterInterface?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
    }
    
}

extension LoginViewController: LoginViewInterface {

}
