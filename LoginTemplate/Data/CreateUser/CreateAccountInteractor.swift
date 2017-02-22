//
//  CreateAccountInteractor.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol CreateAccountInteractorInterface {
    func createAccount()
    var createAccountResponse: Observable<RequestResponse<User>> { get }
    
//    var name: Variable<String> {get}
//    var nameErrors: Observable<[EmailFieldError]> {get}
    
    var email: Variable<String> {get}
    var emailErrors: Observable<[EmailFieldError]> {get}
    
//    var phone: Variable<String> {get}
//    var phoneErrors: Observable<[EmailFieldError]> {get}
    
//    var cpf: Variable<String> {get}
//    var cpfErrors: Observable<[EmailFieldError]> {get}
    
    var password: Variable<String> {get}
    var passwordErrors: Observable<[PasswordFieldError]> {get}
    
//    var passwordConfirm: Variable<String> {get}
//    var passwordConfirmErrors: Observable<[PasswordFieldError]> {get}
}

class CreateAccountInteractor: BaseInteractor {
    let repositoryInterface: CreateAccountRepositoryInterface
    
    fileprivate var createAccountDisposeBag: DisposeBag!
    let createAccountResponseVariable = Variable<RequestResponse<User>>(.new)
    
    let name = Variable("")
    let email = Variable("")
    let phone = Variable("")
    let cpf = Variable("")
    let password = Variable("")
    let passwordConfirm = Variable("")
    let image = Variable<UIImage?>(nil)
    
    init(repositoryInterface: CreateAccountRepositoryInterface) {
        self.repositoryInterface = repositoryInterface
    }
}

extension CreateAccountInteractor: CreateAccountInteractorInterface{
    var createAccountResponse: Observable<RequestResponse<User>>{
        return createAccountResponseVariable.asObservable()
    }
    
    func createAccount(){
        createAccountDisposeBag = DisposeBag()
        
        createAccountResponseVariable.value = .loading
        
        repositoryInterface
            .createWith(name: name.value, email: email.value, phone: phone.value, cpf: cpf.value, password: password.value, image: image.value)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event{
                case .next(let userAPI):
                    
                    guard let user = User(userAPI: userAPI) else{
                        strongSelf.createAccountResponseVariable.value = .failure(error: APIClient.error(description: "API retornou um usuário inválido: \(userAPI)"))
                        return
                    }
                    
                    strongSelf.createAccountResponseVariable.value = .success(responseObject: user)
                    
                case .error(let error):
                    strongSelf.createAccountResponseVariable.value = .failure(error: error)
                case .completed:
                    break
                }
            }
            .addDisposableTo(createAccountDisposeBag)
    }
    
    var emailErrors: Observable<[EmailFieldError]>{
        return self.email
            .asObservable()
            .map { (email) -> [EmailFieldError] in
                var fieldErrors = [EmailFieldError]()
                
                if email.characters.count == 0 {
                    fieldErrors.append(.empty)
                }
                
                if !DomainHelper.isEmailValid(email: email){
                    fieldErrors.append(.notValid)
                }
                
                return fieldErrors
        }
    }
    
    var passwordErrors: Observable<[PasswordFieldError]>{
        return self.password
            .asObservable()
            .map { (password) -> [PasswordFieldError] in
                var fieldErrors = [PasswordFieldError]()
                
                if password.characters.count == 0 {
                    fieldErrors.append(.empty)
                }
                
                if password.characters.count < 6{
                    fieldErrors.append(.minCharaters(count: 6))
                }
                
                return fieldErrors
        }
    }
}
