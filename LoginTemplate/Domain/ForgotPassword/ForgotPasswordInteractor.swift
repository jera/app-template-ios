//
//  ForgotPasswordInteractor.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//
import RxSwift

protocol ForgotPasswordInteractorInterface {
    func sendNewPasswordToEmail()
    
    var forgotPasswordResponse: Observable<RequestResponse<String?>> { get }
    
    var email: Variable<String> {get}
    var emailErrors: Observable<[EmailFieldError]> {get}
}

class ForgotPasswordInteractor: BaseInteractor {
    let repositoryInterface: ForgotPasswordRepositoryInterface
    
    let forgotPasswordResponseVariable = Variable<RequestResponse<String?>>(.new)
    
    let email = Variable("")
    
    fileprivate var forgotPasswordDisposeBag: DisposeBag!
    
    init(repositoryInterface: ForgotPasswordRepositoryInterface) {
        self.repositoryInterface = repositoryInterface
    }
}

extension ForgotPasswordInteractor: ForgotPasswordInteractorInterface {
    var forgotPasswordResponse: Observable<RequestResponse<String?>>{
        return forgotPasswordResponseVariable.asObservable()
    }
    
    func sendNewPasswordToEmail() {
        forgotPasswordDisposeBag = DisposeBag()
        
        forgotPasswordResponseVariable.value = .loading
        
        repositoryInterface
            .sendNewPasswordTo(email: email.value)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event{
                case .next(let message):
                    strongSelf.forgotPasswordResponseVariable.value = .success(responseObject: message)
                    
                case .error(let error):
                    strongSelf.forgotPasswordResponseVariable.value = .failure(error: error)
                case .completed:
                    break
                }
            }
            .addDisposableTo(forgotPasswordDisposeBag)
        
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
}

