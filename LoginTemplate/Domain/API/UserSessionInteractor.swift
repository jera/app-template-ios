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
    var stateObservable: Observable<UserSessionState> {get}
    var currentUser: User? { get }
    
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
    static var shared: UserSessionInteractorInterface = UserSessionInteractor()
    
    private let state = Variable<UserSessionState>({
        if let userDB = UserSessionDataStore.retrieveUserSession()?.currentUser{
            return .logged(user: User(name: userDB.name, email: userDB.email))
        }else{
            return .notLogged
        }
    }())
    
    var currentUser: User?{
        switch state.value{
        case .logged(let user):
            return user
        case .authExpired, .notLogged:
            return nil
        }
    }
    
    var stateObservable: Observable<UserSessionState>{
        return state.asObservable()
    }
    
    func userSessionUpdateWith(uid: String, client: String, accessToken: String, userAPI: UserAPI?) throws{
        let user: User?
        if let userAPI = userAPI{
            guard let _user = User(userAPI: userAPI) else {
                throw UserSessionInteractor.error(description: "API retornou um usuário inválido: \(userAPI)")
            }
            
            user = _user
        }else{
            user = nil
        }
        
        if UserSessionDataStore.retrieveUserSession() == nil{
            if let user = user{
                UserSessionDataStore.createUserSession(uid: uid, client: client, accessToken: accessToken, currentUser: UserDB(name: user.name, email: user.email))
                state.value = .logged(user: user)
            }else{
                throw UserSessionInteractor.error(description: "Falha na tentativa de atualizar as credenciais: Não existe sessão de usuário")
            }
        }else{
            let userDB: UserDB?
            if let user = user{
                userDB = UserDB(name: user.name, email: user.email)
            }else{
                userDB = nil
            }
            
            UserSessionDataStore.updateSession(uid: uid, client: client, accessToken: accessToken, currentUser: userDB)
            
            if let user = user{
                state.value = .logged(user: user)
            }
        }
    }
    
    func logout(){
        UserSessionDataStore.deleteUserSession()
        state.value = .notLogged
    }
    
    func expire(){
        UserSessionDataStore.deleteUserSession()
        
        switch state.value{
        case .logged:
            state.value = .authExpired
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
