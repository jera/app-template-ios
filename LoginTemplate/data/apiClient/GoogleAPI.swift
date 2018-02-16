//
//  GoogleAPI.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 20/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import GoogleSignIn
import GGLSignIn
import RxSwift

protocol GoogleAPIProtocol {
    func signIn(presentViewController: UIViewController) -> Single<String>
    func signOut() -> Single<Void>
}

class GoogleAPI: NSObject {
    static var shared: GoogleAPIProtocol = {
        let googleAPI = GoogleAPI()
        
        GIDSignIn.sharedInstance().delegate = googleAPI
        GIDSignIn.sharedInstance().uiDelegate = googleAPI
        
        return googleAPI
    }()
    
    fileprivate var signInSingle: ((SingleEvent<String>) -> ())?
    fileprivate var signOutSingle: ((SingleEvent<Void>) -> ())?
    
    fileprivate weak var presentViewController: UIViewController!
    
    static func configure() {
        // Initialize sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError!)")
    }
}

extension GoogleAPI: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }

    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        presentViewController.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension GoogleAPI: GoogleAPIProtocol {
    func signIn(presentViewController: UIViewController) -> Single<String> {
        self.presentViewController = presentViewController
        
        return Single.create(subscribe: {[weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.error(NSError(domain: "GoogleAPI", code: -2, userInfo: [NSLocalizedDescriptionKey: R.string.localizable.loginGoogleGenericError()])))
                return Disposables.create()
            }

            strongSelf.signInSingle = single
            
            GIDSignIn.sharedInstance().signIn()
            
            return Disposables.create(with: { [weak strongSelf] in
                strongSelf?.signInSingle = nil
            })
        })
    }
    
    func signOut() -> Single<Void> {
        return Single.create(subscribe: {[weak self] (single) -> Disposable in
            guard let strongSelf = self else {
                single(.error(NSError(domain: "GoogleAPI", code: -2, userInfo: [NSLocalizedDescriptionKey: R.string.localizable.loginGoogleGenericError()])))
                return Disposables.create()
            }
            
            strongSelf.signOutSingle = single
            
            GIDSignIn.sharedInstance().signOut()
            
            return Disposables.create(with: { [weak strongSelf] in
                strongSelf?.signOutSingle = nil
            })
        })
    }
}

extension GoogleAPI: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let signInSingle = signInSingle else { return }
        
        if let error = error {
            signInSingle(.error(error))
        }else {
            signInSingle(.success(user.authentication.accessToken))
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        guard let signOutSingle = signOutSingle else { return }
        
        if let error = error {
            signOutSingle(.error(error))
        }else {
            signOutSingle(.success(()))
        }
    }
}
