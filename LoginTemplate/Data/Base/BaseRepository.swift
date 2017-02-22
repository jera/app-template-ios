//
//  BaseRepository.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

class BaseRepository {
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}
