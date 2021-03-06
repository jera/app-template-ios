//
//  LoginInteractor.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol LoginInteractorProtocol {
    var email: Variable<String> {get}
    var password: Variable<String> {get}
    var emailErrors: Observable<[EmailFieldError]> {get}
    var passwordErrors: Observable<[PasswordFieldError]> {get}
    var authenticateResponse: Observable<RequestResponse<User>> { get }
    var facebookLoginResponse: Observable<RequestResponse<User>> { get }
    var googleLoginResponse: Observable<RequestResponse<User>> { get }
    
    func authenticate()
    func facebookLogin(presenterViewController viewController: UIViewController)
    func googleLogin(presenterViewController viewController: UIViewController)
}

class LoginInteractor: BaseInteractor {
    let repository: LoginRepositoryProtocol
    
    let email = Variable("")
    let password = Variable("")
    let authenticateResponseVariable = Variable<RequestResponse<User>>(.new)
    let facebookLoginResponseVariable = Variable<RequestResponse<User>>(.new)
    let googleLoginResponseVariable = Variable<RequestResponse<User>>(.new)
    
    fileprivate var authenticateDisposeBag: DisposeBag!
    fileprivate var facebookLoginDisposeBag: DisposeBag!
    fileprivate var googleLoginDisposeBag: DisposeBag!
    
    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
        super.init()
        
        #if DEBUG
            email.value = "moquiuti@jera.com.br"
            password.value = "123456"
        #endif
    }
}

extension LoginInteractor: LoginInteractorProtocol {
    
    var authenticateResponse: Observable<RequestResponse<User>> {
        return authenticateResponseVariable.asObservable()
    }
    
    var facebookLoginResponse: Observable<RequestResponse<User>> {
        return facebookLoginResponseVariable.asObservable()
    }
    
    var googleLoginResponse: Observable<RequestResponse<User>> {
        return googleLoginResponseVariable.asObservable()
    }
    
    var emailErrors: Observable<[EmailFieldError]> {
        return self.email
            .asObservable()
            .map { (email) -> [EmailFieldError] in
                var fieldErrors = [EmailFieldError]()
                
                if email.isEmpty {
                    fieldErrors.append(.empty)
                }
                
                if !email.isValidEmail() {
                    fieldErrors.append(.notValid)
                }
                
                return fieldErrors
        }
    }
    
    var passwordErrors: Observable<[PasswordFieldError]> {
        return self.password
            .asObservable()
            .map { (password) -> [PasswordFieldError] in
                var fieldErrors = [PasswordFieldError]()
                
                if password.isEmpty {
                    fieldErrors.append(.empty)
                }
                
                if password.count < 6 {
                    fieldErrors.append(.minCharaters(count: 6))
                }
                
                return fieldErrors
        }
    }
    
    func authenticate() {
        authenticateDisposeBag = DisposeBag()

        authenticateResponseVariable.value = .loading

        //TODO: fazer o subscribe no repository
        repository
            .authenticate(email: email.value, password: password.value)
            .subscribe({[weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event {
                case .success(let userAPI):
                    
                    guard let user = User(userAPI: userAPI) else {
                        strongSelf.authenticateResponseVariable.value = .failure(error: APIClient.error(description: "\(R.string.localizable.messageUserInvalid()) \(userAPI)"))
                        return
                    }
                    
                    strongSelf.authenticateResponseVariable.value = .success(responseObject: user)
                    
                case .error(let error):
                    strongSelf.authenticateResponseVariable.value = .failure(error: error)
                }
            })
            .disposed(by: authenticateDisposeBag)
    }
    
    func facebookLogin(presenterViewController viewController: UIViewController) {
        facebookLoginDisposeBag = DisposeBag()

        facebookLoginResponseVariable.value = .loading

        repository
            .facebookLogin(presenterViewController: viewController)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }

                switch event {
                case .success(let userAPI):

                    guard let user = User(userAPI: userAPI) else {
                        strongSelf.facebookLoginResponseVariable.value = .failure(error: APIClient.error(description: "\(R.string.localizable.messageUserInvalid()) \(userAPI)"))
                        return
                    }

                    strongSelf.facebookLoginResponseVariable.value = .success(responseObject: user)

                case .error(let error):
                    strongSelf.facebookLoginResponseVariable.value = .failure(error: error)
                    
                }
            }
            .disposed(by: facebookLoginDisposeBag)
    }
    
    func googleLogin(presenterViewController viewController: UIViewController) {
        googleLoginDisposeBag = DisposeBag()

        googleLoginResponseVariable.value = .loading

        repository
            .googleLogin(presenterViewController: viewController)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }

                switch event {
                case .success(let userAPI):

                    guard let user = User(userAPI: userAPI) else {
                        strongSelf.googleLoginResponseVariable.value = .failure(error: APIClient.error(description: "\(R.string.localizable.messageUserInvalid()) \(userAPI)"))
                        return
                    }

                    strongSelf.googleLoginResponseVariable.value = .success(responseObject: user)

                case .error(let error):
                    strongSelf.googleLoginResponseVariable.value = .failure(error: error)
                    
                }
            }
            .disposed(by: googleLoginDisposeBag)
    }
}
