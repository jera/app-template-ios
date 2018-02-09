//
//  CreateUserRepository.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 22/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift

protocol CreateAccountRepositoryProtocol {
    func createWith(name: String, email: String, phone: String, cpf: String, password: String, image: UIImage?) -> Single<UserAPI>
}

class CreateAccountRepository: BaseRepository, CreateAccountRepositoryProtocol {

    func createWith(name: String, email: String, phone: String, cpf: String, password: String, image: UIImage?) -> Single<UserAPI> {
        return apiClient
            .createNewAccount(name: name, email: email, cpf: cpf, password: password, image: image)
    }
}
