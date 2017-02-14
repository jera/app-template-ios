//
//  UserSession.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 14/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Moya
import RxSwift

enum UserSessionState{
    case Logged(user: UserAPI)
    case NotLogged
    case AuthExpired
}

class UserSession{
    static private let state = Variable<UserSessionState>(
        UserSessionDataSource.retrieveUserSession()?.currentUser != nil ?
            .Logged(user: UserSessionDataSource.retrieveUserSession()!.currentUser) :
            .NotLogged
    )
    
    static var currentUser: UserAPI?{
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
    
    static var authHeaders: [String: String]?{
        guard let userSession = UserSessionDataSource.retrieveUserSession() else {
            return nil
        }
        
        return [
            "access-token": userSession.accessToken,
            "uid": userSession.uid,
            "client": userSession.client
        ]
    }
    
    private class func sessionCredentialsUpdateWith(uid: String, client: String, accessToken: String, currentUser: UserAPI? = nil){
        if UserSessionDataSource.retrieveUserSession() == nil{
            if let currentUser = currentUser{
                UserSessionDataSource.createUserSession(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
                state.value = .Logged(user: currentUser)
            }
        }else{
            if UserSessionDataSource.updateSession(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser){
                if let currentUser = currentUser{
                    state.value = .Logged(user: currentUser)
                }
            }
        }
    }
    
    class func sessionCredentialsUpdateWith(moyaResponse response: Moya.Response, currentUser: UserAPI? = nil){
        if let httpURLResponse = response.response as? HTTPURLResponse{
            if let uid = httpURLResponse.allHeaderFields["uid"] as? String,
                let client = httpURLResponse.allHeaderFields["client"] as? String,
                let accessToken = httpURLResponse.allHeaderFields["access-token"] as? String{
                
                self.sessionCredentialsUpdateWith(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
            }
        }
    }
    
    class func logout(){
        UserSessionDataSource.deleteUserSession()
        state.value = .NotLogged
    }
    
    class func authExpire(){
        UserSessionDataSource.deleteUserSession()
        state.value = .AuthExpired
    }
}
