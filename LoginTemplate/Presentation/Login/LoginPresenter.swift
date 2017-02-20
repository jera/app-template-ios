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
    var emailErrorString: Observable<String?> {get}
    
    var password: Variable<String> {get}
    var passwordErrorString: Observable<String?> {get}
    
    var loginButtonEnabled: Observable<Bool> {get}
    
    var loginRequestResponse: Observable<RequestResponse<Void>> { get }
}

class LoginPresenter: BasePresenter {
    weak var router: LoginWireFrame?
    var interactorInterface: LoginInteractorInterface!
    
    var email: Variable<String>{
        return interactorInterface.email
    }
    var emailErrorString: Observable<String?>{
        return interactorInterface.emailErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first{
                switch firstError {
                case .notValid:
                    return "Email não válido"
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
                    return "Senha deve ter no mínimo \(count) caracteres"
                case .empty:
                    return nil //Doesn't show if it is empty
                }
            }
            
            return nil
        })
    }
    
    var loginRequestResponse: Observable<RequestResponse<Void>>{
        return interactorInterface.authenticateResponse
            .map({ (requestResponse) -> RequestResponse<Void> in
                switch requestResponse{
                case .new:
                    return .new
                case .loading:
                    return .loading
                case .success:
                    return .success(responseObject: ())
                case .failure(let error):
                    return .failure(error: error)
                case .cancelled:
                    return .cancelled
                }
            })
    }
    
    var loginButtonEnabled: Observable<Bool>{
        return Observable.combineLatest(interactorInterface.emailErrors, interactorInterface.passwordErrors, resultSelector: { (emailErrors, passwordErrors) -> Bool in
            return !(emailErrors.count > 0 || passwordErrors.count > 0)
        })
    }
}

extension LoginPresenter: LoginPresenterInterface {
    func loginButtonPressed() {
        interactorInterface.authenticate()
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

//extension LoginPresenter: LoginInteractorOutput {
//    func authenticateState(response: RequestResponse<User>){
//        loginRequestResponseVariable.value = response
//    }
//}
