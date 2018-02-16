//
//  ForgotPasswordRepository.swift
//  LoginTemplate
//
//  Created by Junio Moquiuti on 2/21/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit
import RxSwift

protocol ForgotPasswordRepositoryProtocol {
    func sendNewPasswordTo(email: String) -> Single<String?>
}

class ForgotPasswordRepository: BaseRepository, ForgotPasswordRepositoryProtocol {

    func sendNewPasswordTo(email: String) -> Single<String?> {
        return apiClient
            .forgotPasswordWith(email: email)
    }
}
