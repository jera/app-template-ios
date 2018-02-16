//
//  FacebookAPI.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 20/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift
import RxCocoa
import FBSDKLoginKit

protocol FacebookAPIProtocol {
    func signIn(fromViewController: UIViewController) -> Single<String>
    func signOut()
}

class FacebookAPI: FacebookAPIProtocol {
    private static let facebookPermissions = ["public_profile", "email"]
    
    private let loginManager = FBSDKLoginManager()
    
    func signIn(fromViewController: UIViewController) -> Single<String> {
        return Single.create(subscribe: {[weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.error(NSError(domain: "FacebookAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: R.string.localizable.loginFacebookGenericError()])))
                return Disposables.create()
            }
            
            strongSelf.loginManager.logIn(withReadPermissions: FacebookAPI.facebookPermissions, from: fromViewController) { (result, error) -> Void in
                if let error = error {
                    single(.error(error))
                }else if (result?.isCancelled)! {
                    single(.error(NSError(domain: "FacebookAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: R.string.localizable.loginFacebookCanceled()])))
                }else {
                    if let result = result, let token = result.token, let tokenString = token.tokenString {
                        single(.success(tokenString))
                    }else {
                        single(.error(NSError(domain: "FacebookAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: R.string.localizable.loginFacebookGenericError()])))
                    }
                }
            }
            
            return Disposables.create()
        })
    }
    
    func signOut() {
        loginManager.logOut()
    }
}
