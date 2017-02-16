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
    func authenticateState(response: RequestResponse<User>)
}

class LoginInteractor {
    weak var outputInterface: LoginInteractorOutput?
    
    fileprivate var authenticateDisposeBag: DisposeBag!
}

extension LoginInteractor: LoginInteractorInput {
    func authenticate(byEmail email: String, password:String){
        authenticateDisposeBag = DisposeBag()
        
        outputInterface?.authenticateState(response: .loading)
        
        APIClient
            .loginWith(email: email, password: password)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event{
                case .next(let userAPI):
                    
                    guard let user = User(userAPI: userAPI) else{
                        strongSelf.outputInterface?.authenticateState(response: .failure(error: APIClient.error(description: "API retornou um usuário inválido: \(userAPI)")))
                        return
                    }
                    
                    strongSelf.outputInterface?.authenticateState(response: .success(responseObject: user))

                case .error(let error):
                    strongSelf.outputInterface?.authenticateState(response: .failure(error: error))
                case .completed:
                    break
                }
            }
            .addDisposableTo(authenticateDisposeBag)
    }
}
