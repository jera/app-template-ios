//
//  LoginInteractor.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol LoginInteractorInput {
    func authenticate(byEmail: String, password:String)
}

protocol LoginInteractorOutput: class {
    
}

class LoginInteractor {
    weak var output: LoginInteractorOutput?
    
    fileprivate var authenticateDisposeBag: DisposeBag!
}

extension LoginInteractor: LoginInteractorInput {
    func authenticate(byEmail email: String, password:String){
        authenticateDisposeBag = DisposeBag()
        
//        APIClient
//            .loginWith(email: email, password: password)
//            .subscribe { (event) in
//                switch event{
//                    
//                }
//            }
//            .addDisposableTo(authenticateDisposeBag)
    }
}
