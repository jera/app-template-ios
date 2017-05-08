//
//  MainPresenter.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MainPresenterInterface {
    var authExpiredMessage: Observable<String?> { get }
}

class MainPresenter: BasePresenter, MainPresenterInterface {
    weak var router: MainWireFrame?
    
    private let authExpiredMessageSubject = PublishSubject<String?>()
    var authExpiredMessage: Observable<String?> {
        return authExpiredMessageSubject.asObservable()
    }
    
    private var userSessionInteractorInterfaceDisposeBag: DisposeBag!
    var userSessionInteractorInterface: UserSessionInteractorInterface? {
        didSet {
            bindUserSessionInteractor()
        }
    }
    
    private func bindUserSessionInteractor() {
        
        userSessionInteractorInterfaceDisposeBag = DisposeBag()
        
        userSessionInteractorInterface?.stateObservable
            .subscribe(onNext: { [weak self] (userSessionState) in
                guard let strongSelf = self else { return }
                
                switch userSessionState {
                case .logged:
                    strongSelf.router?.page = MainPage.dashboard
                case .notLogged:
                    strongSelf.router?.page = MainPage.login
                case .authExpired:
                    strongSelf.router?.page = MainPage.login
                    strongSelf.authExpiredMessageSubject.onNext(R.string.localizable.messageExpiredSession())

                }
            })
            .addDisposableTo(userSessionInteractorInterfaceDisposeBag)
    }
    
}
