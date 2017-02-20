//
//  FacebookAPI.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 20/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import RxSwift
import FBSDKLoginKit

class FacebookAPI {
    private static let facebookPermissions = ["public_profile", "email", "user_friends", "user_photos"]
    
    static let sharedInstance = FacebookAPI()
    private let loginManager = FBSDKLoginManager()
    
    func signIn(fromViewController: UIViewController) -> Observable<String>{
        return Observable<String>.create({ [weak self] (observer) -> Disposable in
            guard let strongSelf = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            strongSelf.loginManager.logIn(withReadPermissions: FacebookAPI.facebookPermissions, from: fromViewController) { (result, error) -> Void in
                
                let errorUnknown = NSError(domain: "Facebook Login Failed", code: -1, userInfo: nil)
                
                if let error = error{
                    observer.onError(error)
                }else if (result?.isCancelled)!{
                    observer.onCompleted()
                }else{
                    if let result = result, let token = result.token, let tokenString = token.tokenString{
                        observer.onNext(tokenString)
                    }else{
                        observer.onError(errorUnknown)
                    }
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
    }
    
    func signOut(){
        loginManager.logOut()
    }
}
