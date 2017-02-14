//
//  ForgotPasswordPresenter.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

protocol ForgotPasswordPresenterInterface {
    
}

class ForgotPasswordPresenter {
    weak var viewInterface: ForgotPasswordInterface!
    weak var router: ForgotPasswordWireFrame!
    var forgotPasswordInteractor: ForgotPasswordInteractorInput!
}

extension ForgotPasswordPresenter: ForgotPasswordPresenterInterface {
    
}

extension ForgotPasswordPresenter: ForgotPasswordInteractorOutput {
    
}
