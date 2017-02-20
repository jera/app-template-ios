//
//  LoginInteractor.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol LoginInteractorInterface {
    func authenticate()
    
    var authenticateResponse: Observable<RequestResponse<User>> { get }
    
    var email: Variable<String> {get}
    var emailErrors: Observable<[EmailFieldError]> {get}
    
    var password: Variable<String> {get}
    var passwordErrors: Observable<[PasswordFieldError]> {get}
}

class LoginInteractor {
    var apiClientInterface: APIClientInterface!
    
    let authenticateResponseVariable = Variable<RequestResponse<User>>(.new)
    
    let email = Variable("")
    let password = Variable("")
    
    fileprivate var authenticateDisposeBag: DisposeBag!
}

extension LoginInteractor: LoginInteractorInterface {
    
    var authenticateResponse: Observable<RequestResponse<User>>{
        return authenticateResponseVariable.asObservable()
    }
    
    func authenticate(){
        authenticateDisposeBag = DisposeBag()
        
        authenticateResponseVariable.value = .loading
        
        //Isso deve ser chamado do interactor ou ele não deve saber se o dado está vindo da api ou de qualquer lugar?
        //Vou deixar isso no interactor até achar um bom motivo para mover uma camada para baixo e aumentar o overhead
        apiClientInterface
            .loginWith(email: email.value, password: password.value)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event{
                case .next(let userAPI):
                    
                    guard let user = User(userAPI: userAPI) else{
                        strongSelf.authenticateResponseVariable.value = .failure(error: APIClient.error(description: "API retornou um usuário inválido: \(userAPI)"))
                        return
                    }
                    
                    strongSelf.authenticateResponseVariable.value = .success(responseObject: user)

                case .error(let error):
                    strongSelf.authenticateResponseVariable.value = .failure(error: error)
                case .completed:
                    break
                }
            }
            .addDisposableTo(authenticateDisposeBag)
    }
    
    var emailErrors: Observable<[EmailFieldError]>{
        return self.email
            .asObservable()
            .map { (email) -> [EmailFieldError] in
                var fieldErrors = [EmailFieldError]()
                
                if email.characters.count == 0 {
                    fieldErrors.append(.empty)
                }
                
                if !DomainHelper.isEmailValid(email: email){
                    fieldErrors.append(.notValid)
                }
                
                return fieldErrors
        }
    }
    
    var passwordErrors: Observable<[PasswordFieldError]>{
        return self.password
            .asObservable()
            .map { (password) -> [PasswordFieldError] in
                var fieldErrors = [PasswordFieldError]()
                
                if password.characters.count == 0 {
                    fieldErrors.append(.empty)
                }
                
                if password.characters.count < 6{
                    fieldErrors.append(.minCharaters(count: 6))
                }
                
                return fieldErrors
        }
    }
}
