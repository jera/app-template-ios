//
//  ForgotPasswordRepository.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/21/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol ForgotPasswordRepositoryInterface {
    func sendNewPasswordTo(email: String) -> Observable<String?>
}

class ForgotPasswordRepository: BaseRepository, ForgotPasswordRepositoryInterface {
    let apiClientInterface: APIClientInterface
    
    init(apiClientInterface: APIClientInterface) {
        self.apiClientInterface = apiClientInterface
    }
    
    func sendNewPasswordTo(email: String) -> Observable<String?> {
        return apiClientInterface
            .forgotPasswordWith(email: email)
    }
}
