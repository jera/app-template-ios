//
//  ForgotPasswordPresenter.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol ForgotPasswordPresenterInterface {
    func forgotPasswordPressed()
    func didTapCloseForgotPasswordView()
    
    var email: Variable<String> {get}
    var emailErrorString: Observable<String?> {get}
    var forgotPasswordButtonEnabled: Observable<Bool> {get}
    var forgotPasswordRequestResponse: Observable<RequestResponse<String?>> { get }
}

class ForgotPasswordPresenter: BasePresenter {
    weak var router: ForgotPasswordWireFrame?
    var interactorInterface: ForgotPasswordInteractorInterface
    
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
    
    private var isEmailEmpty: Observable<Bool>{
        return self.email
            .asObservable()
            .map { (email) -> Bool in
                return email.characters.count == 0
        }
    }
    
    var forgotPasswordRequestResponse: Observable<RequestResponse<String?>>{
        return interactorInterface.forgotPasswordResponse
    }
    
    var forgotPasswordButtonEnabled: Observable<Bool>{
        return Observable.combineLatest(isEmailEmpty, emailErrorString, resultSelector: { (isEmailEmpty, emailErrorString) -> Bool in
            return !(isEmailEmpty || emailErrorString != nil)
        })
    }

    init(interactorInterface: ForgotPasswordInteractorInterface){
        self.interactorInterface = interactorInterface
    }
}

extension ForgotPasswordPresenter: ForgotPasswordPresenterInterface {
    func forgotPasswordPressed() {
        interactorInterface.sendNewPasswordToEmail()
    }
    
    func didTapCloseForgotPasswordView() {
        router?.dismiss()
    }
}
