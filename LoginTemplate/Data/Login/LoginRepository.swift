//
//  LoginRepository.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 20/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol LoginRepositoryProtocol {
    func authenticate(email: String, password: String) -> Observable<UserAPI>
    
    func facebookLogin(presenterViewController viewController: UIViewController) -> Observable<UserAPI>
    func googleLogin(presenterViewController viewController: UIViewController) -> Observable<UserAPI>
}

class LoginRepository: BaseRepository, LoginRepositoryProtocol {
    let apiClient: APIClientProtocol
    let facebookAPI: FacebookAPIProtocol
    let googleAPI: GoogleAPIProtocol
    
    init(apiClient: APIClientProtocol, facebookAPI: FacebookAPIProtocol, googleAPI: GoogleAPIProtocol) {
        self.apiClient = apiClient
        self.facebookAPI = facebookAPI
        self.googleAPI = googleAPI
    }
    
    func authenticate(email: String, password: String) -> Observable<UserAPI> {
        return apiClient
            .loginWith(email: email, password: password)

    }
    
    func facebookLogin(presenterViewController viewController: UIViewController) -> Observable<UserAPI> {
        return facebookAPI
            .signIn(fromViewController: viewController)
            .flatMapLatest { [weak self] (facebookToken) -> Observable<UserAPI> in
                guard let strongSelf = self else {
                    return Observable.empty()
                }
                return strongSelf.apiClient.loginWithFacebook(token: facebookToken)
            }
    }
    
    func googleLogin(presenterViewController viewController: UIViewController) -> Observable<UserAPI> {
        return googleAPI
            .signIn(presentViewController: viewController)
            .flatMapLatest { [weak self] (facebookToken) -> Observable<UserAPI> in
                guard let strongSelf = self else {
                    return Observable.empty()
                }
                return strongSelf.apiClient.loginWithGoogle(token: facebookToken)
        }
    }
}
