//
//  LoginPresenter.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

protocol LoginPresenterInterface {
    
}

class LoginPresenter {
    weak var viewInterface: LoginViewInterface!
    weak var router: LoginWireFrame!
    var loginInteractor: LoginInteractorInput!
}

extension LoginPresenter: LoginPresenterInterface {
    
}

extension LoginPresenter: LoginInteractorOutput {
    
}
