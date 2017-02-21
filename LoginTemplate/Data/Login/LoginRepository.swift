//
//  LoginRepository.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 20/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift

protocol LoginRepositoryInterface{
    func authenticate(email: String, password: String) -> Observable<UserAPI>
    
    func facebookLogin(presenterViewController viewController: UIViewController) -> Observable<UserAPI>
    func googleLogin(presenterViewController viewController: UIViewController) -> Observable<UserAPI>
}

class LoginRepository: LoginRepositoryInterface {
    let apiClientInterface: APIClientInterface
    let facebookAPIInterface: FacebookAPIInterface
    let googleAPIInterface: GoogleAPIInterface
    
    init(apiClientInterface: APIClientInterface, facebookAPIInterface: FacebookAPIInterface, googleAPIInterface: GoogleAPIInterface){
        self.apiClientInterface = apiClientInterface
        self.facebookAPIInterface = facebookAPIInterface
        self.googleAPIInterface = googleAPIInterface
    }
    
    func authenticate(email: String, password: String) -> Observable<UserAPI>{
        return apiClientInterface
            .loginWith(email: email, password: password)

    }
    
    func facebookLogin(presenterViewController viewController: UIViewController) -> Observable<UserAPI> {
        return facebookAPIInterface
            .signIn(fromViewController: viewController)
            .flatMapLatest { [weak self] (facebookToken) -> Observable<UserAPI> in
                guard let strongSelf = self else{
                    return Observable.empty()
                }
                return strongSelf.apiClientInterface.loginWithFacebook(token: facebookToken)
            }
    }
    
    func googleLogin(presenterViewController viewController: UIViewController) -> Observable<UserAPI> {
        return googleAPIInterface
            .signIn(presentViewController: viewController)
            .flatMapLatest { [weak self] (facebookToken) -> Observable<UserAPI> in
                guard let strongSelf = self else{
                    return Observable.empty()
                }
                return strongSelf.apiClientInterface.loginWithGoogle(token: facebookToken)
        }
    }
}
