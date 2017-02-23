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
    
    func facebookLogin(presenterViewController viewController: UIViewController)
    var facebookLoginResponse: Observable<RequestResponse<User>> { get }
    
    func googleLogin(presenterViewController viewController: UIViewController)
    var googleLoginResponse: Observable<RequestResponse<User>> { get }
    
    var email: Variable<String> {get}
    var emailErrors: Observable<[EmailFieldError]> {get}
    
    var password: Variable<String> {get}
    var passwordErrors: Observable<[PasswordFieldError]> {get}
}

class LoginInteractor: BaseInteractor {
    let repositoryInterface: LoginRepositoryInterface
    
    let authenticateResponseVariable = Variable<RequestResponse<User>>(.new)
    let facebookLoginResponseVariable = Variable<RequestResponse<User>>(.new)
    let googleLoginResponseVariable = Variable<RequestResponse<User>>(.new)
    
    let email = Variable("")
    let password = Variable("")
    
    fileprivate var authenticateDisposeBag: DisposeBag!
    fileprivate var facebookLoginDisposeBag: DisposeBag!
    fileprivate var googleLoginDisposeBag: DisposeBag!
    
    init(repositoryInterface: LoginRepositoryInterface) {
        self.repositoryInterface = repositoryInterface
    }
}

extension LoginInteractor: LoginInteractorInterface {
    
    var authenticateResponse: Observable<RequestResponse<User>>{
        return authenticateResponseVariable.asObservable()
    }
    
    var facebookLoginResponse: Observable<RequestResponse<User>>{
        return facebookLoginResponseVariable.asObservable()
    }
    
    var googleLoginResponse: Observable<RequestResponse<User>>{
        return googleLoginResponseVariable.asObservable()
    }
    
    func authenticate(){
        authenticateDisposeBag = DisposeBag()
        
        authenticateResponseVariable.value = .loading
        
        //TODO: fazer o subscribe no repository
        repositoryInterface
            .authenticate(email: email.value, password: password.value)
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
    
    func facebookLogin(presenterViewController viewController: UIViewController) {
        facebookLoginDisposeBag = DisposeBag()
        
        facebookLoginResponseVariable.value = .loading
        
        repositoryInterface
            .facebookLogin(presenterViewController: viewController)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event{
                case .next(let userAPI):
                    
                    guard let user = User(userAPI: userAPI) else{
                        strongSelf.facebookLoginResponseVariable.value = .failure(error: APIClient.error(description: "API retornou um usuário inválido: \(userAPI)"))
                        return
                    }
                    
                    strongSelf.facebookLoginResponseVariable.value = .success(responseObject: user)
                    
                case .error(let error):
                    strongSelf.facebookLoginResponseVariable.value = .failure(error: error)
                case .completed:
                    break
                }
            }
            .addDisposableTo(facebookLoginDisposeBag)
    }
    
    func googleLogin(presenterViewController viewController: UIViewController) {
        googleLoginDisposeBag = DisposeBag()
        
        googleLoginResponseVariable.value = .loading
        
        repositoryInterface
            .googleLogin(presenterViewController: viewController)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event{
                case .next(let userAPI):
                    
                    guard let user = User(userAPI: userAPI) else{
                        strongSelf.googleLoginResponseVariable.value = .failure(error: APIClient.error(description: "API retornou um usuário inválido: \(userAPI)"))
                        return
                    }
                    
                    strongSelf.googleLoginResponseVariable.value = .success(responseObject: user)
                    
                case .error(let error):
                    strongSelf.googleLoginResponseVariable.value = .failure(error: error)
                case .completed:
                    break
                }
            }
            .addDisposableTo(googleLoginDisposeBag)
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
