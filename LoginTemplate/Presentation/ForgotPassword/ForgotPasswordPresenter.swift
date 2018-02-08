//
//  ForgotPasswordPresenter.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol ForgotPasswordPresenterProtocol {
    func forgotPasswordPressed()
    func didTapCloseForgotPasswordView()
    
    var email: Variable<String> {get}
    var emailErrorString: Observable<String?> {get}
    var forgotPasswordButtonEnabled: Observable<Bool> {get}
    var forgotPasswordRequestResponse: Observable<RequestResponse<String?>> { get }
}

class ForgotPasswordPresenter: BasePresenter {
    weak var router: ForgotPasswordWireFrame?
    var interactor: ForgotPasswordInteractorProtocol
    
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
    
    private var isEmailEmpty: Observable<Bool> {
        return self.email
            .asObservable()
            .map { (email) -> Bool in
                return email.isEmpty
        }
    }
    
    var forgotPasswordRequestResponse: Observable<RequestResponse<String?>> {
        return interactor.forgotPasswordResponse
    }
    
    var forgotPasswordButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isEmailEmpty, emailErrorString, resultSelector: { (isEmailEmpty, emailErrorString) -> Bool in
            return !(isEmailEmpty || emailErrorString != nil)
        })
    }

    init(interactor: ForgotPasswordInteractorProtocol) {
        self.interactor = interactor
    }
}

extension ForgotPasswordPresenter: ForgotPasswordPresenterProtocol {
    func forgotPasswordPressed() {
        interactor.sendNewPasswordToEmail()
    }
    
    func didTapCloseForgotPasswordView() {
        router?.dismiss()
    }
}
