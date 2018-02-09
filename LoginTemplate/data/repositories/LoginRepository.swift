//
//  LoginRepository.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 20/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol LoginRepositoryProtocol {
    func authenticate(email: String, password: String) -> Single<UserAPI>
//    func facebookLogin(presenterViewController viewController: UIViewController) -> Single<UserAPI>
//    func googleLogin(presenterViewController viewController: UIViewController) -> Single<UserAPI>
}

class LoginRepository: BaseRepository, LoginRepositoryProtocol {
    let facebookAPI: FacebookAPIProtocol
    let googleAPI: GoogleAPIProtocol
    
    init(apiClient: APIClientProtocol, facebookAPI: FacebookAPIProtocol, googleAPI: GoogleAPIProtocol) {
        self.facebookAPI = facebookAPI
        self.googleAPI = googleAPI
        super.init(apiClient: apiClient)
    }
    
    func authenticate(email: String, password: String) -> Single<UserAPI> {
        return apiClient
            .loginWith(email: email, password: password)

    }

//    func facebookLogin(presenterViewController viewController: UIViewController) -> Single<UserAPI> {
//        return facebookAPI
//            .signIn(fromViewController: viewController)
//            .flatMapLatest { [weak self] (facebookToken) -> Single<UserAPI> in
//                guard let strongSelf = self else {
//                    return Single.error(APIClient.error(description: ""))
//                }
//                return strongSelf.apiClient.loginWithFacebook(token: facebookToken)
//            }
//    }

//    func googleLogin(presenterViewController viewController: UIViewController) -> Single<UserAPI> {
//        return googleAPI
//            .signIn(presentViewController: viewController)
//            .flatMapLatest { [weak self] (facebookToken) -> Single<UserAPI> in
//                guard let strongSelf = self else {
//                    return Single.error(APIClient.error(description: ""))
//                }
//                return strongSelf.apiClient.loginWithGoogle(token: facebookToken)
//        }
//    }
}
