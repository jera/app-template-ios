//
//  ForgotPasswordInteractor.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/14/17.
//  Copyright © 2017 Jera. All rights reserved.
//
import RxSwift

protocol ForgotPasswordInteractorInput {
    func sendNewPasswordTo(email: String)
}

protocol ForgotPasswordInteractorOutput: class {
    func showLoading()
    func showMessageForgotMyPasswordWith(sucess: String)
    func showMessageForgotMyPasswordWith(error: Error)
}

class ForgotPasswordInteractor {
    weak var outputInterface: ForgotPasswordInteractorOutput!
    
    fileprivate var disposeBag: DisposeBag!
}

extension ForgotPasswordInteractor: ForgotPasswordInteractorInput {
    func sendNewPasswordTo(email: String) {
        disposeBag = DisposeBag()
        
        outputInterface.showLoading()
        
        APIClient
            .forgotPasswordWith(email: email)
            .subscribe { [weak self] (event) in
                guard let strongSelf = self else { return }
                
                switch event{
                case .next(let message):
                    strongSelf.outputInterface.showMessageForgotMyPasswordWith(sucess: message ?? "Você receberá um e-mail com instruções sobre como redefinir sua senha.")
                case .error(let error):
                    strongSelf.outputInterface.showMessageForgotMyPasswordWith(error: error)
                case .completed:
                    break
                }
                
            }
            .addDisposableTo(disposeBag)
        }
}

