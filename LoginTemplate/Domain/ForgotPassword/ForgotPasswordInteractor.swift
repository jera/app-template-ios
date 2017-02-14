//
//  ForgotPasswordInteractor.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

protocol ForgotPasswordInteractorInput {
    
}

protocol ForgotPasswordInteractorOutput: class {
    
}

class ForgotPasswordInteractor {
    weak var output: ForgotPasswordInteractorOutput!
}

extension ForgotPasswordInteractor: ForgotPasswordInteractorInput {
    
}

