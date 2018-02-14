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

    private let disposeBag = DisposeBag()
    
    init(interactor: CreateAccountInteractorProtocol) {
        self.interactor = interactor
        super.init()
        bind()
    }
    
    private func bind() {
        
        interactor.createAccountResponse
            .subscribe(onNext: {[weak self] (response) in
                guard let strongSelf = self else { return }
                
                switch response {
                case .loading:
                    strongSelf.viewStateVariable.value = .loading(PlaceholderViewModel(text: R.string.localizable.alertLoading()))
                    
                case .failure(let error):
                    strongSelf.viewStateVariable.value = .normal
                    strongSelf.alertSubject.onNext(AlertViewModel(title: R.string.localizable.alertTitle(),
                                                                  message: error.localizedDescription,
                                                                  actions: [AlertActionViewModel(title: R.string.localizable.alertOk())]))
                    
                case .success:
                    strongSelf.viewStateVariable.value = .normal
                    
                default:
                    strongSelf.viewStateVariable.value = .normal
                }
            })
            .disposed(by: disposeBag)
    }
}

extension CreateAccountPresenter: CreateAccountPresenterProtocol {
    
    var userImage: Observable<UIImage?> {
        return interactor.userImage.asObservable()
    }
    
    var name: Variable<String> {
        return interactor.name
    }
    
    var email: Variable<String> {
        return interactor.email
    }
    
    var phone: Variable<String> {
        return interactor.phone
    }
    
    var cpf: Variable<String> {
        return interactor.cpf
    }
    
    var password: Variable<String> {
        return interactor.password
    }
    
    var passwordConfirm: Variable<String> {
        return interactor.passwordConfirm
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
