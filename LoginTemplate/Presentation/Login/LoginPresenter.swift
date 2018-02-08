//
//  LoginPresenter.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol LoginPresenterProtocol {
    func loginButtonPressed()
    func createAccountButtonPressed()
    func forgotPasswordButtonPressed()
    func facebookLoginButtonPressed(presenterViewController viewController: UIViewController)
    func googleLoginButtonPressed(presenterViewController viewController: UIViewController)
    
    var email: Variable<String> {get}
    var emailErrorString: Observable<String?> {get}
    
    var password: Variable<String> {get}
    var passwordErrorString: Observable<String?> {get}
    
    var loginButtonEnabled: Observable<Bool> {get}
    
    var loginRequestResponse: Observable<RequestResponse<User>> { get }
    var facebookRequestResponse: Observable<RequestResponse<User>> { get }
    var googleRequestResponse: Observable<RequestResponse<User>> { get }
}

class LoginPresenter: BasePresenter {
    weak var router: LoginWireFrameProtocol?
    let interactor: LoginInteractorProtocol
    
    init(interactor: LoginInteractorProtocol) {
        self.interactor = interactor
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    func loginButtonPressed() {
        interactor.authenticate()
    }
    
    func createAccountButtonPressed() {
        router?.goToCreateAccount()
    }
    
    func forgotPasswordButtonPressed() {
        router?.goToForgotPassword()
    }
    
    func facebookLoginButtonPressed(presenterViewController viewController: UIViewController) {
        interactor.facebookLogin(presenterViewController: viewController)
    }
    
    func googleLoginButtonPressed(presenterViewController viewController: UIViewController) {
        interactor.googleLogin(presenterViewController: viewController)
    }
    
    var email: Variable<String> {
        return interactor.email
    }
    
    var emailErrorString: Observable<String?> {
        return interactor.emailErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first {
                switch firstError {
                case .notValid:
                    return R.string.localizable.defaultEmailNotValid()
                case .empty:
                    return nil //Doesn't show if it is empty
                }
            }
            
            return nil
        })
    }
    
    var password: Variable<String> {
        return interactor.password
    }
    
    var passwordErrorString: Observable<String?> {
        return interactor.passwordErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first {
                switch firstError {
                case .minCharaters(let count):
                    return R.string.localizable.defaultPasswordValueMinimum("\(count)")
                case .empty:
                    return nil //Doesn't show if it is empty
                }
            }
            
            return nil
        })
    }
    
    var loginRequestResponse: Observable<RequestResponse<User>> {
        return interactor.authenticateResponse
    }
    
    var facebookRequestResponse: Observable<RequestResponse<User>> {
        return interactor.facebookLoginResponse
    }
    
    var googleRequestResponse: Observable<RequestResponse<User>> {
        return interactor.googleLoginResponse
    }
    
    var loginButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(interactor.emailErrors, interactor.passwordErrors, resultSelector: { (emailErrors, passwordErrors) -> Bool in
            return !(!emailErrors.isEmpty || !passwordErrors.isEmpty)
        })
    }
}

//extension LoginPresenter: LoginInteractorOutput {
//    func authenticateState(response: RequestResponse<User>){
//        loginRequestResponseVariable.value = response
//    }
//}
