//
//  UserSessionRepository.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 21/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import UIKit

protocol UserSessionRepositoryInterface{
    func createUserSession(uid: String, client: String, accessToken: String, currentUser: UserDB)
    func retrieveUserSession() -> UserSessionDB?
    @discardableResult func updateSession(uid: String?, client: String?, accessToken: String?, currentUser: UserDB?) -> Bool
    func deleteUserSession()
}

class UserSessionRepository: UserSessionRepositoryInterface {
    private var cachedUserSession: UserSessionDB?
    let dataStore: UserSessionDataStoreInterface
    
    init(dataStore: UserSessionDataStoreInterface){
        self.dataStore = dataStore
    }
    
    func createUserSession(uid: String, client: String, accessToken: String, currentUser: UserDB){
        dataStore.createUserSession(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
    }
    
    func retrieveUserSession() -> UserSessionDB?{
        if let cachedUserSession = cachedUserSession{
            return cachedUserSession
        }
        
       return dataStore.retrieveUserSession()
    }
    
    @discardableResult func updateSession(uid: String? = nil, client: String? = nil, accessToken: String? = nil, currentUser: UserDB? = nil) -> Bool{
        return dataStore.updateSession(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
    }
    
    func deleteUserSession(){
        dataStore.deleteUserSession()
    }
}
