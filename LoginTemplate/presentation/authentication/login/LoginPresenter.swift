//
//  LoginPresenter.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol LoginPresenterProtocol: LoginViewModelProtocol {
    
}

class LoginPresenter: BasePresenter {
    weak var viewProtocol: LoginViewProtocol?
    weak var router: LoginWireFrameProtocol?
    let interactor: LoginInteractorProtocol
    
    private var disposeBag = DisposeBag()
    
    init(interactor: LoginInteractorProtocol) {
        self.interactor = interactor
        super.init()
    }
    
    private func bind() {
        
        interactor.authenticateResponse
            .subscribe(onNext: {[weak self] (response) in
                guard let _ = self else { return }
                
//                switch response {
//                case .loading:
//                    strongSelf.viewStateVariable.value = .loading(PlaceholderViewModel(text: R.string.localizable.alertLoading()))
//
//                case .failure:
//                    strongSelf.viewStateVariable.value = .normal
//
//                case .success:
//                    strongSelf.viewStateVariable.value = .normal
//                default:
//                    strongSelf.viewStateVariable.value = .normal
//
//                }
            })
            .disposed(by: disposeBag)
    }
}

extension LoginPresenter: LoginPresenterProtocol {
    
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
    
    var loginRequestResponse: Observable<RequestResponse<User>> {
        return interactor.authenticateResponse
    }
    
    var facebookRequestResponse: Observable<RequestResponse<User>> {
        return interactor.facebookLoginResponse
    }
    
    var googleRequestResponse: Observable<RequestResponse<User>> {
        return interactor.googleLoginResponse
    }
    
    var loginButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(interactor.emailErrors, interactor.passwordErrors, resultSelector: { (emailErrors, passwordErrors) -> Bool in
            return !(!emailErrors.isEmpty || !passwordErrors.isEmpty)
        })
    }
    
    func loginButtonTapped() {
        interactor.authenticate()
    }
    
    func createAccountButtonTapped() {
        router?.goToCreateAccount()
    }
    
    func forgotPasswordButtonTapped() {
        router?.goToForgotPassword()
    }
    
    func facebookLoginButtonTapped() {
        guard let viewProtocol = viewProtocol as? UIViewController else { return }
        interactor.facebookLogin(presenterViewController: viewProtocol)
    }
    
    func googleLoginButtonTapped() {
        guard let viewProtocol = viewProtocol as? UIViewController else { return }
        interactor.googleLogin(presenterViewController: viewProtocol)
    }
}
