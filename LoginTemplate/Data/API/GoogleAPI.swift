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

protocol GoogleAPIInterface {
    func signIn(presentViewController: UIViewController) -> Observable<String>
    func signOut() -> Observable<Void>
}

class GoogleAPI: NSObject {
    static var shared: GoogleAPIInterface = {
        let googleAPI = GoogleAPI()
        
        GIDSignIn.sharedInstance().delegate = googleAPI
        GIDSignIn.sharedInstance().uiDelegate = googleAPI
        
        return googleAPI
    }()
    
    fileprivate var signInObserver: AnyObserver<String>?
    fileprivate var signOutObserver: AnyObserver<Void>?
    
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

extension GoogleAPI: GoogleAPIInterface {
    func signIn(presentViewController: UIViewController) -> Observable<String> {
        self.presentViewController = presentViewController
        
        return Observable<String>.create({ [weak self] (observer) -> Disposable in
            guard let strongSelf = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            strongSelf.signInObserver = observer
            
            GIDSignIn.sharedInstance().signIn()
            
            return Disposables.create(with: { [weak strongSelf] in
                strongSelf?.signInObserver = nil
            })
        })
    }
    
    func signOut() -> Observable<Void> {
        return Observable<Void>.create({ [weak self] (observer) -> Disposable in
            guard let strongSelf = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            strongSelf.signOutObserver = observer
            
            GIDSignIn.sharedInstance().signOut()
            
            return Disposables.create(with: { [weak strongSelf] in
                strongSelf?.signOutObserver = nil
            })
        })
        
    }
}

extension GoogleAPI: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            signInObserver?.onError(error)
            signInObserver?.onCompleted()
        }else {
            signInObserver?.onNext(user.authentication.accessToken)
            signInObserver?.onCompleted()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            signOutObserver?.onError(error)
            signOutObserver?.onCompleted()
        }else {
            signOutObserver?.onNext(())
            signOutObserver?.onCompleted()
        }
    }
}
