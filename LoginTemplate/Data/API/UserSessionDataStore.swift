//
//  UserSession.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 13/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Foundation

protocol UserSessionDataStoreInterface{
    func createUserSession(uid: String, client: String, accessToken: String, currentUser: UserDB)
    func retrieveUserSession() -> UserSessionDB?
    func updateSession(uid: String?, client: String?, accessToken: String?, currentUser: UserDB?) -> Bool
    func deleteUserSession()
}

class UserSessionDataStore: UserSessionDataStoreInterface{
    private static let currentSessionKey = "currentSessionKey"
    
    func createUserSession(uid: String, client: String, accessToken: String, currentUser: UserDB){
        let newUserSession = UserSessionDB(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
        
        saveCurrentSessionWith(userSession: newUserSession)
    }
    
    func retrieveUserSession() -> UserSessionDB?{
        if let data = UserDefaults.standard.object(forKey: UserSessionDataStore.currentSessionKey) as? Data,
            let currentSession = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? UserSessionDB{
            
            return currentSession
        }
        
        return nil
    }
    
    @discardableResult func updateSession(uid: String? = nil, client: String? = nil, accessToken: String? = nil, currentUser: UserDB? = nil) -> Bool{
        guard let userSession = retrieveUserSession() else { return false }
        
        let updatedUserSession = UserSessionDB(uid: uid ?? userSession.uid,
                                                           client: client ?? userSession.client,
                                                           accessToken: accessToken ?? userSession.accessToken,
                                                           currentUser: currentUser ?? userSession.currentUser)
        
        
        saveCurrentSessionWith(userSession: updatedUserSession)
        
        return true
    }
    
    func deleteUserSession(){
        saveCurrentSessionWith(userSession: nil)
    }
    
    private func saveCurrentSessionWith(userSession: UserSessionDB?){
        let data: Data?
        if let userSession = userSession{
            data = NSKeyedArchiver.archivedData(withRootObject: userSession) as Data?
        }else{
            data = nil
        }
        
        UserDefaults.standard.set(data, forKey: UserSessionDataStore.currentSessionKey)
        UserDefaults.standard.synchronize()
    }
}
