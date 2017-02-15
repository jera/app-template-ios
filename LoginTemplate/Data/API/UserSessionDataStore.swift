//
//  UserSession.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 13/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Foundation

class UserSessionDataStore{
    private static let currentSessionKey = "currentSessionKey"
    private static var cachedUserSession: UserSessionDB?
    
    class func createUserSession(uid: String, client: String, accessToken: String, currentUser: UserDB){
        let newUserSession = UserSessionDB(uid: uid, client: client, accessToken: accessToken, currentUser: currentUser)
        
        saveCurrentSessionWith(userSession: newUserSession)
    }
    
    class func retrieveUserSession() -> UserSessionDB?{
        if let cachedUserSession = cachedUserSession{
            return cachedUserSession
        }
        
        if let data = UserDefaults.standard.object(forKey: currentSessionKey) as? Data,
            let currentSession = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? UserSessionDB{
            
            return currentSession
        }
        
        return nil
    }
    
    @discardableResult class func updateSession(uid: String? = nil, client: String? = nil, accessToken: String? = nil, currentUser: UserDB? = nil) -> Bool{
        guard let userSession = retrieveUserSession() else { return false }
        
        let updatedUserSession = UserSessionDB(uid: uid ?? userSession.uid,
                                                           client: client ?? userSession.client,
                                                           accessToken: accessToken ?? userSession.accessToken,
                                                           currentUser: currentUser ?? userSession.currentUser)
        
        
        saveCurrentSessionWith(userSession: updatedUserSession)
        
        return true
    }
    
    class func deleteUserSession(){
        saveCurrentSessionWith(userSession: nil)
    }
    
    private class func saveCurrentSessionWith(userSession: UserSessionDB?){
        cachedUserSession = userSession
        
        let data: Data?
        if let userSession = userSession{
            data = NSKeyedArchiver.archivedData(withRootObject: userSession) as Data?
        }else{
            data = nil
        }
        
        UserDefaults.standard.set(data, forKey: currentSessionKey)
        UserDefaults.standard.synchronize()
    }
}
