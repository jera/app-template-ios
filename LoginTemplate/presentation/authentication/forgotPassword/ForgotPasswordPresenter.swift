//
//  ForgotPasswordPresenter.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol ForgotPasswordPresenterProtocol: ForgotPasswordViewModelProtocol {
    func didTapCloseForgotPasswordView()
}

class ForgotPasswordPresenter: BasePresenter {
    weak var router: ForgotPasswordWireFrame?
    var interactor: ForgotPasswordInteractorProtocol
    
    private let disposeBag = DisposeBag()

    init(interactor: ForgotPasswordInteractorProtocol) {
        self.interactor = interactor
        super.init()
        bind()
    }
    
    private func bind() {
        
        interactor.forgotPasswordResponse
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
                    
                case .success(let message):
                    strongSelf.viewStateVariable.value = .normal
                    strongSelf.alertSubject.onNext(AlertViewModel(title: R.string.localizable.forgotPasswordCheckYourEmail(),
                                                                  message: message ?? R.string.localizable.forgotPasswordMessage(),
                                                                  actions: [AlertActionViewModel(title: R.string.localizable.alertOk())]))
                    
                default:
                    strongSelf.viewStateVariable.value = .normal
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ForgotPasswordPresenter: ForgotPasswordPresenterProtocol {
    
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
    
    var forgotPasswordButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isEmailEmpty, emailErrorString, resultSelector: { (isEmailEmpty, emailErrorString) -> Bool in
            return !(isEmailEmpty || emailErrorString != nil)
        })
    }
    
    func forgotPasswordButtonTapped() {
        interactor.sendNewPasswordToEmail()
    }
    
    func didTapCloseForgotPasswordView() {
        router?.dismiss()
    }
}
