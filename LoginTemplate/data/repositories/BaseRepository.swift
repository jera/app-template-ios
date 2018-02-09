//
//  BaseRepository.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

class BaseRepository {
    
    internal let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
}
