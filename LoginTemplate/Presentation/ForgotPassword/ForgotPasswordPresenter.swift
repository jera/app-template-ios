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
    var emailError: Observable<String?> {get}
    
    var forgotPasswordButtonEnabled: Observable<Bool> {get}
}

class ForgotPasswordPresenter {
    weak var viewInterface: ForgotPasswordInterface!
    weak var router: ForgotPasswordWireFrame!
    var interactorInterface: ForgotPasswordInteractorInput!
    
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
    
    var forgotPasswordButtonEnabled: Observable<Bool>{
        return Observable.combineLatest(isEmailEmpty, emailError, resultSelector: { (isEmailEmpty, emailError) -> Bool in
            return !(isEmailEmpty || emailError != nil)
        })
    }
    
}

extension ForgotPasswordPresenter: ForgotPasswordPresenterInterface {
    func forgotPasswordPressed() {
        interactorInterface?.sendNewPasswordTo(email: email.value)
    }
    
    func didTapCloseForgotPasswordView() {
        router.popForgotPassword()
    }
}

extension ForgotPasswordPresenter: ForgotPasswordInteractorOutput {
    func showLoading(){
        viewInterface.showLoading()
    }
    func showMessageForgotMyPasswordWith(sucess: String){
        viewInterface.showMessageForgotMyPasswordWith(sucess: sucess)
    }
    func showMessageForgotMyPasswordWith(error: Error){
        viewInterface.showMessageForgotMyPasswordWith(error: error)
    }
}
