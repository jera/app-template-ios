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
    
    var userImage: Observable<UIImage?> {get}
    
    var name: Variable<String> {get}
    var nameErrorString: Observable<String?> {get}
    
    var email: Variable<String> {get}
    var emailErrorString: Observable<String?> {get}
    
    var phone: Variable<String> {get}
    var phoneErrorString: Observable<String?> {get}
    
    var cpf: Variable<String> {get}
    var cpfErrorString: Observable<String?> {get}
    
    var password: Variable<String> {get}
    var passwordErrorString: Observable<String?> {get}
    
    var passwordConfirm: Variable<String> {get}
    var passwordConfirmErrorString: Observable<String?> {get}
    
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
        routerInterface?.chooseUserImageButtonPressed(showDeleteCurrentImage: interactorInterface.userImage.value != nil)
    }
    
    func closeButtonPressed(){
        routerInterface?.dismiss()
    }
    
    var userImage: Observable<UIImage?>{
        return interactorInterface.userImage.asObservable()
    }
    
    var name: Variable<String>{
        return interactorInterface.name
    }
    
    var nameErrorString: Observable<String?>{
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
    
    var phone: Variable<String>{
        return interactorInterface.phone
    }
    
    var phoneErrorString: Observable<String?>{
        return interactorInterface.phoneErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first{
                switch firstError{
                case .minCharaters(let count):
//                    return "Telefone deve ter no mínimo \(count) caracteres"
                    return "\(R.string.localizable.defaultPhoneValueMinimum()) \(count) \(R.string.localizable.defaultCharacter())" //FIZ MAS NAO CONCORDO
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
    
    var cpfErrorString: Observable<String?>{
        return interactorInterface.cpfErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first{
                switch firstError{
                case .notValid:
                    return R.string.localizable.createAccountCpfInvalid()
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
//                    return "Senha deve ter no mínimo \(count) caracteres"\
                    return "\(R.string.localizable.defaultPasswordValueMinimum()) \(count) \(R.string.localizable.defaultCharacter())" //FIZ MAS NAO CONCORDO

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
    
    var passwordConfirmErrorString: Observable<String?>{
        return interactorInterface.passwordConfirmErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first{
                switch firstError{
                case .confirmPasswordNotMatch:
                    return R.string.localizable.createAccountPasswordNotEqual()
                }
            }
            
            return nil
        })
    }

    var createAccountButtonEnabled: Observable<Bool>{
        return Observable.combineLatest(interactorInterface.nameErrors , interactorInterface.emailErrors, interactorInterface.phoneErrors, interactorInterface.cpfErrors , interactorInterface.passwordErrors, interactorInterface.passwordConfirmErrors, interactorInterface.password.asObservable(), interactorInterface.passwordConfirm.asObservable(), resultSelector: { (nameErrors, emailErrors, phoneErrors, cpfErrors, passwordErrors, passwordConfirmErrors, password, confirmPassword) -> Bool in
            return !(nameErrors.count > 0 || emailErrors.count > 0 || phoneErrors.count > 0 || cpfErrors.count > 0 || passwordErrors.count > 0 || passwordConfirmErrors.count > 0 || password != confirmPassword )
        })
    }
    
    var createAccountRequestResponse: Observable<RequestResponse<User>>{
        return interactorInterface.createAccountResponse
    }
}
