//
//  ForgotPasswordViewController.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

protocol ForgotPasswordInterface: BaseViewInterface {
    
}

class ForgotPasswordViewController: BaseViewController {
    
    var presenterInterface: ForgotPasswordPresenterInterface?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
    }
    
}

extension ForgotPasswordViewController: ForgotPasswordInterface {
    
}
