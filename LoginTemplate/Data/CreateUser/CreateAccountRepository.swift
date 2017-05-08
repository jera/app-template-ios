//
//  CreateUserRepository.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift

protocol CreateAccountRepositoryInterface {
    func createWith(name: String, email: String, phone: String, cpf: String, password: String, image: UIImage?) -> Observable<UserAPI>
}

class CreateAccountRepository: BaseRepository, CreateAccountRepositoryInterface {
    let apiClientInterface: APIClientInterface
    
    init(apiClientInterface: APIClientInterface) {
        self.apiClientInterface = apiClientInterface
    }
    
    func createWith(name: String, email: String, phone: String, cpf: String, password: String, image: UIImage?) -> Observable<UserAPI> {
        return apiClientInterface
            .createNewAccount(name: name, email: email, cpf: cpf, password: password, image: image)
    }
}
