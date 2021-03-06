//
//  CreateAccountInteractor.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol CreateAccountInteractorProtocol {
    var userImage: Variable<UIImage?> {get}
    var name: Variable<String> {get}
    var email: Variable<String> {get}
    var phone: Variable<String> {get}
    var cpf: Variable<String> {get}
    var password: Variable<String> {get}
    var passwordConfirm: Variable<String> {get}
    
    var nameErrors: Observable<[NameFieldError]> {get}
    var emailErrors: Observable<[EmailFieldError]> {get}
    var phoneErrors: Observable<[PhoneFieldError]> {get}
    var cpfErrors: Observable<[CpfFieldError]> {get}
    var passwordErrors: Observable<[PasswordFieldError]> {get}
    var passwordConfirmErrors: Observable<[ConfirmPasswordFieldError]> {get}
    var createAccountResponse: Observable<RequestResponse<User>> { get }
    
    func createAccount()
}

class CreateAccountInteractor: BaseInteractor {
    let repository: CreateAccountRepositoryProtocol
    
    fileprivate var disposeBag: DisposeBag!
    
    let userImage = Variable<UIImage?>(nil)
    let name = Variable("")
    let email = Variable("")
    let phone = Variable("")
    let cpf = Variable("")
    let password = Variable("")
    let passwordConfirm = Variable("")
    let createAccountResponseVariable = Variable<RequestResponse<User>>(.new)
    
    init(repository: CreateAccountRepositoryProtocol) {
        self.repository = repository
    }
}

extension CreateAccountInteractor: CreateAccountInteractorProtocol {
    var createAccountResponse: Observable<RequestResponse<User>> {
        return createAccountResponseVariable.asObservable()
    }
    
    var nameErrors: Observable<[NameFieldError]> {
        return self.name
            .asObservable()
            .map { (name) -> [NameFieldError] in
                var fieldErrors = [NameFieldError]()
                
                if name.isEmpty {
                    fieldErrors.append(.empty)
                }
                
                return fieldErrors
        }
    }
    
    var emailErrors: Observable<[EmailFieldError]> {
        return self.email
            .asObservable()
            .map { (email) -> [EmailFieldError] in
                var fieldErrors = [EmailFieldError]()
                
                if email.isEmpty {
                    fieldErrors.append(.empty)
                }
                
                if !email.isValidEmail() {
                    fieldErrors.append(.notValid)
                }
                
                return fieldErrors
        }
    }
    
    var phoneErrors: Observable<[PhoneFieldError]> {
        return self.phone
            .asObservable()
            .map { (phone) -> [PhoneFieldError] in
                var fieldErrors = [PhoneFieldError]()
                
                if phone.isEmpty {
                    fieldErrors.append(.empty)
                }
                
                if phone.count < 10 {
                    fieldErrors.append(.minCharaters(count: 10))
                }
                
                return fieldErrors
        }
    }
    
    var cpfErrors: Observable<[CpfFieldError]> {
        return self.cpf
            .asObservable()
            .map { (cpf) -> [CpfFieldError] in
                var fieldErrors = [CpfFieldError]()
                
                if cpf.isEmpty {
                    fieldErrors.append(.empty)
                }
                
                if !CPF.validate(cpf: cpf) {
                    fieldErrors.append(.notValid)
                }
                
                return fieldErrors
        }
    }
    
    var passwordErrors: Observable<[PasswordFieldError]> {
        return self.password
            .asObservable()
            .map { (password) -> [PasswordFieldError] in
                var fieldErrors = [PasswordFieldError]()
                
                if password.isEmpty {
                    fieldErrors.append(.empty)
                }
                
                if password.count < 6 {
                    fieldErrors.append(.minCharaters(count: 6))
                }
                
                return fieldErrors
        }
    }
    
    var passwordConfirmErrors: Observable<[ConfirmPasswordFieldError]> {
        return Observable.combineLatest(password.asObservable(), passwordConfirm.asObservable(), resultSelector: { (password, passwordConfirm) -> [ConfirmPasswordFieldError] in
            var fieldErrors = [ConfirmPasswordFieldError]()
            
            if password != passwordConfirm {
                fieldErrors.append(.confirmPasswordNotMatch)
            }
            
            return fieldErrors
        })
    }
    
    func createAccount() {
        disposeBag = DisposeBag()
        
        createAccountResponseVariable.value = .loading
        
        repository
            .createWith(name: name.value, email: email.value, phone: phone.value, cpf: cpf.value, password: password.value, image: userImage.value)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event {
                case .success(let userAPI):
                    
                    guard let user = User(userAPI: userAPI) else {
                        strongSelf.createAccountResponseVariable.value = .failure(error: APIClient.error(description: "\(R.string.localizable.messageUserInvalid()) \(userAPI)"))
                        return
                    }
                    
                    strongSelf.createAccountResponseVariable.value = .success(responseObject: user)
                    
                case .error(let error):
                    strongSelf.createAccountResponseVariable.value = .failure(error: error)
                }
            }
            .disposed(by: disposeBag)
    }
}
