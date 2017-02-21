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
    func facebookLoginButtonPressed()
    func googleLoginButtonPressed()
    
    var email: Variable<String> {get}
    var emailError: Observable<String?> {get}
    
    var password: Variable<String> {get}
    var passwordError: Observable<String?> {get}
    
    var loginButtonEnabled: Observable<Bool> {get}
    
    var loginRequestResponse: Observable<RequestResponse<Void>> { get }
}

class LoginPresenter: BasePresenter {
//    weak var viewInterface: LoginViewInterface!
    weak var router: LoginWireFrame?
    var interactorInterface: LoginInteractorInput?
    
    let email = Variable("")
    var emailError: Observable<String?>{
        return self.email
            .asObservable()
            .map { (email) -> String? in
                guard email.characters.count > 0 else { return nil }
                
                if !DomainHelper.isEmailValid(email: email){
                    return "Email inválido"
                }
                
                return nil
        }
    }
    private var isEmailEmpty: Observable<Bool>{
        return self.email
            .asObservable()
            .map { (email) -> Bool in
                return email.characters.count == 0
        }
    }
    
    let password = Variable("")
    var passwordError: Observable<String?>{
        return self.password
            .asObservable()
            .map { (password) -> String? in
                guard password.characters.count > 0 else { return nil }
                
                if password.characters.count < 6{
                    return "Senha deve ter no mínimo 6 caracteres"
                }
                
                return nil
        }
    }
    
    private var isPasswordEmpty: Observable<Bool>{
        return self.password
            .asObservable()
            .map { (password) -> Bool in
                return password.characters.count == 0
        }
    }
    
    
    
    fileprivate let loginRequestResponseVariable = Variable<RequestResponse<User>>(.new)
    var loginRequestResponse: Observable<RequestResponse<Void>>{
        return loginRequestResponseVariable.asObservable().map({ (requestResponse) -> RequestResponse<Void> in
            switch requestResponse{
            case .new:
                return .new
            case .loading:
                return .loading
            case .success:
                return .success(responseObject: ())
            case .failure(let error):
                return .failure(error: error)
            }
        })
    }
    
    var loginButtonEnabled: Observable<Bool>{
        return Observable.combineLatest(isEmailEmpty, emailError, isPasswordEmpty, passwordError, resultSelector: { (isEmailEmpty, emailError, isPasswordEmpty, passwordError) -> Bool in
            return !(isEmailEmpty || emailError != nil || isPasswordEmpty || passwordError != nil)
        })
    }
}

extension LoginPresenter: LoginPresenterInterface {
    func loginButtonPressed() {
        //interactorInterface?.authenticate(byEmail: email.value, password: password.value)
        router?.presentForgotPassword()
    }
    
    func createAccountButtonPressed(){
        
    }
    
    func forgotPasswordButtonPressed(){
        
    }
    
    func facebookLoginButtonPressed(){
        
    }
    
    func googleLoginButtonPressed(){
        
    }
}

extension LoginPresenter: LoginInteractorOutput {
    func authenticateState(response: RequestResponse<User>){
        loginRequestResponseVariable.value = response
    }
}
