//
//  UserSession.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 14/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol UserSessionInteractorInterface {
    var state: UserSessionState {get}
    var stateObservable: Observable<UserSessionState> {get}
    var currentUser: User? { get }
    var userSession: UserSession? { get }
    
    func userSessionUpdateWith(uid: String, client: String, accessToken: String, userAPI: UserAPI?) throws
    func logout()
    func expire()
}

enum UserSessionState{
    case logged(user: User)
    case notLogged
    case authExpired
}

class UserSessionInteractor: UserSessionInteractorInterface{
    static var shared: UserSessionInteractorInterface = UserSessionInteractor(repositoryInterface: UserSessionRepository(dataStore: UserSessionDataStore()))
    
    var repositoryInterface: UserSessionRepositoryInterface
    
    init(repositoryInterface: UserSessionRepositoryInterface){
        self.repositoryInterface = repositoryInterface
    }
    
    private lazy var stateVariable: Variable<UserSessionState> = {
        if let userDB = self.repositoryInterface.retrieveUserSession()?.currentUser{
            return Variable<UserSessionState>(.logged(user: User(name: userDB.name, email: userDB.email)))
        }else{
            return Variable<UserSessionState>(.notLogged)
        }
    }()
    
    var currentUser: User?{
        switch state{
        case .logged(let user):
            return user
        case .authExpired, .notLogged:
            return nil
        }
    }
    
    var stateObservable: Observable<UserSessionState>{
        return stateVariable.asObservable()
    }
    
    var state: UserSessionState{
        return stateVariable.value
    }
    
    var userSession: UserSession?{
        guard let userSessionDB = repositoryInterface.retrieveUserSession() else {
            return nil
        }
        return UserSession(userSessionDB: userSessionDB)
    }
    
    func userSessionUpdateWith(uid: String, client: String, accessToken: String, userAPI: UserAPI?) throws{
        let user: User?
        if let userAPI = userAPI{
            guard let _user = User(userAPI: userAPI) else {
                throw UserSessionInteractor.error(description: "\(R.string.localizable.messageUserInvalid()) \(userAPI)")
            }
            
            user = _user
        }else{
            user = nil
        }
        
        if repositoryInterface.retrieveUserSession() == nil{
            if let user = user{
                repositoryInterface.createUserSession(uid: uid, client: client, accessToken: accessToken, currentUser: UserDB(name: user.name, email: user.email))
                stateVariable.value = .logged(user: user)
            }else{
                throw UserSessionInteractor.error(description: R.string.localizable.messageErrorUpdateCredential())
            }
        }else{
            let userDB: UserDB?
            if let user = user{
                userDB = UserDB(name: user.name, email: user.email)
            }else{
                userDB = nil
            }
            
            repositoryInterface.updateSession(uid: uid, client: client, accessToken: accessToken, currentUser: userDB)
            
            if let user = user{
                stateVariable.value = .logged(user: user)
            }
        }
    }
    
    func logout(){
        repositoryInterface.deleteUserSession()
        stateVariable.value = .notLogged
    }
    
    func expire(){
        repositoryInterface.deleteUserSession()
        
        switch stateVariable.value{
        case .logged:
            stateVariable.value = .authExpired
        default:
            break
        }
    }
}

extension UserSessionInteractor{
    static let errorDomain = "UserSessionInteractorErrorDomain"
    static func error(description: String, code: Int = 0) -> NSError{
        return NSError(domain: errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: description])
    }
}
