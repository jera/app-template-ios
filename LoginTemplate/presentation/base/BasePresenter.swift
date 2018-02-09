//
//  BasePresenter.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 16/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

class BasePresenter {
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}
