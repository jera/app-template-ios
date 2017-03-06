//
//  LoginPresenter.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol LoginPresenterInterface {
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
    weak var routerInterface: LoginWireFrameInterface?
    let interactorInterface: LoginInteractorInterface
    
    init(interactorInterface: LoginInteractorInterface){
        self.interactorInterface = interactorInterface
    }
}

extension LoginPresenter: LoginPresenterInterface {
    func loginButtonPressed() {
        interactorInterface.authenticate()
    }
    
    func createAccountButtonPressed(){
        routerInterface?.goToCreateAccount()
    }
    
    func forgotPasswordButtonPressed(){
        routerInterface?.goToForgotPassword()
    }
    
    func facebookLoginButtonPressed(presenterViewController viewController: UIViewController){
        interactorInterface.facebookLogin(presenterViewController: viewController)
    }
    
    func googleLoginButtonPressed(presenterViewController viewController: UIViewController){
        interactorInterface.googleLogin(presenterViewController: viewController)
    }
    
    var email: Variable<String>{
        return interactorInterface.email
    }
    
    var emailErrorString: Observable<String?>{
        return interactorInterface.emailErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first{
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
    
    var password: Variable<String>{
        return interactorInterface.password
    }
    
    var passwordErrorString: Observable<String?>{
        return interactorInterface.passwordErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first{
                switch firstError{
                case .minCharaters(let count):
//                    return "Senha deve ter no mínimo \(count) caracteres"
                    return "\(R.string.localizable.defaultPasswordValueMinimum()) \(count) \(R.string.localizable.defaultCharacter())" //FIZ MAS NAO CONCORDO
                case .empty:
                    return nil //Doesn't show if it is empty
                }
            }
            
            return nil
        })
    }
    
    var loginRequestResponse: Observable<RequestResponse<User>>{
        return interactorInterface.authenticateResponse
    }
    
    var facebookRequestResponse: Observable<RequestResponse<User>>{
        return interactorInterface.facebookLoginResponse
    }
    
    var googleRequestResponse: Observable<RequestResponse<User>>{
        return interactorInterface.googleLoginResponse
    }
    
    var loginButtonEnabled: Observable<Bool>{
        return Observable.combineLatest(interactorInterface.emailErrors, interactorInterface.passwordErrors, resultSelector: { (emailErrors, passwordErrors) -> Bool in
            return !(emailErrors.count > 0 || passwordErrors.count > 0)
        })
    }
}

//extension LoginPresenter: LoginInteractorOutput {
//    func authenticateState(response: RequestResponse<User>){
//        loginRequestResponseVariable.value = response
//    }
//}
