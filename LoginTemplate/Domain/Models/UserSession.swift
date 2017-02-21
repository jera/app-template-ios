//
//  UserSession.swift
//  LoginTemplate
//
//  Created by Alessandro Nakamuta on 21/02/17.
//  Copyright © 2017 Jera. All rights reserved.
//

import Foundation

class UserSession{
    private(set) var uid: String
    private(set) var client: String
    private(set) var accessToken: String
    private(set) var currentUser: User
    
    init(uid: String, client: String, accessToken: String, currentUser: User){
        self.uid = uid
        self.client = client
        self.accessToken = accessToken
        self.currentUser = currentUser
    }
    
    convenience init(userSessionDB: UserSessionDB) {
        let user = User(userDB: userSessionDB.currentUser)
        
        self.init(uid: userSessionDB.uid, client: userSessionDB.client, accessToken: userSessionDB.accessToken, currentUser: user)
    }
    
    var authHeaders: [String: String]?{
        return [
            "access-token": accessToken,
            "uid": uid,
            "client": client
        ]
    }
}
