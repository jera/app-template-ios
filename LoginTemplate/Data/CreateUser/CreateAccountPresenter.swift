//
//  CreateAccountPresenter.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol CreateAccountPresenterInterface{
    func createButtonPressed()
    func chooseUserImageButtonPressed()
    func closeButtonPressed()
    
    var name: Variable<String> {get}
    var nameErrorsString: Observable<String?> {get}
    
    var email: Variable<String> {get}
    var emailErrorsString: Observable<String?> {get}
    
    var phone: Variable<String> {get}
    var phoneErrorsString: Observable<String?> {get}
    
    var cpf: Variable<String> {get}
    var cpfErrorsString: Observable<String?> {get}
    
    var password: Variable<String> {get}
    var passwordErrorsString: Observable<String?> {get}
    
    var passwordConfirm: Variable<String> {get}
    var passwordConfirmErrorsString: Observable<String?> {get}
    
    var createAccountButtonEnabled: Observable<Bool> {get}
    
    var createAccountRequestResponse: Observable<RequestResponse<User>> { get }
}

class CreateAccountPresenter: BasePresenter {
    weak var routerInterface: CreateAccountWireFrameInterface?
    let interactorInterface: CreateAccountInteractorInterface

    init(interactorInterface: CreateAccountInteractorInterface){
        self.interactorInterface = interactorInterface
    }
}

extension CreateAccountPresenter: CreateAccountPresenterInterface{
    func createButtonPressed() {
        interactorInterface.createAccount()
    }
    
    func chooseUserImageButtonPressed(){
        print("todo")
    }
    
    func closeButtonPressed(){
        routerInterface?.dismiss()
    }
    
    var name: Variable<String>{
        return interactorInterface.name
    }
    
    var nameErrorsString: Observable<String?>{
        return interactorInterface.nameErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first{
                switch firstError{
                case .empty:
                    return nil //Doesn't show if it is empty
                }
            }
            
            return nil
        })
    }
    
    var email: Variable<String>{
        return interactorInterface.email
    }
    
    var emailErrorsString: Observable<String?>{
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
    
    var phone: Variable<String>{
        return interactorInterface.phone
    }
    
    var phoneErrorsString: Observable<String?>{
        return interactorInterface.phoneErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first{
                switch firstError{
                case .minCharaters(let count):
                    return "Telefone deve ter no mínimo \(count) caracteres"
                case .empty:
                    return nil //Doesn't show if it is empty
                }
            }
            
            return nil
        })
    }
    
    var cpf: Variable<String>{
        return interactorInterface.cpf
    }
    
    var cpfErrorsString: Observable<String?>{
        return interactorInterface.cpfErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first{
                switch firstError{
                case .minCharaters(let count):
                    return "CPF deve ter no mínimo \(count) caracteres"
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
    
    var passwordErrorsString: Observable<String?>{
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
    
    var passwordConfirm: Variable<String>{
        return interactorInterface.passwordConfirm
    }
    
    var passwordConfirmErrorsString: Observable<String?>{
        return interactorInterface.passwordConfirmErrors.map({ (fieldErrors) -> String? in
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
    
    var createAccountButtonEnabled: Observable<Bool>{
        return Observable.combineLatest(interactorInterface.emailErrors, interactorInterface.passwordErrors, resultSelector: { (emailErrors, passwordErrors) -> Bool in
            return !(emailErrors.count > 0 || passwordErrors.count > 0)
        })
    }
    
    var createAccountRequestResponse: Observable<RequestResponse<User>>{
        return interactorInterface.createAccountResponse
    }
}
