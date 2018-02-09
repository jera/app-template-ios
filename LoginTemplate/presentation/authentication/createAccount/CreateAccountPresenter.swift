//
//  CreateAccountPresenter.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol CreateAccountPresenterProtocol: CreateAccountViewModelProtocol {
    func closeButtonTapped()
}

class CreateAccountPresenter: BasePresenter {
    weak var router: CreateAccountWireFrameProtocol?
    let interactor: CreateAccountInteractorProtocol

    init(interactor: CreateAccountInteractorProtocol) {
        self.interactor = interactor
    }
}

extension CreateAccountPresenter: CreateAccountPresenterProtocol {
    
    var userImage: Observable<UIImage?> {
        return interactor.userImage.asObservable()
    }
    
    var name: Variable<String> {
        return interactor.name
    }
    
    var nameErrorString: Observable<String?> {
        return interactor.nameErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first {
                switch firstError {
                case .empty:
                    return nil //Doesn't show if it is empty
                }
            }
            
            return nil
        })
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
    
    var phone: Variable<String> {
        return interactor.phone
    }
    
    var phoneErrorString: Observable<String?> {
        return interactor.phoneErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first {
                switch firstError {
                case .minCharaters(let count):
                    return R.string.localizable.defaultPhoneValueMinimum("\(count)")
                case .empty:
                    return nil //Doesn't show if it is empty
                }
            }
            
            return nil
        })
    }
    
    var cpf: Variable<String> {
        return interactor.cpf
    }
    
    var cpfErrorString: Observable<String?> {
        return interactor.cpfErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first {
                switch firstError {
                case .notValid:
                    return R.string.localizable.createAccountCpfInvalid()
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
    
    var passwordConfirm: Variable<String> {
        return interactor.passwordConfirm
    }
    
    var passwordConfirmErrorString: Observable<String?> {
        return interactor.passwordConfirmErrors.map({ (fieldErrors) -> String? in
            if let firstError = fieldErrors.first {
                switch firstError {
                case .confirmPasswordNotMatch:
                    return R.string.localizable.createAccountPasswordNotEqual()
                }
            }
            
            return nil
        })
    }

    var createAccountButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(interactor.nameErrors, interactor.emailErrors, interactor.phoneErrors, interactor.cpfErrors, interactor.passwordErrors, interactor.passwordConfirmErrors, interactor.password.asObservable(), interactor.passwordConfirm.asObservable(), resultSelector: { (nameErrors, emailErrors, phoneErrors, cpfErrors, passwordErrors, passwordConfirmErrors, password, confirmPassword) -> Bool in
            return !(!nameErrors.isEmpty || !emailErrors.isEmpty || !phoneErrors.isEmpty || !cpfErrors.isEmpty || !passwordErrors.isEmpty || !passwordConfirmErrors.isEmpty || password != confirmPassword )
        })
    }
    
    var createAccountRequestResponse: Observable<RequestResponse<User>> {
        return interactor.createAccountResponse
    }
    
    func createButtonTapped() {
        interactor.createAccount()
    }
    
    func chooseUserImageButtonTapped() {
        router?.chooseUserImageButtonPressed(showDeleteCurrentImage: interactor.userImage.value != nil)
    }
    
    func closeButtonTapped() {
        router?.dismiss()
    }
}
