//
//  UserSession.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 13/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Foundation

class UserSessionDataSource{
    private static let currentSessionKey = "currentSessionKey"
    private static var cachedUserSessionStorage: UserSessionStorage?
    
    class func createUserSession(uid: String, client: String, accessToken: String, currentUser: UserAPI){
        let newUserSessionStorage = UserSessionStorage(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
        
        saveCurrentSessionWith(userSessionStorage: newUserSessionStorage)
    }
    
    class func retrieveUserSession() -> UserSessionStorage?{
        if let cachedUserSessionStorage = cachedUserSessionStorage{
            return cachedUserSessionStorage
        }
        
        if let data = UserDefaults.standard.object(forKey: currentSessionKey) as? Data,
            let currentSession = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? UserSessionStorage{
            
            return currentSession
        }
        
        return nil
    }
    
    class func updateSession(uid: String? = nil, client: String? = nil, accessToken: String? = nil, currentUser: UserAPI? = nil) -> Bool{
        guard let userSessionStorage = retrieveUserSession() else { return false }
        
        let updatedUserSessionStorage = UserSessionStorage(uid: uid ?? userSessionStorage.uid,
                                                           client: client ?? userSessionStorage.client,
                                                           accessToken: accessToken ?? userSessionStorage.accessToken,
                                                           currentUser: currentUser ?? userSessionStorage.currentUser)
        
        
        saveCurrentSessionWith(userSessionStorage: updatedUserSessionStorage)
        
        return true
    }
    
    class func deleteUserSession(){
        saveCurrentSessionWith(userSessionStorage: nil)
    }
    
    private class func saveCurrentSessionWith(userSessionStorage: UserSessionStorage?){
        cachedUserSessionStorage = userSessionStorage
        
        let data: Data?
        if let userSessionStorage = userSessionStorage{
            data = NSKeyedArchiver.archivedData(withRootObject: userSessionStorage) as Data?
        }else{
            data = nil
        }
        
        UserDefaults.standard.set(data, forKey: currentSessionKey)
        UserDefaults.standard.synchronize()
    }
}
