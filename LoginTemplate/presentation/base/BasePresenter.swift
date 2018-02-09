//
//  BasePresenter.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift

protocol BasePresenterProtocol {
    
    var viewState: Observable<ViewState> { get }
    var alert: Observable<AlertViewModel> { get }
}

class BasePresenter: NSObject {
    
    internal let viewStateVariable = Variable<ViewState>(.normal)
    internal let alertSubject = PublishSubject<AlertViewModel>()
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}

extension BasePresenter: BasePresenterProtocol {
    
    var viewState: Observable<ViewState> {
        return viewStateVariable.asObservable()
    }
    
    var alert: Observable<AlertViewModel> {
        return alertSubject.asObservable()
    }
}
