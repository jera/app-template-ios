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

enum UserSessionState{
    case Logged(user: User)
    case NotLogged
    case AuthExpired
}

//protocol UserSessionInteractorInput {
//    func authenticate(byEmail: String, password:String)
//}

//protocol UserSessionInteractorOutput: class {
//
//}

enum UserSessionInteractorError: Swift.Error {
    case updateCredentailsFailedNoSessionCreated
    case userAPIisInvalid(userAPI: UserAPI)
}

class UserSessionInteractor{
    static private let state = Variable<UserSessionState>({
        if let userDB = UserSessionDataStore.retrieveUserSession()?.currentUser{
            return .Logged(user: User(name: userDB.name, email: userDB.email))
        }else{
            return .NotLogged
        }
    }())
    
    static var currentUser: User?{
        switch state.value{
        case .Logged(let user):
            return user
        case .AuthExpired, .NotLogged:
            return nil
        }
    }
    
    static var stateObservable: Observable<UserSessionState>{
        return state.asObservable()
    }
    
    private class func userSessionUpdateWith(uid: String, client: String, accessToken: String, userAPI: UserAPI?) throws{
        
        let userDB: UserDB?
        if let userAPI = userAPI{
            guard let name = userAPI.name,
                let email = userAPI.email else{
                    throw UserSessionInteractorError.userAPIisInvalid(userAPI: userAPI)
            }
            
            userDB = UserDB(name: name, email: email)
        }else{
            userDB = nil
        }
        
        if UserSessionDataStore.retrieveUserSession() == nil{
            if let currentUser = userDB{
                UserSessionDataStore.createUserSession(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
            }else{
                throw UserSessionInteractorError.updateCredentailsFailedNoSessionCreated
            }
        }else{
            UserSessionDataStore.updateSession(uid: uid, client: client, accessToken: accessToken, currentUser: userDB)
        }
    }
    
    class func userSessionUpdateWith(moyaResponse response: Moya.Response, userAPI: UserAPI? = nil) throws{
        if let httpURLResponse = response.response as? HTTPURLResponse{
            if let uid = httpURLResponse.allHeaderFields["uid"] as? String,
                let client = httpURLResponse.allHeaderFields["client"] as? String,
                let accessToken = httpURLResponse.allHeaderFields["access-token"] as? String{
                
                try userSessionUpdateWith(uid: uid, client: client, accessToken: accessToken, userAPI: userAPI)
            }
        }
    }
    
    class func logout(){
        UserSessionDataStore.deleteUserSession()
        state.value = .NotLogged
    }
    
    class func authExpire(){
        UserSessionDataStore.deleteUserSession()
        state.value = .AuthExpired
    }
}
