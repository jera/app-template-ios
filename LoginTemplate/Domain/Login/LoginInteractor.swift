//
//  LoginInteractor.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

protocol LoginInteractorInput {
    
}

protocol LoginInteractorOutput: class {
    
}

class LoginInteractor {
    weak var output: LoginInteractorOutput!
}

extension LoginInteractor: LoginInteractorInput {

}
